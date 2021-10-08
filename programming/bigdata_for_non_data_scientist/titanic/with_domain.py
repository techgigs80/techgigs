import pandas as pd
import numpy as np
from sklearn.metrics import confusion_matrix
from matplotlib import pyplot as plt
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.preprocessing import FunctionTransformer, StandardScaler, OneHotEncoder
from sklearn.model_selection import cross_val_score, cross_val_predict
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
import elice_utils
from time import sleep
import itertools
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
pd.set_option('display.max_rows', 10)
pd.set_option('display.max_columns', 10)

SEED=7020

def load_titanic_dataset():
    print('>>> 타이타닉 데이터셋을 불러옵니다...')
    sleep(0.5)
    return pd.read_csv('./data/titanic.csv')

def feature_engineering(dataset, switch):
    switch_name = switch['name']
    switch_age = switch['age']
    switch_age_categorization = switch['age_categorization']
    switch_familysize = switch['familysize']
	
    data = dataset[0]
    feature_engineering_name(data, use=switch_name)
    sleep(1.5)
    feature_engineering_age(data, use_title=switch_name, use_age=switch_age)
    sleep(1.5)
    feature_engineering_age_categorization(data, use=switch_age_categorization)
    sleep(1.5)
    feature_engineering_familysize(data, use=switch_familysize)
    sleep(1.5)
    set_dtypes(data)

def set_dtypes(df):
    cat_cols = ['Sex', 'Pclass', 'Title', 'AgeC', 'Embarked']
    num_cols = ['Age', 'Fare', 'FamilySize']
    for col in df.columns:
        if col in cat_cols:
            df[col] = df[col].astype(np.object)
        elif col in num_cols:
            df[col] = df[col].astype(np.float)

def feature_engineering_name(dataset_, use):
    dataset_.is_copy = False
    if use:
        dataset_['Title'] = dataset_['Name'].str.extract(' ([A-Za-z]+)\.', expand=False)

        # Title 변수 0, 1, 2로 코딩
        title_mapping = {"Mr": 0, "Miss": 1, "Mrs": 2, 
                         "Master": 3, "Dr": 3, "Rev": 3, "Col": 3, "Major": 3, "Mlle": 3,"Countess": 3,
                         "Ms": 3, "Lady": 3, "Jonkheer": 3, "Don": 3, "Dona" : 3, "Mme": 3,"Capt": 3,"Sir": 3 }
        dataset_['Title'] = dataset_['Title'].map(title_mapping)

        # name 제거
        dataset_.drop('Name', axis=1, inplace=True)
        print('>>> feature_engineering_name "Title" faeture를 생성했습니다.')
    else:
        dataset_.drop('Name', axis=1, inplace=True)

# Age의 결측값에 전체 데이터의 Median이 아닌 Title 그룹별 Median을 적용
# use = False의 경우 전체 median 적용

def feature_engineering_age(dataset_, use_title, use_age):
    dataset_.is_copy = False
    try:
        if use_title and use_age:
            # fill missing age with median age for each title (Mr, Mrs, Miss, Others)
            dataset_['Age'].fillna(dataset_.groupby("Title")["Age"].transform("median"), inplace=True)
            print('>>> feature_engineering_age "Age"에 결측치를 Title 정보를 반영하여 채웠습니다.')
        else:
            dataset_['Age'].fillna(dataset_['Age'].median(), inplace = True)

    except KeyError:
        print('Feature_engineering_age 수행 에러!')
        print('Feature_engineering_name 수행 없이 사용할 수 없는 옵션입니다.')
        
def feature_engineering_age_categorization(dataset_, use):
    dataset_.is_copy = False    
    if use:
        dataset_.loc[ dataset_['Age'] <= 16, 'AgeC'] = 0,
        dataset_.loc[(dataset_['Age'] > 16) & (dataset_['Age'] <= 26), 'AgeC'] = 1,
        dataset_.loc[(dataset_['Age'] > 26) & (dataset_['Age'] <= 36), 'AgeC'] = 2,
        dataset_.loc[(dataset_['Age'] > 36) & (dataset_['Age'] <= 62), 'AgeC'] = 3,
        dataset_.loc[ dataset_['Age'] > 62, 'AgeC'] = 4
        print('>>> feature_engineering_age_categorization "Age"를 연령군 특성으로 그룹핑하였습니다.')

