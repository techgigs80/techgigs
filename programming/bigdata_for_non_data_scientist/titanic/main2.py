from with_domain import *


def data_preparation_with_domain():
    titanic = load_titanic_dataset()
    
    '''
    지시사항에 맞게 아래에 코드를 입력해주세요
    
    '''
    # 1) Data Preprocessing을 실행시키세요 (아래 한 줄 코드 작성)
    titanic = data_pre
    processing(titanic)
    
    # 2) Feature Engineering을 실행시키세요 (아래 4개의 변수에 True or False 입력)
    switch = {
        'name' : True, # True or False
        'age' : False, # True or False
        'age_categorization' : False, #True or False
        'familysize':  False# True or False
    }
    
    feature_engineering(titanic, switch)
    
    
    
    # 결과를 확인합니다.
    show_result(titanic)
    
    return switch
	

if __name__ == "__main__":
    data_preparation_with_domain()
