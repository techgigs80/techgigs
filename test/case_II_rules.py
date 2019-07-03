#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
@Project{Coway analysis:2018.11 ~ 2019.01
  source name     = case_II_rules.py
  author          = Kyung Ho, Ku
  description     = "case_II : capacity problem"
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
case_II_raw = pd.read_csv(filepath + 'processed_whole_data.csv', parse_dates=['dev_dt'])

## 전체 데이터 비율확인용 변수
names = case_II_raw['dev_id'].unique()
names.sort

## case II 청정기가 최대로 동작하는데 PM10이 낮아지지 않는 경우(capa.)
# (fan_speed_adj == 3)인 PM10데이터들의 평균이 800 초과이고 표준편차가 100미만 경우
# 이러한 이상상태가 한달 기준(30일 * 48 단위시간슬롯 = 1440회)기준 50회 초과 : 약 25시간 이상인 디바이스임
# target device = '19202D8F1662200333'

## 하루를 30분단위 0 ~ 47로 나타냄
minute_class = pd.date_range(pd.to_datetime('1900-01-01 00:00:00', format='%Y-%m-%d %H:%M:%S.%f'), pd.to_datetime('1900-01-02 00:00:00', format='%Y-%m-%d %H:%M:%S.%f'), freq="30min").tolist()
minute_label = list(range(48))

convert_time = lambda x : pd.to_datetime(x.strftime(format='%H%M'), format='%H%M')
case_II_raw['min_class'] = pd.cut(case_II_raw['dev_dt'].apply(convert_time), bins=minute_class, labels=minute_label, include_lowest=True)

## 각 시간단위 별 fan_speed_adj==3인 데이터들의 평균과 표준편차 구하기
case_II_result = case_II_raw.loc[case_II_raw['fan_speed_adj'] == 3].groupby(['dev_id', 'day', 'min_class'])['pm10'].agg([np.nanmean, np.nanstd])
case_II_result.reset_index(inplace=True)

## Case II의 이상데이터 평균과 표준편차
cut_mean_02 = 800
cut_std_02 = 100
cut_count  = 50

## 특정 device 검증
## 특정 디바이스의 검증일 25일
test_data = case_II_result[case_II_result['dev_id'] == '19202D8F1662200333'].copy()
day = 25
test_data = test_data.loc[test_data['day'] == day]

## eye-check기준의 cut-off설정
target_time = [21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47]
test_data['color'] = np.where(np.isin(test_data['min_class'], target_time) , "#3498db", "#FFFFFF")
test_data['min_class'] = test_data['min_class'].astype('int')

## 해당 디바이스의 일별 pm10의 이상비율 그래프 그리기
fig = plt.figure(figsize=(20,10))
ax01 = plt.subplot2grid((2,4), (0,0), colspan=4)
sns.regplot(x='min_class', y='nanmean', data=test_data, fit_reg=False, scatter_kws={'facecolors':test_data['color']})
#sns.scatterplot(x='min_class', y='nanmean', data=test_data2)
plt.axhline(cut_mean_02,  color='r', linestyle='--', alpha=0.5)
ax02 = plt.subplot2grid((2,4), (1,0), colspan=4)
sns.regplot(x='min_class', y='nanstd', data=test_data, fit_reg=False, scatter_kws={'facecolors':test_data['color']})
plt.axhline(cut_std_02,  color='r', linestyle='--', alpha=0.5)


## 이상 데이터의 횟수 카운트
det_capa = lambda x, y: 1 if ((x > cut_mean_02) & (y < cut_std_02)) else 0
case_II_result['isOdd'] = list(map(det_capa, case_II_result['nanmean'], case_II_result['nanstd']))
case_II_result_counts = case_II_result.groupby(['dev_id'])['isOdd'].sum()

## 50회 초과 device 목록
case_II_result_counts[case_II_result_counts > cut_count]

## 해당 디바이스 비율계산
len(case_II_result_counts[case_II_result_counts > cut_count]) / len(names)