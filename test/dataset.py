import pandas as pd
import pickle, os
from tqdm import tqdm
from collections import Counter
import numpy as np

class DataLoader:
    def __init__(self, data_path, data_type, file_name):
        # DataLoader 클래스는 data_path, data_type과 file_name 총 3개의 인자를 필요로 함
        self.data_path = data_path
        self.data_type = data_type
        self.file_name  = file_name
        
        # 인자로 받은 data_type 에 따라 각각 다른 종류의 data_loader 를 사용하게 됨
        # 다른 종류의 data_loader 를 사용하지만 return 받는 데이터의 형식은 총 5개로 모두 같음
        # timeblocks : 5분 단위의 timestamp
        # timestamps : 각 로그의 실제 timestamp
        # line_ids : 로그의 line_id, 0부터 차례대로 1씩 증가시키면서 부여
        # loglines : line_id 에 각각 대응되는 로그 list
        # tb_flatten : test 시 timeblock 별로 score 계산을 하기 위해 해당 로그가 속한 timeblock 을 timestamps 개수만큼 증가시켜 저장
        
        if self.data_type == "esxi":
            self.timeblocks, self.timestamps, self.line_idx, self.loglines, self.tb_flatten = self.esxi_loader(self.file_name)
        elif "secure" in self.data_type:
            self.timeblocks, self.timestamps, self.line_idx, self.loglines, self.tb_flatten = self.secure_loader()
        elif self.data_type == "postgres":
            self.timeblocks, self.timestamps, self.line_idx, self.loglines, self.tb_flatten = self.sql_loader(self.file_name)
        elif self.data_type == "db2":
            self.timeblocks, self.timestamps, self.line_idx, self.loglines, self.tb_flatten = self.db2_loader(self.file_name)
        else:
            raise ValueError("Please Check data_type : (esxi/secure/postgresSQL/DB2)")
        
        print("%s data load completed!"%data_type)
        
        # data_loader 를 사용해 불러온 logline 들을 Counter 모듈에 넣어서 전체 unique 한 로그 패턴 개수 확인 및 빈도 파악 가능
        # unique 한 로그 패턴 마다 각각 id 를 부여함, 이 때 1부터 부여하며, 만약 test 시 train_data 에 없는 로그 패턴이 등장할 경우 0번 id 부여
        
        log_ptrn_counter = Counter()
        for logline in self.loglines:
            log_ptrn_counter.update(logline)
            
        self.log2idx = {log_ptrn:idx+1 for idx, log_ptrn in enumerate(list(log_ptrn_counter.keys()))}
        self.idx2log = {idx+1:log_ptrn for idx, log_ptrn in enumerate(list(log_ptrn_counter.keys()))}
        
        # 위에서 부여된 id 에 대응 되도록 loglines 를 log2idx_converter 함수를 사용해서 변환
        self.log_flatten = self.log2idx_converter(self.loglines, self.log2idx)
        
        print("%s data preprocessing completed!"%data_type)
            
    def log2idx_converter(self, loglines, log2idx):
        # loglines 를 log2idx_converter 함수를 사용해서 변환하는 함수, 만약 log2idx 안에 해당되는 로그 패턴이 없다면 0번 id 부여
        res = []
        for logline in tqdm(loglines):
            tmp = list(map(lambda x: log2idx.get(x), logline))
            for idx in tmp:
                if idx == None:
                    res.append(0)
                else:
                    res.append(idx)
        return res
    
    def get_input_data(self):
        # train, test 시 사용할 tb_flatten, log_flatten list 를 반환하는 함수
        return self.tb_flatten, self.log_flatten

    def secure_loader(self):
        # secure 데이터를 load 하는 함수
        # secure-[server_name] 의 형태로 data_type 이 들어오면 secure 데이터 중 해당 server_name 을 가지는 데이터를 읽어 옴
        
        server_name = self.data_type.split("-")[1]
        filename = [filename for filename in os.listdir(self.data_path) if "%s_OS_secure.pkl"%server_name in filename][0]
        data = {}
        with open(os.path.join(self.data_path, filename), "rb") as f:
            tmp = pickle.load(f)
            data.update(tmp)        

        timeblocks = list(data.keys())
        timestamps = []
        line_idx = []
        loglines = []

        tb_flatten = []
        
        for i, tb in enumerate(timeblocks):
            ts_list = data.get(tb)["Timestamp"]
            timestamps.append(ts_list)
            line_idx.append(np.arange(len(data.get(tb)["Timestamp"])).tolist())
            loglines.append(data.get(tb)["LogLines"])
            tb_flatten += [tb]*len(ts_list)
        
        return timeblocks, timestamps, line_idx, loglines, tb_flatten
    
    def esxi_loader(self, filename):
        # esxi 데이터를 load 하는 함수
        with open(os.path.join(self.data_path, filename), "rb") as f:
            data = pickle.load(f)
        timeblocks = list(data.keys())
        timestamps = []
        line_idx = []
        loglines = []

        tb_flatten = []
        
        for i, tb in enumerate(timeblocks):
            ts_list = data.get(tb)["Timestamp"]
            timestamps.append(ts_list)
            line_idx.append(np.arange(len(data.get(tb)["Timestamp"])).tolist())
            loglines.append(data.get(tb)["LogLines"])
            tb_flatten += [tb]*len(ts_list)
        
        return timeblocks, timestamps, line_idx, loglines, tb_flatten

    def sql_loader(self, filename):
        # posgresSQL 데이터를 load 하는 함수
        with open(os.path.join(self.data_path, filename), "rb") as f:
            data = pickle.load(f)
        timeblocks = list(data.keys())
        timestamps = []
        line_idx = []
        loglines = []

        tb_flatten = []
        
        for i, tb in enumerate(timeblocks):
            ts_list = data.get(tb)["Timestamp"]
            timestamps.append(ts_list)
            line_idx.append(np.arange(len(data.get(tb)["Timestamp"])).tolist())
            loglines.append(data.get(tb)["LogLines"])
            tb_flatten += [tb]*len(ts_list)
        
        return timeblocks, timestamps, line_idx, loglines, tb_flatten

    def db2_loader(self, filename):
        # db2 데이터를 load 하는 함수
        with open(os.path.join(self.data_path, filename), "rb") as f:
            data = pickle.load(f)
        timeblocks = list(data.keys())
        timestamps = []
        line_idx = []
        loglines = []

        tb_flatten = []
        
        for i, tb in enumerate(timeblocks):
            ts_list = data.get(tb)["Timestamp"]
            timestamps.append(ts_list)
            line_idx.append(np.arange(len(data.get(tb)["Timestamp"])).tolist())
            loglines.append(data.get(tb)["LogLines"])
            tb_flatten += [tb]*len(ts_list)
        
        return timeblocks, timestamps, line_idx, loglines, tb_flatten

