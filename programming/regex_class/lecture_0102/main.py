'''
re 모듈을 불러오고, 실행 결과를 확인해보세요!
'''
import re

text = "hello, elice!"
p1 = "elice"                     # p1은 pattern 1의 의미입니다! 정규표현식을 입력해보세요. (ex. "e", "elice")
m1 = re.findall(p1, text)   # text 문자열 변수에서 정규식 p1로 매칭한 결과를 나타냅니다.
print(m1)


text2 = "abcdefg"
pattern = re.compile("e")
print("정규식 객체의 자료형 : ", type(pattern))
print("정규식 객체 사용하는 경우 : ", pattern.findall(text2))
print("객체를 사용하지 않는 경우 : ", re.findall("e", text2))

text3 = '''&7q:>@6j`~itIghnfHH8=FW7y?<g"lt?=q3*kJdN/bsrF()Z<U$_w2-`KUnyxLB<8uMm%*`"[:%yha[f`bEXHW=qD9K>95K92cvI>Kj51/cy~cwaN[jB'u5<Ix8?;y~g15T_bb2z<uL&xOIaMJFk>s^}nz.sWx<2)R?:x5r9,T_45]zQ>Z|FN%AFf/#@^FR#&wogd@hlk(7&MZqqurTF+V5oy`cpM.iMUBMd#wGs9RTj7J`Q=,AIv3x%&/Q)-jDk'''
p2 = "a"  # 9행의 re.compile 함수에 들어갈 문자열 매개변수입니다.
m2 = re.findall(p2, text3)
print("결과 : ", m2)

text4 = '''j<Q'T~K_5f_&VO_):Igq:=8t9qPGVB&-=9;oC7$7bw>I6)=abcQiZ&nNj2J\|0'aE*QyyelicebcW:y`y#Y&nY.gq.-0m\w2m8<1<`P:`OdE{>SF}]4_"8'Ozv:}Pc5@H91j250^H,W$~GD>;K[r_3VW?pS2U*uz`lxne`,ZMeliceFJDhMf$NxcQ[K_o4=Q2z?%[Ak1Do!E!8:>)7abcprcNIelice.mT<Cwy!~T/QfD0L&V&'\$z;7$@By&8L[8?0a4=v4uYY=IK#4{vB46delice$^EI}vD*ndR{F#EJyMHIe2QK,u"c^1d32Cvl%]Hq-;+(O/M8X-ykfelicedll3nfIn>%9i*e!9[u4$W3ASbY!h1elicedg{A|lrKJsSvJ<;A*9f_7K<?elice9MGo1Ngu~5w@EL!QMKaxUS]C6##~OBiduA]wa=pIse%E=PenU<&>w_sd{eaM0elicekr=%C^^@#j[~O!7K(^^LzS(mK"f3?p|C*;`~F|0uMCS1c=Sa-ya7?8j.!9r}YZxv'''
p3 = "elice"  # 9행의 re.compile 함수에 들어갈 문자열 매개변수입니다.
m3 = re.findall(p3, text4)
print("결과 : ", m3)

p4 = "Life"     # Life 포함하면 매치
p5 = "is"       # is 포함하면 매치

m4 = re.findall(p4, "Life is short")
m5 = re.findall(p5, "Life is short")

print("m1 결과 : ", m4)
print("m2 결과 : ", m5)

p6 = "^Life"         # Life로 시작해야 매치
p7 = "^is"         # is로 시작해야 매치

m6 = re.findall(p6, "Life is short")
m7 = re.findall(p7, "Life is short")

print("m6 결과 : ", m6)
print("m7 결과 : ", m7)

p8 = "short$"         # short으로 끝나야 매치
p9 = "short$"         # short으로 끝나야 매치

m8 = re.findall(p8, "Life is short")
m9 = re.findall(p9, "Life is short, art is long")

print("m8 결과 : ", m8)
print("m9 결과 : ", m9)

p10 = "apple"        # apple 포함하면 매치
p11 = "banana"       # banana 포함하면 매치

m10 = re.findall(p10, "I like apple and banana")
m11 = re.findall(p11, "I like apple and banana")

print("m10 결과 : ", m10)
print("m11 결과 : ", m11)


### 아래 p3에 직접 정규표현식을 입력해보세요!

p12 = "apple|banana"             # apple 또는 banana가 포함되면 매치

m12 = re.findall(p12, "I like apple and banana")

print("m12 결과 : ", m12)

p13 = "a|e|i|o|u"     # 알파벳 모음에 매치
p14 = "[aeiou]"       # 알파벳 모음에 매치
p15 = "[^aeiou]"      # 알파벳 모음이 아닌 문자(자음)에 매치

m13 = re.findall(p13, "Life is short, art is long")
m14 = re.findall(p14, "Life is short, art is long")
m15 = re.findall(p15, "Life is short, art is long")

print("m13 결과 : ", m13)
print("m14 결과 : ", m14)
print("m15 결과 : ", m15)

text5 = "vkvJZZjgsr=B5Al83+#@04?+p%x7DI3k"

p16 = "[0-9]"     # 숫자와 매칭됨
p17 = "[a-z]"     # 알파벳 소문자와 매칭됨

m16 = re.findall(p16, text5)
m17 = re.findall(p17, text5)

print("m16 결과 : ", m16)
print("m17 결과 : ", m17)

p18 = "[\d]"         # 숫자만 매치
p19 = "[\D]"         # 숫자가 아니면 매치

m18 = re.findall(p18, "el_ice%20$19")
m19 = re.findall(p19, "el_ice%20$19")

print("m18 결과 : ", m18)
print("m19 결과 : ", m19)

p20 = "[\w]"         # 알파벳 대소문자, 숫자, 밑줄만 매치
p21 = "[\W]"         # 7행의 조건과 반대 조건

m20 = re.findall(p20, "el_ice%20$19")
m21 = re.findall(p21, "el_ice%20$19")

print("m20 결과 : ", m20)
print("m21 결과 : ", m21)

p22 = "[\s]"         # 공백 문자와 매칭
p23 = "[\S]"         # 공백이 아닌 문자와 매칭

m22 = re.findall(p22, "Life is short")
m23 = re.findall(p23, "Life is short")

print("m22 결과 : ", m22)
print("m23 결과 : ", m23)

text6 = "cat bat c@t hat cut com cook cant"

p24 = "c.t"        # c로 시작하고 t으로 끝나는, 모든 3글자 단어에 매칭
m24 = re.findall(p24, text6)
print("m24 결과 : ", m24)

text7 = '''APPLE APPLe APPlE APpLE ApPLE aPPLE APPle APpLe ApPLe aPPLe APplE ApPlE aPPlE AppLE aPpLE apPLE'''
          
p25 = "APPLE"
p26 = "(?i)apple"       # 대소문자를 무시하며 APPLE에 매칭되는 패턴을 작성해보세요.

m25 = re.findall(p25, text7)
m26 = re.findall(p26, text7)
print("m25 결과 : ", m25)
print("m26 결과 : ", m26)

# s = input()
s = '1111n11d11'

p27 = "^[\d]{4}[\D]{1}[\d]{2}[\D]{1}[\d]{2}"    # 여기에 정규표현식을 입력하세요.

m27 = re.search(p27, s) is not None

print(m27)
