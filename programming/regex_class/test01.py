import re

# 조건
# p1에 ex로 시작하는 단어들만 출력하도록 패턴을 입력하세요.

# p2에 ful로 끝나는 단어들만 출력하도록 패턴을 입력하세요.

# 올바르게 단어가 출력되는지 확인하고 제출해주세요.

'''
아래에 정규표현식을 직접 입력해보세요!
'''

p1 = "^ex.*"         # ex로 시작해야 매치
p2 = ".*ful$"         # ful로 끝나야 매치


words = ["flexible", "carefully", "chocolate", "expand", "exclude", "wonderful", "helpful"]

result1 = []
result2 = []

for word in words :
    # 단어들을 검사하여 리스트에 넣는 코드입니다. 수정하지 않아도 됩니다.
    m1 = re.findall(p1, word)
    m2 = re.findall(p2, word)
    
    result1 += m1
    result2 += m2
    
print("ex로 시작하는 단어 : ", result1)
print("ful로 끝나는 단어 : ", result2)

