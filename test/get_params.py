import argparse
import pandas as pd
import os
import re
from collections import Counter
from tqdm import tqdm
import pickle
import numpy as np
import logging


parser = argparse.ArgumentParser(description='get inputs of parameter module')
parser.add_argument('--input_dir', default=None, help='input_dir of log structure file')
parser.add_argument('--str_file_name', type=str, default=None, help='log structure filename')
parser.add_argument('--out_params_name', type=str, default=None , help='saved params_name')
parser.add_argument('--rev_logkey_name', type=str, default=None , help='reversed logkey_name')
parser.add_argument('--is_training', action='store_true', help='is_training' )

logger = logging.getLogger()
logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.INFO)
args = parser.parse_args()


def checkParams(str_df):
    for E_id, temp, params in tqdm(str_df[['EventId','EventTemplate','ParameterList']].values):
        if rev_dict.get(E_id, None) is not None:
            assert len(re.findall('\<\*\>',temp)) == len(params)        
def extractParams(params):
    return [e.strip() for e in re.sub("[\['\]]", '', params).split(',')]

if __name__=="__main__":
    logging.info('Read input file...')   
    str_df = pd.read_pickle(os.path.join(args.input_dir, args.str_file_name))

    if args.is_training:
        eids = sorted(set(str_df['EventId']))
        rev_dict = { eid: i for i, eid in enumerate(eids)}

        #save logkey as index
        logging.info('Save logkey as index...')   
        with open(os.path.join(args.input_dir, args.rev_logkey_name), 'wb') as f:
            pickle.dump(rev_dict,f, protocol=pickle.HIGHEST_PROTOCOL)
    else:
        with open(os.path.join(args.input_dir, args.rev_logkey_name), 'rb') as f:
            rev_dict = pickle.load(f)
        
    # check param structure
    logging.info('Check param structure...')   
    checkParams(str_df)
    
    logging.info('Make param structure...')   
    param_dict = {eid: [] for eid in rev_dict}
    for LineId, u, diff, eid, row in tqdm(str_df[['LineId', 'unixTime' ,'diff','EventId','ParameterList']].values):
        if rev_dict.get(eid, None) is not None:
            param_dict[eid].append([LineId, u, diff]+row)
        
    logging.info('Save param structure...')   
    with open(os.path.join(args.input_dir, args.out_params_name), 'wb') as f:
        pickle.dump(param_dict,f, protocol=pickle.HIGHEST_PROTOCOL)
    logging.info('Done.') 
