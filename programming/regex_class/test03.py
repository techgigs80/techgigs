# 조건
# 작성한 정규식이 매치되어야 하는 s의 조건입니다.

# aa.aa.aa.aa.aa

# a는 공백 문자를 제외한 모든 문자(개행 문자, 탭 문자 등을 제외한 문자들)를 나타낸다.
# .은 온점을 나타낸다.
# 즉, 12.34.56.ab.cd 같은 문자열과 매칭하고, 12.34.56.78.90.ab.cd.ef 같은 문자열이나 12.34.ab 같은 문자열과는 매칭하면 안 됩니다.

import re

s = input()

p1 = "^([\S]{2}.){4}([\S]{2})$"    # 여기에 정규표현식을 입력하세요.

m1 = re.search(p1, s, re.S) is not None

print(m1)