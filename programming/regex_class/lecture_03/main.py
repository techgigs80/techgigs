import re

'''
아래에 정규표현식을 직접 입력해보세요!
'''

text1 = "ct cat caat caaat caaaaat caaaaaat cbt c1t c@t c_t"

p1 = "c[a]*t"         # c와 t 사이에 'a'가 0개 이상 있는 경우 매칭
m1 = re.findall(p1, text1)
print("m1 결과 : ", m1)

text2 = "apple banana carrot rabbit"

p2 = "[a-z]"        # 영어 소문자 매칭
p3 = "[a-z]+"             # 영단어 단위로 매칭
m2 = re.findall(p2, text2)
m3 = re.findall(p3, text2)
print("m21 결과 : ", m2)
print("m3 결과 : ", m3)

text3 = "1 12 102 8948 754 77 3 222"

p4 = "\d+"       # 숫자 매칭
p5 = "\d{3}"         # 세 자리 수 매칭
m4 = re.findall(p4, text3)
m5 = re.findall(p5, text3)
print("m4 결과 : ", m4)
print("m5 결과 : ", m5)

text4 = "9 906 7581 28240 840414 3802773 425624"

p6 = "[\d]{3,5}"         # 자릿수가 3 이상 5 이하인 수
m6 = re.findall(p6, text4)
print("m6 결과 : ", m6)

text5 = "2 96 4019 884863 56635574 946482 95325201 410505 5802 6661337 2937786 31103"
p7 = "[\d]{7,}"         # 자릿수가 7 이상인 수
m7 = re.findall(p7, text5)

print("m7 결과 : ", m7)

text6 = "ac abc abbc abbbc abbbbbc"

p8 = "ab?c"         # ac, abc와 매칭
m8 = re.findall(p8, text)
print("m8 결과 : ", m8)

text7 = "<html><head><Title>제목</head></html>"

p9 = "<.*>"
p10 = "<.*?>"         #정규표현식을 이용해보세요.

m9 = re.findall(p9, text)
m10 = re.findall(p10, text)

print("m9 결과 : ", m9)
print("m10 결과 : ", m10)