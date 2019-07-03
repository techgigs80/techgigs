#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
@Project{Coway analysis:2018.11 ~ 2019.01
  source name     = case_I_rules.py
  author          = Kyung Ho, Ku
  description     = "case_I : pm10 high in slient mode"
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
case_I_raw = pd.read_csv(filepath + 'processed_whole_data.csv', parse_dates=['dev_dt'])

## 전체 데이터 비율확인용 변수
names = case_I_raw['dev_id'].unique()
names.sort

# case I. 정음모드 일때 PM10이 높은경우
# 정음모드(mode_stng = 2)
# pm10 >= bad (80) 의 비율이 50% 이상인 날이 30일 기준의 7일 이상
# 조도가 lux(<= 500)인 경우
# target device '17202D8F1732300091' day : 15 16 21 22 26

## pm10이 80넘는지를 확인하는 flag
det_pm10_grade = lambda d: 1 if d >= 80 else 0
case_I_raw['pm10_grade'] = list(map(det_pm10_grade, case_I_raw['pm10']))

## 정음모드이며, 조도가 500 이하인 데이터 슬라이싱
target_device_data = case_I_raw.loc[(case_I_raw['mode_stng'] == 2) & (case_I_raw['lux'] <= 500), :]

## 디바이스별, 일별, pm10 이상수치 카운팅
case_I_counting_result = pd.pivot_table(target_device_data, values='pm10_grade', index='dev_id', columns='day', aggfunc=(lambda x: x.sum()))

## 각 디바이스별 해당 데이터의 갯수 카운트
counting_rows = target_device_data.groupby(['dev_id', 'day'])['dev_id'].value_counts()
counting_target_devices = target_device_data['dev_id'].unique().tolist()

## 각 디바이스별 데이터 중 이상 데이터의 비율계산
case_I_result_list = []
for t in tqdm(counting_target_devices):
    temp = pd.Series(case_I_counting_result.loc[t] / counting_rows[t], name=t)
    temp = temp.reset_index(level=1, name=t)
    case_I_result_list.append(temp[t])

case_I_result = pd.concat(case_I_result_list, axis=1).T

## Case I의 이상데이터 비율과 기준일자
rate_01 = 0.50
days_01 = 7

## 특정 device 검증
test_data = case_I_result.loc['17202D8F1732300091'].copy()
test_data = test_data.reset_index(name='pm10_ratio')

## 비율넘는 케이스 확인
test_data.loc[test_data['pm10_ratio'] > rate_01]

## eye-check기준의 cut-off설정
target_days = [1, 2, 4, 6, 7, 11, 12, 14, 15, 16, 22, 25, 26, 27]
test_data['color'] = np.where(np.isin(test_data['day'], target_days) , "#3498db", "#FFFFFF")

## 해당 디바이스의 일별 pm10의 이상비율 그래프 그리기
test_data = test_data.loc[test_data['pm10_ratio'].notnull()]
fig = plt.figure(figsize=(20,10))
sns.regplot(x='day', y='pm10_ratio', data=test_data, fit_reg=False, scatter_kws={'facecolors':test_data['color']})
plt.axhline(rate_01,  color='r', linestyle='--', alpha=0.5)
plt.title('Device 17202D8F1732300091 abnormal pm10 ratio')

## 디바이스별 해당 이상상태가 조건에 부합하는 일 계산
case_I_devices = pd.DataFrame((case_I_result > rate_01).apply(np.sum, axis=1), columns=['days'])
case_I_devices.reset_index(inplace=True)
case_I_devices.columns = ['dev_id', 'days']

## 해당 이상상태일이 7일 이상인 device 목록
case_I_devices.loc[case_I_devices['days'] > days_01].sort_values('days', ascending=False)

## 해당 디바이스 비율계산
len(case_I_devices.loc[case_I_devices['days'] > days_01].sort_values('days', ascending=False)) / len(names)