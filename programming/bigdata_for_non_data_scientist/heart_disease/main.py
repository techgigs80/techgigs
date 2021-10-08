from heart_disease import *
from itertools import combinations

def result_of_heart_disease_prediction():
    # 심장질환과 연관성이 높은 핵심 요인을 자유롭게 입력하여 정확도를 높여주세요
    # Example: features = ['age', 'sex', 'serum_cholesterol', 'fasting_blood_sugar', 'electro']
    features = ['sex', 'chest_pain', 'max_heart_rate', 'vessels', 'thal']
    
    check_features(features)
    
    return features


if __name__ == "__main__":
    result_of_heart_disease_prediction()
#     decoder = {k:v for k, v in enumerate(['age','sex','chest_pain','blood_pressure','serum_cholesterol','fasting_blood_sugar', 'electro','max_heart_rate','angina','st_depression','slope','vessels','thal'])}

#     heart = load_dataset()
    

#     result = {}
#     for n in combinations(range(len(decoder)), 5):
#         result[n] = scoring_columns(heart, [decoder[i] for i in n])
#     ret = sorted(result.items(), key=lambda x:x[1], reverse=True)
#     print(ret[0])p