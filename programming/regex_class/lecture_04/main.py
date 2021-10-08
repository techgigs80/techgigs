import re

'''
아래에 정규표현식을 직접 입력해보세요!
'''

text1 = "catatatatatat"

p1 = "cat"
p2 = "c(at)+"             # 정규식 패턴 입력!
m1 = re.search(p1, text1)
m2 = re.search(p2, text1)
print("m1 결과 : ", m1.group())
print("m2 결과 : ", m2.group())

text2 = "tomato"

p3 = "(to)ma\\1"             # 정규식 패턴 입력!
m3 = re.search(p3, text2)
print("m3 결과 : ", m3.group())

text3 = '''
Elice 123456-1234567 010-1234-5678
Cheshire 345678-678901 01098765432
'''

p4 = "(010)[\D]?[\d]{4}[\D]?([\d]{4})"          # 정규식 패턴 입력!

print("m4 결과 : ", re.sub(p4, "\g<1>-****-\g<2>", text3))

text4 = "tomato potato"

p5 = "(tom|pot)ato"    # tomato 또는 potato와 매칭하자
p6 = "(?:tom|pot)ato"                # 올바른 패턴을 작성해보세요.
m5 = re.findall(p5, text4)
m6 = re.findall(p6, text4)
print("m5 결과 : ", m5)
print("m6 결과 : ", m6)

text5 = "마우스의 가격은 7,000원이고, 모니터의 가격은 72,000원이고, 키보드의 가격은 216,000원이고, 그래픽카드는 1,500,000원입니다."

p7 = "([\d]{0,3},)?([\d]{3},)*[\d]{1,3}"          # 금액을 참조하려는 잘못된 정규식 패턴
p8 = "(?:[\d]{0,3},)?(?:[\d]{3},)*[\d]{1,3}"                                     # 올바른 패턴을 작성해보세요.
m7 = re.findall(p1, text5)
m8 = re.findall(p2, text5)
print("m7 결과 : ", m7)
print("m8 결과 : ", m8)

# 유효한 전화번호로 판정되기 위한 조건은 다음과 같습니다.
# 전화번호는 무조건 010으로 시작한다.
# 전화번호의 가운데 자리는 네 자리이다.
# 전화번호의 각 자리에 구분문자(-, . 등)가 있을 수도 있고, 없을 수도 있다.

s = input()

p9 = "^010[.-]?[\d]{4}[.-]?[\d]{4}"    # 여기에 정규표현식을 입력하세요.
m9 = re.search(p9, s) is not None

print(m9)