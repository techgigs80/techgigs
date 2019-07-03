<!-- MarkdownTOC -->

- Intro
    - install
    - Sbt install
- Basic Use
- Syntax
    - Exmpression
    - Value
    - Function
    - 별칭 선언
    - 호출 타입 지정
    - 익명 함수
    - 함수형 스타일
    - 파이프 스타일
    - multiple blocks
    - Generic type
    - Data structures
    - 제어문
    - Etc
    - Class
- Data Type
    - Touple
- Scala Class
    - Class basic
    - Constructor
    - Method
    - Atrribute
    - 상속
    - Interface
- library
    - IntroSpection
    - Argv & file
- 중요 개념
    - Closure
    - Lazy evaluation
    - Pattern Matching
    - 함수 콤비네이터\(Functional Combinator\)
    - link

<!-- /MarkdownTOC -->



# Intro
## install
## Sbt install
    curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
    sudo yum install sbt

# Basic Use
### Only Scala Console

    object HelloWorld {
      def main(args: Array[String]): Unit = {
        println("Hello, world!")
      }
    }
    HelloWorld.main(Array())
    val x=3
    println(x)

### Compile and Execution
    scalac -d classes HelloWorld.scala
    scala -cp classes HelloWorld
### read&Excute
```
scala> :load x.scala
```
    cf) spark-shell -i x.scala
# Syntax
## Exmpression
### Range
    1 to 10
### println vs. printf
    for(r <- (1 to 10))println(r)
    for(r <- (1 to 10))println(s"$r")
    for(r <- (1 to 10))printf("%d\n",r)
    (1 to 10).map(_*2).foreach(println)
## Value
    //reasign이 불가능한 상수를 선언할때 사용합니다.식의 결과에 이름을 붙일 수 있다.
    val i=0
    val i:Int=i
    //reasign이 가능한 변수를 선언할때 사용합니다.값과 이름의 관계를 변경할 필요가 있다면, var를 사용해야만 한다.
    var i=3
## Function
    // f(x) = x + 1
    def f(x:Int):Int = x + 1
    // f2(x,y) = x * y
    def f2(x:Int,y:Int):Int = x * y
    // 결과값 추론 가능하면
    def f2(x:Int,y:Int) = x * y
## 별칭 선언
    type R = Double
## 호출 타입 지정
    def f(x: R)=x*2     // call-by-value
    def f(x: => R)=x*2  // call-by-name(lazy parameters)
## 익명 함수
    (x:R) => x*x // anonymous function
    ((x:Int) => println(x*x))(3) // 9

    (1 to 5).map(_*2)
    (1 to 5).reduceLeft( _+_ )
    println((1 to 5).map(_*2)) // Vector(2, 4, 6, 8, 10)
    println((1 to 5).reduceLeft( _+_ )) // 15

    (1 to 5).map( x => x*x )
    println((1 to 5).map( x => x*x )) // Vector(1, 4, 9, 16, 25)

    def f(x: Int)  =x*2
    println((1 to 5).map(f(_)))

    (1 to 5).map(2*) // Good
    (1 to 5).map(*2) // Bad
    println((1 to 5).map(2*)) // Vector(2, 4, 6, 8, 10)

    (1 to 5).map{ x=> x *2;println(x);x }

    (x: Int) => x + 1

    new Function1[Int, Int] {
      def apply(x: Int): Int = x + 1
    }

    (x: Int, y: Int) => "(" + x + ", " + y + ")"

    () => { System.getProperty("user.dir") }

    Int => Int
    (Int, Int) => String
    () => String

    Function1[Int, Int]
    Function2[Int, Int, String]
    Function0[String]

## 함수형 스타일
        def f(ar:Range)={
            var i=0
            while(i<ar.length){
                println(ar(i))
                i+=1
            }
        }
        def f(ar:Range)={
            for(a <- ar) println(a)
        }
        def f(ar:Range)=ar.foreach(println)
        f((1 to 4))


## 파이프 스타일
    (1 to 5) filter {_%2 == 0} map {x=>_*2}
    println((1 to 5) filter {_%2 == 0} map {_*2})

