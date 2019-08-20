import argparse
import os
import re
import pandas as pd
import pickle
from tqdm import tqdm
import numpy as np
import logging



parser = argparse.ArgumentParser(description='get inputs of logkey module')

parser.add_argument('--input_dir', type=str, default=None, help='input_dir of log structure file')
parser.add_argument('--str_file_name', type=str, default=None, help='log structure filename')
parser.add_argument('--out_blk_seq_name', type=str, default=None, help='saved blk_seq_name')
parser.add_argument('--rev_logkey_name', type=str, default=None , help='reversed logkey_name')
parser.add_argument('--is_training', action='store_true', help='is_training' )

logger = logging.getLogger()
logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.INFO)
args = parser.parse_args()



def extractParams(params):
    return [e.strip() for e in re.sub("[\['\]]", '', params).split(',')]

def get_blk(x):
        return np.array(x)[[bool(re.match('blk_(|-)[0-9]+',str(e))) for e in x]][0]
    
    
if __name__=="__main__":
    
    logging.info('Read input file...')   
    str_df = pd.read_pickle(os.path.join(args.input_dir, args.str_file_name))
    
    with open(os.path.join(args.input_dir, args.rev_logkey_name), 'rb') as f:
        rev_dict = pickle.load(f)

    logging.info('Define blockID...')   
    blks = list(map(get_blk,str_df['ParameterList'].values))
    
    dfs = pd.DataFrame({'blks':blks, 'logKey': str_df['EventId']} )
    rev_dfs = dfs.replace({'logKey': rev_dict})
    # exception 
    if not args.is_training:
        rev_dfs.loc[rev_dfs['logKey'].apply(lambda x: not isinstance(x, int)),'logKey'] = -1
    
    dataset = rev_dfs.groupby('blks')['logKey'].apply(list)
    
    logging.info('Make logKey sequence...')   
    output = {}
    for blk, arr in tqdm(zip(dataset.index, dataset.values)):
        output[blk] = arr
        
    with open(os.path.join(args.input_dir, args.out_blk_seq_name), 'wb') as f:
        pickle.dump(output,f, protocol=pickle.HIGHEST_PROTOCOL)
    logging.info('Done.') 