def feature_engineering_familysize(dataset_, use):
    dataset_.is_copy = False    
    if use:
        dataset_["FamilySize"] = dataset_["SibSp"] + dataset_["Parch"] + 1
        family_mapping = {1: 0, 2: 0.4, 3: 0.8, 4: 1.2, 5: 1.6, 6: 2, 7: 2.4, 8: 2.8, 9: 3.2, 10: 3.6, 11: 4}
        dataset_['FamilySize'] = dataset_['FamilySize'].map(family_mapping)
        dataset_.drop('SibSp', axis=1, inplace=True)
        dataset_.drop('Parch', axis=1, inplace=True)
        print('>>> feature_engineering_familysize "FamilySize" feature를 추가 생성하였습니다.')

        
def data_preprocessing(dataset_):
    dataset_.is_copy = False    
    # Sex, Embarked 코딩
    # male과 female을 0과 1로 코딩
    sex_mapping = {"male": 0, "female": 1}
    dataset_['Sex'] = dataset_['Sex'].map(sex_mapping)

    # S = 0, C = 1, Q = 2로 코딩
    embarked_mapping = {"S": 0, "C": 1, "Q": 2}
    dataset_['Embarked'] = dataset_['Embarked'].map(embarked_mapping)

    # Ticket, PassengerId, Cabin 제거
    try:
        dataset_.drop(['Ticket', 'PassengerId', 'Cabin'], axis=1, inplace=True)
    except ValueError:
        pass

    # Train data에서 Embarked가 없는 관측치 제거(2건)
    dataset_.dropna(subset = ['Embarked'], inplace=True)

    # 타겟값 분리
    dataset_data = dataset_.drop('Survived', axis=1)
    dataset_target = pd.DataFrame(data = dataset_['Survived'])

    return dataset_data, dataset_target

def cleansing_categorical(indices_categorical_columns):
    categorical_pipline =  Pipeline(steps=[
                    ('select', FunctionTransformer(lambda data: data[:, indices_categorical_columns])),
                    ('onehot', OneHotEncoder(sparse=False))
                ])
    return categorical_pipline

def cleansing_numeric(indices_numeric_columns):
    numeric_pipline = Pipeline(steps=[
                    ('select', FunctionTransformer(lambda data: data[:, indices_numeric_columns])),
                    ('scale', StandardScaler())
                ])
    return numeric_pipline

def create_estimator(df, model):
    indices_categorical_columns = df.dtypes == np.object
    indices_numeric_columns = df.dtypes != np.object
    if indices_categorical_columns.sum() != 0 and indices_numeric_columns.sum() != 0:
        estimator = Pipeline(steps=[
            ('cleansing', FeatureUnion(transformer_list=[
                ('categorical', cleansing_categorical(indices_categorical_columns)),
                ('numeric', cleansing_numeric(indices_numeric_columns))
            ])),
            ('modeling', model)
        ])
    elif indices_categorical_columns.sum() !=0 and indices_numeric_columns.sum() == 0:
        estimator = Pipeline(steps=[
            ('cleansing', FeatureUnion(transformer_list=[
                ('categorical', cleansing_categorical(indices_categorical_columns))
            ])),
            ('modeling', model)
        ])
    elif indices_categorical_columns.sum() ==0 and indices_numeric_columns.sum() != 0:
        estimator = Pipeline(steps=[
            ('cleansing', FeatureUnion(transformer_list=[
                ('numeric', cleansing_numeric(indices_numeric_columns))
            ])),
            ('modeling', model)
        ])
    else:
        return None
    return estimator

def scoring_predicting(data, target):
    model = DecisionTreeClassifier(random_state=SEED)
    estimator = create_estimator(data, model)
    score = cross_val_score(estimator=estimator, X=data.values, y=target, cv=5).mean()
    predict = cross_val_predict(estimator=estimator, X=data.values, y=target, cv=5)
    return score, predict

def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.tight_layout()

def show_result(dataset):
    score, predict = scoring_predicting(dataset[0], dataset[1].squeeze())
    print('==============================================')
    print('>> 최종 결과 Accuracy : {:.2f}%'.format(score*100))
    return score	