## multiple blocks
    type R = Double
    def compose(g:R=>R, h:R=>R) = (x:R) => g(h(x))
    val f = compose({_*2}, {_-1})
    println(f(3)) // 4.0
### Currying
    type R = Double
    val zscore = (mean:R, sd:R) => (x:R) => (x-mean)/sd
    println((zscore(3.0,2.0))(2)) // -0.5

    type R = Double
    def zscore = (mean:R, sd:R) => (x:R) => (x-mean)/sd
    println((zscore(3.0,2.0))(2)) // -0.5

    type R = Double
    def zscore(mean:R, sd:R)(x:R) = (x-mean)/sd
    println((zscore(3.0,2.0))(2)) // -0.5

## Generic type
    def mapmake[T](g:T=>T)(seq: List[T]) = seq.map(g)
    println(mapmake(List(5,10,15,20))(List(0,1))) // List(5, 10)
    println(mapmake(List(5,10,15,20))(List(2))) // List(15)

## Data structures
### 튜플 리터럴(tuple literal)
    (1,2,3)
### 리터럴 바인딩(destructuring bind)
    var (x,y,z) = (1,2,3)

## 제어문
### if
    if(x) println("aaa") else println("false")
### while
    var x=1
    while (x < 5) { println(x); x += 1}
### for
    for(x <- (1 to 10 )){ println(x)}
    for(x <- (1 to 9 )){ printf("%d X %d = %d\n",3,x,3*x)}

### break
    var xs = (1 to 10)
    import scala.util.control.Breaks._
    breakable {
        for (x <- xs) {
            println(x)
            if (Math.random < 0.1) break
        }
    }

## Etc
    class Person(val name:String, val age:Int){}
    val people = List(new Person("aa",3),new Person("bb",4),new Person("bb",10))
    for(p <-  people)printf("%s %d\n",i.name,i.age)

    val mins = people.filter(p=>p.age<5)
    val mins = people.filter(_.age<5)
    for (i <- mins)printf("%s %d\n",i.name,i.age)

    var a=for (i <- mins)yield i.age
    for(i <-a)println(i)
# Data Type
## Touple
```
    var x=(1,2,3)
    x._1
```
## Class

### Basic

# Scala Class
    http://docs.scala-lang.org/ko/tutorials/tour/classes
## Class basic
```scala
    class Person(val name:String, val age:Int){}
    var p=new Person("Nam",44)
```
```scala
    class C(var i:Int){}
    var ob=new C(3)
    ob.i=4
```
## Constructor
    var ob2=new C()
    class C(var i:Int){
        def this()=this(99)
    }
    var ob2=new C()
## Method
    class C(var i:Int){
        def m1()={
           println(i)
        }
    }
## Atrribute
    class C(var i:Int){
        var z:Int=0
        def m1():Int={
          z+=i
          z
        }
    }
    var ob=new C(3)
    ob.m1()

## 상속
### no Contructor
    class C{ var x:Int = 3 }
    class C1 extends C { var y:Int =4}

### with Constructor
    class C(var i:Int){ }
    class C1(i:Int) extends C(i) {}

## Interface
    class C(){ def f()=println("hi")}
    trait C{ def f() }
    // error → class C2 extends C{ def fx()=println("hello")}
    class C2 extends C{ def fx()=println("hello"); def f()={println("hi")}}




### override
class C{def m1(i:Int)= println(i)}
// error→  class C2 extends C {def m1(i:Int)= println(i+"-----")}
class C2 extends C {override def m1(i:Int)= println(i+"-----")}

### Case Class
    스칼라는 케이스 클래스 개념을 지원한다. 케이스 클래스는 생성자 파라미터를 노출하고 패턴 매칭을 통해 재귀적 디컴포지션 메커니즘을 제공하는 일반 클래스이다.
