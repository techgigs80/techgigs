#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
@Project{Coway analysis:2018.11 ~ 2019.01
  source name     = case_IV_rules.py
  author          = Kyung Ho, Ku
  description     = "case_III : pm10 diff problem"
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
case_IV_raw = pd.read_csv(filepath + 'processed_whole_data.csv', parse_dates=['dev_dt'])

## 전체 데이터 비율확인용 변수
names = case_IV_raw['dev_id'].unique()
names.sort

# case IV PM10의 차분값(diff)이 특정치(예상: 500이상)가 많이 나타나는 경우 : 두가지 케이스 나누어짐
# 차분값의 절대값이 500보다 큰 경우가 x% 이상인 날이 7일 이상인 디바이스를 추출

## 차분데이터 생성 및 이상상태 마킹
LCL, UCL = -500, 500
det_diff = lambda x: (x.notnull()) & np.invert(x.between(LCL, UCL, inclusive=True))

for d in tqdm(case_IV_raw):
    d['pm10_diff'] = d['pm10'].diff()
    d['isOdd'] = det_diff(d['pm10_diff'])
case_IV_diff = pd.concat(case_IV_raw, axis=0, ignore_index=True, sort=False)

## 차분의 절대값을 구함
case_IV_diff['pm10_diff_a'] = list(map(lambda x: np.abs(x), case_IV_diff['pm10_diff']))

## 케이스 산출용 결과 산출
result_03 = case_IV_diff.groupby(['dev_id', 'day'])['isOdd'].sum()
result_04 = case_IV_diff.groupby(['dev_id', 'day'])['isOdd'].describe()['count']
result_05 = case_IV_diff.groupby(['dev_id', 'day', 'isOdd'])['pm10_diff_a'].apply(lambda x: np.nanstd(x))

result_03 = result_03.reset_index()
result_04 = result_04.reset_index()
result_05 = result_05.reset_index()

result_06 = pd.concat([result_03, result_04['count']], axis=1)
result_07 = pd.merge(result_06, result_05.loc[result_05['isOdd'], ['dev_id', 'day', 'pm10_diff_a']], how='left', on=['dev_id', 'day'])
case_IV_result = pd.merge(result_07, result_05.loc[np.invert(result_05['isOdd']), ['dev_id', 'day', 'pm10_diff_a']], how='left', on=['dev_id', 'day'])
case_IV_result.columns = ['dev_id', 'day', 'no_of_odd', 'no_of_whole_count', 'std_of_odd', 'std_of_normal']


# 첫번째 : 특정값이 유지되는 것이 반복될 경우 : target device '17302D8F1661600051'

## 특정 device 검증
## eye-check기준의 cut-off설정
test_data1 = case_IV_result.loc[case_IV_result['dev_id'] == '17302D8F1661600051']

day = [1, 3, 9, 25]
test_data1['color'] = np.where(np.isin(test_data1['day'], day) , "#3498db", "#FFFFFF")

## 그래프를 통해 ratio 확인
fig = plt.figure(figsize=(20,10))
ax01 = plt.subplot2grid((2,4), (0,0), colspan=4)
sns.regplot(x='day', y='no_of_odd', data=test_data1, fit_reg=False, scatter_kws={'facecolors':test_data1['color']})
plt.axhline(6, color='r', linestyle='--', alpha=.5)
plt.axhline(10, color='r', linestyle='--', alpha=.5)
ax01.set_xticks(list(range(1,32)))
ax02 = plt.subplot2grid((2,4), (1,0), colspan=4)
sns.regplot(x='day', y='std_of_normal', data=test_data1, fit_reg=False, scatter_kws={'facecolors':test_data1['color']})
plt.axhline(30, color='r', linestyle='--', alpha=.5)
ax02.set_xticks(list(range(1,32)))


# 두번째 : 짧은 시간에 낮은 값과 높은 값을 반복할 경우 : target device '17402D8F1692100163'

## 특정 device 검증
## eye-check기준의 cut-off설정
test_data2 = case_IV_result.loc[case_IV_result['dev_id'] == '17402D8F1692100163']
day = [10, 11, 14, 15, 18, 19, 20, 24, 25, 26, 27, 30, 31]
test_data2['color'] = np.where(np.isin(test_data2['day'], day) , "#3498db", "#FFFFFF")

## 그래프를 통해 ratio 확인
fig = plt.figure(figsize=(20,10))
ax01 = plt.subplot2grid((2,4), (0,0), colspan=4)
sns.regplot(x='day', y='no_of_odd', data=test_data2, fit_reg=False, scatter_kws={'facecolors':test_data2['color']})
plt.axhline(150, color='r', linestyle='--', alpha=.5)
ax01.set_xticks(list(range(1,32)))
ax02 = plt.subplot2grid((2,4), (1,0), colspan=4)
temp = test_data2.dropna()
sns.regplot(x='day', y='std_of_odd', data=temp, fit_reg=False, scatter_kws={'facecolors':temp['color']})
plt.axhline(150, color='r', linestyle='--', alpha=.5)
ax02.set_xticks(list(range(1,32)))


## 차분그래프 산출
target_day = 11     ## 보고싶은 날짜 삽입

# 계단 : test_data1
# 범핑 : test_data2
target_data = test_data1.copy()
# target_data = test_data2.copy()

fig = plt.figure(figsize=(20,10))
kws={"s": 30}
sns.lineplot(x='dev_dt', y='pm10_diff', data=target_data.loc[target_data['dev_dt'].between(s_list[int(target_day-1)], e_list[int(target_day-1)], inclusive=True)])
plt.xlim(s_list[int(target_day-1)], e_list[int(target_day-1)])
plt.axhline(UCL, color='r', linestyle='--', alpha=.5)
plt.axhline(LCL, color='r', linestyle='--', alpha=.5)

## 히스토그램 산출
fig = plt.figure(figsize=(20,10))
temp = target_data.loc[target_data['pm10_diff'].notnull()]
sns.distplot(temp.loc[temp['day'] == day]['pm10_diff'], bins=100, kde=False)
plt.axvline(UCL, color='r', linestyle='--', alpha=.5)
plt.axvline(LCL, color='r', linestyle='--', alpha=.5)


## 첫번째 계단 케이스 디바이스 검출
# target device '17302D8F1661600051'

# 최하 횟수, 최고 횟수, 정상데이터의 표준편차 cut-off 값 설정
b_times, t_times = 6, 10
cut_std_1 = 30
cut_count_1 = 0
det_stair_case = lambda x, y: (x >= b_times) & (x <= t_times) & (y < cut_std_1)

# 기준에 해당하는 디바이스 검출
case_IV_result['isStair'] = list(map(det_stair_case, case_IV_result['no_of_odd'], case_IV_result['std_of_normal']))
case_IV_stair = case_IV_result.groupby('dev_id')['isStair'].sum()
case_IV_stair = case_IV_stair.sort_values(ascending=False)
case_IV_stair = case_IV_stair.reset_index()

## 검출 디바이스 갯수와 비율 확인
len(case_IV_stair.loc[case_IV_stair['isStair'] > cut_count_1]) / len(names)


## 두번째 범핑 케이스 디바이스 검출
# target device '17402D8F1692100163'

# 최하 횟수, 비정상데이터의 표준편차 cut-off 값 설정
min_count = 150
cut_std_2 = 150
cut_count_2 = 0
det_bump_case = lambda x, y: (x >= min_count) & (y <= cut_std_2)

case_IV_result['isBump'] = list(map(det_bump_case, case_IV_result['no_of_odd'], case_IV_result['std_of_odd']))
case_IV_bump = case_IV_result.groupby('dev_id')['isBump'].sum()
case_IV_bump = case_IV_bump.sort_values(ascending=False)
case_IV_bump = case_IV_bump.reset_index()

## 검출 디바이스 갯수와 비율 확인
len(case_IV_bump.loc[case_IV_bump['isBump'] > cut_count_2]) / len(names)