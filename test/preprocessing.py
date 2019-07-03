#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import numpy as np
import pandas as pd
import argparse

data_types = {'dev_id': np.string_,
'dev_dt': np.string_,
'pm25': np.string_,
'pm10': np.string_,
'voc_ref': np.string_,
'voc_now': np.string_,
'humi': np.string_,
'temp': np.string_,
'lux': np.string_,
'co2': np.string_,
'pm10_idx': np.string_,
'pm25_idx': np.string_,
'vocs_idx': np.string_,
'co2_idx': np.string_,
'iaq_idx': np.string_,
'unpl_idx': np.string_,
'polt_idx': np.string_,
'dt': np.string_,
'invnr': np.string_,
'inbdt': np.string_,
'use_cust_id': np.string_,
'pyn': np.string_,
'room_cnt': np.string_,
'do_nm': np.string_,
'ct_nm': np.string_,
'gu_nm': np.string_,
'dng_nm': np.string_,
'apts_in_date': np.string_,
'bldg_tp': np.string_,
'rtn_conf_dt': np.string_,
'age': np.string_,
'sex': np.string_,
'cust_tpnm': np.string_}

## pure function for get vent scale value
def getVentScale(pm10_v, co2_v, vocs_v, oaq_v):
    basis = {'pm10': [0, 12, 24, 60],
             'co2':  [0, 10, 40, 80],
             'vocs': [0,  0,  6,  6],
             'oaq':  [0, 21, 42, 84]}
    grade = lambda x: 4 if (x >= 75) else 3 if (x >= 50) else 2 if (x >= 25) else 1
    return basis['pm10'][grade(pm10_v)-1] + basis['co2'][grade(co2_v)-1] + basis['vocs'][grade(vocs_v)-1] - basis['oaq'][int(oaq_v)-1]

def main():
    parser = argparse.ArgumentParser(description='pre-processing function')
    parser.add_argument('sense_file', type=str, metavar='sense_file', help='sense file name with path')
    parser.add_argument('status_file', type=str, metavar='status_file', help='status file name with path')
    parser.add_argument('-o', type=str, metavar='output_file', dest='output_file', help='output filename with path', required=True)
    args = parser.parse_args()

    sense_file = args.sense_file
    status_file = args.status_file
    output_file = args.output_file

    data   = pd.read_csv(sense_file, dtype = data_types)
    print('%d of data are loaded' % len(data))
    data = data[data['dev_dt'] != 'dev_dt']

    ## data type for sensing data
    data['dev_dt'] = pd.to_datetime(data['dev_dt'], format='%Y-%m-%d %H:%M:%S.%f')
    data['pm25'] = data['pm25'].astype(np.number)
    data['pm10'] = data['pm10'].astype(np.number)
    data['voc_ref'] = data['voc_ref'].astype(np.number)
    data['voc_now'] = data['voc_now'].astype(np.number)
    data['humi'] = data['humi'].astype(np.number)
    data['temp'] = data['temp'].astype(np.number)
    data['lux'] = data['lux'].astype(np.number)
    data['co2'] = data['co2'].astype(np.number)
    data['pm10_idx'] = data['pm10_idx'].astype(np.number)
    data['pm25_idx'] = data['pm25_idx'].astype(np.number)
    data['vocs_idx'] = data['vocs_idx'].astype(np.number)
    data['co2_idx'] = data['co2_idx'].astype(np.number)
    data['iaq_idx'] = data['iaq_idx'].astype(np.number)
    data['unpl_idx'] = data['unpl_idx'].astype(np.number)
    data['polt_idx'] = data['polt_idx'].astype(np.number)
    data['room_cnt'] = data['room_cnt'].astype(np.number)
    
    status = pd.read_csv(status_file, parse_dates=['dev_dt'])

    ## data merging
    result = pd.merge(data, status, on = ['dev_id', 'dev_dt'], how = 'outer', sort=True)
    result.fillna(method='ffill', inplace=True)
    result.dropna(inplace=True)
    result.reset_index(inplace=True)
    del result['index']

    ## ventScale calculation
    result['ventScale'] = [getVentScale(result.loc[x, 'pm10_idx'], result.loc[x, 'co2_idx'], result.loc[x, 'vocs_idx'], result.loc[x, 'oaq_idx']) for x in range(len(result))]

    result.to_csv(output_file, index=False)

if __name__=="__main__":
	main()