#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
@Project{Coway analysis:2018.11 ~ 2019.01
  source name     = case_III_rules.py
  author          = Kyung Ho, Ku
  description     = "case_III : only specific values"
  create date     = 2019.01.31
  last modifier   = Kyung Ho, Ku
  update content  = first release
}
'''

## need packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from functools import reduce
from datetime import datetime, timedelta 
import statsmodels
import operator
import os
from tqdm import tqdm
import copy

## 그래프용
colors = ['#34495e','#2ecc71','#3498db','#FFFF00', '#e74c3c','#a9a9a9']
s_list = pd.date_range(pd.to_datetime('2018-05-01', format='%Y-%m-%d %H:%M:%S.%f'), periods=31).tolist()
e_list = pd.date_range(pd.to_datetime('2018-05-02', format='%Y-%m-%d %H:%M:%S.%f'), periods=31).tolist()
sns.set(style="ticks", color_codes=True)
plt.style.use('seaborn-darkgrid')

## 파일위치
filepath   = '../data/'
filename = 'processed_whole_data.csv'
outputpath = './'


## 전처리 완료된 data load
## shape (None, 44)
## columns = ['dev_id', 'dev_dt', 'pm25', 'pm10', 'voc_ref', 'voc_now', 'humi', 'temp', 'lux', 'co2', 'pm10_idx', 'pm25_idx', 'vocs_idx', 'co2_idx', 'iaq_idx_x', 'unpl_idx', 'polt_idx', 'dt_x', 'invnr', 'inbdt', 'use_cust_id', 'pyn', 'room_cnt', 'do_nm', 'ct_nm', 'gu_nm', 'dng_nm', 'apts_in_date', 'bldg_tp', 'rtn_conf_dt', 'age', 'sex', 'cust_tpnm', 'pwr_stng', 'mode_stng', 'fan_speed_adj', 'light_stng', 'eco_mode_stng', 'iaq_idx_y', 'oaq_idx', 'ventil_alrm', 'cover_alrm_l', 'cover_alrm_r', 'dt_y']
case_III_raw = pd.read_csv(filepath + 'processed_whole_data.csv', parse_dates=['dev_dt'])

## 전체 데이터 비율확인용 변수
names = case_III_raw['dev_id'].unique()
names.sort

## case III pm10이 특정값 들로만 센싱되는 경우
# - target device '16302D8F15B1300011'
# - 하루 기준 pm10 최빈값 5개의 비율이 80%를 이루는 일이 device별 7일 이상인 device들 중에서
#     - PM10=0이 최빈값인 경우
#     - 나머지

## 디바이스별 데이터 생성
device_data = [case_III_raw[case_III_raw['dev_id'] == name] for name in tqdm(names)]

## 띠가 형성되는 device 검출
## 각 디바이스별/일별 top 5 최빈값 비율 측정
case_III_counting_result = [pd.pivot_table(d, index='pm10', columns='day', values='dev_dt', aggfunc=lambda x: len(x.unique()), dropna=True) for d in device_data]
det_count = lambda x: [x.loc[:, v].nlargest(5).values for v in x.columns.values]
case_III_counting_top5 = [np.array(list(map(sum, det_count(d)))) / d.T.apply(lambda x:x.sum(), axis=1).values for d in tqdm(case_III_counting_result)]

## 최빈값 5개가 일기준 80% 이상
## 이러한 날이 7일 이상인
rate_03 = 0.80
days_03 = 7

## 해당 디바이스의 최빈값 10개의 그래프
test_case = case_III_raw.groupby(['dev_id'])['pm10'].apply(lambda x: x.value_counts().iloc[:10])
test_case = test_case.reset_index(level=1, name='count')
test_case.reset_index(inplace=True)

target_data1 = test_case.loc[test_case['dev_id'] == '19202ER01672200035']
target_data2 = test_case.loc[test_case['dev_id'] == '16102D8F15C2200049']
fig = plt.figure(figsize=(30,10))
ax01 = plt.subplot2grid((2,4), (0,0), colspan=2, rowspan=2)
sns.barplot(x='level_1', y='count', data = target_data1)
ax02 = plt.subplot2grid((2,4), (0,2), colspan=2, rowspan=2, sharey=ax01)
sns.barplot(x='level_1', y='count', data = target_data2)

## 특정 device 검증
## eye-check기준의 cut-off설정
target_data = pd.DataFrame(case_III_counting_top5[513], columns=['counting_top5_ratio'])
target_data.reset_index(inplace=True)
target_data['color'] = np.where(target_data['counting_top5_ratio'] > rate_03 , "#3498db", "#FFFFFF")
fig = plt.figure(figsize=(20,10))
sns.regplot(x='index', y='counting_top5_ratio', data=target_data, fit_reg=False, scatter_kws={'facecolors':target_data['color']})
plt.axhline(0.8, color='r', linestyle='--', alpha=0.5)

## 일수 확인
case_III_counting_days = [np.sum(d > rate_03) for d in tqdm(case_III_counting_top5)]
case_III_result = pd.concat([pd.Series(names, name='dev_id'), pd.Series(case_III_counting_days, name='days')], axis=1)
case_III_target = case_III_result.loc[case_III_result['days'] > days_03, : ].sort_values('days', ascending=False)

## 띠가 형성된 device 목록
case_III_names = case_III_target['dev_id'].unique().tolist()

## 해당 case 디바이스 최빈값 5개와 count
case_III_devices = case_III_raw.loc[case_III_raw['dev_id'].isin(case_III_names)].copy()
case_III_devices_result = case_III_devices.groupby(['dev_id'])['pm10'].apply(lambda x: x.value_counts().iloc[:5])
case_III_devices_result = case_III_devices_result.reset_index(level=1, name='count')
case_III_devices_result.reset_index(inplace=True)

## 특정 디바이스의 일별 최빈값 5 확인
case_III_devices_result.loc[case_III_devices_result['dev_id'] == '16102D8F15C0900113']

## PM10 최빈값이 0 케이스 검출
# - 정상데이터(하루 1440건 * 31일 기준 44640)을 기준으로 15000건 이상 PM10이 차지할 경우
det_pm10_most = lambda x, y: (x == 0) & (y > 15000)
case_III_pm10 = case_III_devices_result.loc[det_pm10_most(case_III_devices_result['level_1'], case_III_devices_result['count']), :]

## 컴출 디바이스 갯수와 비율 확인
print(len(case_III_pm10), len(case_III_pm10) / len(names))


