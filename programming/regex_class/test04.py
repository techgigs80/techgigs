# 조건
# 작성한 정규식이 매치되어야 하는 s의 조건입니다.

# s는 오직 영어 소문자와 대문자로만 구성되어 있어야 한다.
# s는 's'로 끝나야 한다.

test = ['aaFFEsfksjdhfwaekjvs', 'askjdfhAAAAEEEdddd_s', 's', 'rrrrrrrrAakjsdfhA!!sadkfjfhaskedjfs']

import re

# s = input()

p1 = "^[a-zA-Z]*[s]$"    # 여기에 정규표현식을 입력하세요.
m1 = [re.search(p1, s, re.S) for s in test] # is not None

print(m1)