```scala
    abstract class Term
    case class Var(name: String) extends Term
    case class Fun(arg: String, body: Term) extends Term
    case class App(f: Term, v: Term) extends Term

    Fun("x", Fun("y", App(Var("x"), Var("y"))))

    val x = Var("x")
    println(x.name)

    val x1 = Var("x")
    val x2 = Var("x")
    val y1 = Var("y")
    println(" " + x1 + " == " + x2 + " => " + (x1 == x2))
    println(" " + x1 + " == " + y1 + " => " + (x1 == y1))
    object TermTest extends scala.App {
      def printTerm(term: Term) {
        term match {
          case Var(n) =>
            print(n)
          case Fun(x, b) =>
            print("^" + x + ".")
            printTerm(b)
          case App(f, v) =>
            print("(")
            printTerm(f)
            print(" ")
            printTerm(v)
            print(")")
        }
      }
      def isIdentityFun(term: Term): Boolean = term match {
        case Fun(x, Var(y)) if x == y => true
        case _ => false
      }
      val id = Fun("x", Var("x"))
      val t = Fun("x", Fun("y", App(Var("x"), Var("y"))))
      printTerm(t)
      println
      println(isIdentityFun(id))
      println(isIdentityFun(t))
    }
```
# library
## IntroSpection
```
    AnyObj.getClass.getMethods.foreach(println)
    AnyObj.counts.getClass.getName
```
## Argv & file
        import scala.io.Source
        if(args.length>0){
            for line ← Source.fromFile(args(0)).getLines())
                println(line.length + " " + line)
        }else{
            Console.err.println("enter with file name.")
        }

# 중요 개념
## Closure
        http://coding-korea.blogspot.kr/2013/04/closure-with-mutable-variable-in-scala.html
### Closure Basic
    val x = 1// variable x 를 closureFunction 에서 직접 씀.
    val closureFunction = (num: Int) => num + x
    closureFunction(1)
    closureFunction(2)
    closureFunction(4)
→ x는 immutable함.

### Bad closure
    var list: List[Int] = List()
    val closureTest = (num: Int) => {
        list=list:+num
        list
    }
    closureTest(1)
    closureTest(2)
    closureTest(3)
    closureTest(4)
    closureTest(5)
    list = List()
    closureTest(1)
→ FP스타일 아님.
### Good closure
    val closureTest2 = {
        var list: List[Int] = List() // scope 을 제한해서 밖에서 바뀌지 못하게 함
        (num: Int) => {
        list = list :+ num
        list
        }
    }
    closureTest2(1)
    closureTest2(2)
    closureTest2(3)

## Lazy evaluation
        http://alvinalexander.com/scala/examples-shows-differences-between-strict-lazy-evaluation-in-scala
### Strict
    def lessThan30(i: Int): Boolean = {
        println(s"$i less than 30?")
        i < 30
    }
    def moreThan20(i: Int): Boolean = {
        println(s"$i more than 20?")
        i > 20
    }
    val a = List(1, 25, 40, 5, 23)
    val q0 = a.filter(lessThan30)
    val q1 = q0.filter(moreThan20)
    for (r <- q1) println(s"$r")

### Lazy evaluation
    def lessThan30(i: Int): Boolean = {
        println(s"$i less than 30?")
        i < 30
    }
    def moreThan20(i: Int): Boolean = {
        println(s"$i more than 20?")
        i > 20
    }
    val a = List(1, 25, 40, 5, 23)
    val q0 = a.withFilter(lessThan30)
    val q1 = q0.withFilter(moreThan20)
    for (r <- q1) println(s"$r")

## Pattern Matching
var a:Int=3
var b:String="aa"
def f1(o:Any)={
        o match{
         case o:Int=>"Int"
         case o:String=>"String"
        }
     }
f1(a)
f1(b)


# Function
## Base
### Print
- println
- printf
### String
- mkString
### Functional

## Functional Combinator(함수 콤비네이터)
- map
- foreach
- filter
- withFilter
- zip
- partition
- find
- drop과 dropWhile
- foldRight과 foldLeft
- flatten
- flatMap

## link
|name                 |link                                                                    |
|---------------------|------------------------------------------------------------------------|
|Home                 |http://www.scala-lang.org                                               |
|자바 프로그래머를 위한 스칼라 튜토리얼|http://docs.scala-lang.org/ko/tutorials/scala-for-java-programmers.html|
|스칼라 학교               |https://twitter.github.io/scala_school/ko/index.html                    |
|꽃보다 scala            |http://www.slideshare.net/kthcorp/scala-15041890                        |
|스칼라 문법 요약            |http://blog.jdm.kr/85                                                   |
