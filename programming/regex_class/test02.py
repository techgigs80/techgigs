# 조건
# 작성한 정규식이 매치되어야 하는 s의 조건입니다.
# s는 다음과 같은 형식을 따릅니다.
# wnnnn.

# w는 알파벳, 숫자, 언더스코어를 나타낸다.
# n은 숫자를 나타낸다.
# .은 온점을 나타낸다.
# s는 w로 시작해서 .으로 끝나야만 합니다.


import re

s = input()

p1 = "^[\w][\d]{4}[.]$"    # 여기에 정규표현식을 입력하세요.

m1 = re.search(p1, s) is not None

print(m1)
