# My CLion CodeStyle

## 关于

配置文件`CLionCodeStyle.xml`基于CLion 2026.2.0.1导出，在此前的版本使用可能有兼容性问题。

注：使用本风格在早期的版本可能会遇到以下情况：

```c++
// 如果这个struct或class是此文件的第一个
struct C {<enter>
// 展开后变成
struct C
  {
  };
```

这个问题貌似在CLion更新格式化引擎后才解决，因此，2025.2之前的版本慎用。

同目录下的.clang-format由`CLionCodeStyle.xml`导出，但仅包含部分的编码风格项，作为无CLion环境或导入配置文件的兼容性问题发生时的另一方案。

## 特别说明

此风格最初基于CLion 2021提供的Microsoft风格设置，特点是“不变更行为”，其后的每一个版本都（似乎）沿用了这一理念，对于部分已经存在但不符合本文描述的代码，在格式化时格式化器并不会对其进行变更，但正常编码过程中本文描述的风格仍然是格式化器的第一选项。

本文相较编码规范更侧重编码风格，只是有些设置项无可避免地涉及到编码规范。

本风格当前不是稳定的，会在细节项上微调，但是总体风格是确定的，未来会将某些项固定。

## 具体风格

### 预处理指令

预处理指令统一顶格，在`#`后不要缩进

```c++
#define A   // OK

  #define B // Not
#  define C // Not
```

#### if/ifdef/ifndef-else/elif-endif指令

`#endif`后要附上注释信息，注释当前的`#if`或`#else`分支的含义

```c++
#endif // >= cpp17
```

优先使用`#if defined(xxx)`或`#if !defined(xxx)`代替`#ifdef/#ifndef`

只有你确切该处只会进行宏定义检查时使用`#ifdef/#ifndef`，例如头文件guard。

#### include指令

非项目头文件和直接内嵌进项目的第三方头文件使用`<>`包裹，项目头文件用`""`包裹

```c++
#include <QDebug> // OK
#include <thirdparty/spdlog.h> // OK
#include "hello.h" // OK

#include "QLabel" // Not
#include "thirdparty/proxy.h" // NOT
#include <hello.h> // NOT，即使hello.h位于include路径上
```

不要使用绝对路径；相对路径不应超出项目根目录。

不同来源的头文件要分组，至少分为三类：项目头文件、非项目头文件和标准库头文件。

其中，每个类别内应按所属模块或来源分组：

```c++
#include <gdal_priv.h>
#include <gdal_dataset.h>
#include <QLabel>
#include <QDebug> // OK

#include <QLabel>
#include <gdal_priv.h> // NOT
#include <QDebug>
```

包含顺序为：标准库头文件>非项目头文件>项目头文件，每个类别间可空行，但不超过2行；类别内不空行：

```c++
#include <algorithm>

#include <git2.h>
#include <QDebug>
#include <QLabel>

#include "time/chrono.h"
```

特别注意的是，如果某个源文件是实现文件，其对应的头文件单独一行，置顶，且**必须**与其他头文件之间有空行，但不超过2行。

```c++
/* in foo.cpp */
#include "foo.h" // 放置在所有头文件前
// 这里要有空行
#include <cstdio>
```

### 函数

#### 换行和对齐

函数的左花括号换行。

```c++
int main()
{
  std::cout << "Hello World!" << std::endl;
  return 0;
}
```

单行语句的函数放置在同一行：

> 注：对于这个风格笔者也很犹豫，笔者完全支持不放在同一行，只是formatter必须选择一个

```c++
void foo()
{ do_something(); }
```

返回类型、参数列表尽量位于一行上。

当返回类型过长时，如果换行，返回值类型和函数修饰符单独一行：

```c++
static a_long_name
foo(); // OK

int foo(void* p); // OK

a_short_name
foo(); // NOT
```

当参数列表过长时，换行的形参/实参要对齐，形参类型和参数名始终在同一行，但对于小括号的放置没有特别要求：

> 如果一定有一个要求，就是右括号不要换行，因为本风格的左花括号是换行的，右括号换行浪费行数且看起来不太协调

```c++
foo(int p,
    int k); // OK

bar(
  int p,
  int k); // OK

foobar(
  int p,
  int k
) // OK, but doesn't prefer
{ // looks not good
  // something...
}

barfoo(int p,
       int k
) // OK too, but doesn't prefer either.
```

对于类成员函数，尾随的函数修饰符始终与参数列表的右圆括号同一行：

```c++
void foo() const; // OK
void bar(int p,
         int k) const noexcept; // OK
void foobar()
const noexcept; // NOT
```

对于尾随返回值类型，返回类型和箭头符号始终与参数列表的右圆括号同行：

```c++
auto foo() -> int; // OK
auto foo(
  int p1,
  int p2) -> decltype(p2); // OK

auto foo()
-> int; // NOT
```

对于默认参数，赋值号和参数名称始终在同一行。

#### 空格插入

多个参数的逗号后插入空格：

```c++
foo(1, 2, 3);
void foo(int a, int b, int c);
```

函数名与参数列表间不应有空格：

```c++
void foo(); 
a.foo(); // OK
void foo ();
a.foo (); // NOT
```

空参数列表不要插入空格：

```c++
void foo();
foo(); // OK
void foo( );
foo( ); // NOT
```

尾随返回类型的箭头两侧应当有空格：

```c++
auto foo() -> int; // OK
auto foo()-> int;  // NOT
auto foo()->int; // NOT
```

空函数体内部插入一个空格：

```c++
void foo()
{ }
```

不过同上文所说，当你不打算将`{}`放置在同一行时，不必遵守此规则，但是需要你手动更改配置项。

#### 空行

不同函数的定义间空1行，声明可不空行或空1行，

声明和定义如果不是一体的，之间也要空1行：

```c++
void foo();
void foo_v2(); // OK
            // 1 blank line
void bar(); // OK
            // 1 blank line
void foo()
{
}

void bar()
{
}
```

#### 其他杂项

偏好`constexpr static`：

```c++
constexpr static int foo(); // prefer

static constexpr int foo(); // NOT
```

非必要时不要使用尾随返回类型：

```c++
int foo(); // OK
auto foo() -> int; // NOT

auto bar() -> decltype(<expr>); // FINE
```

#### 命名风格

- 小驼峰或全小写，保持项目内部统一即可。

- 细分为全局函数全小写，其余函数小驼峰命名。

- 需要暴露给其他库的接口函数不必遵守此规则。

### 类

#### 换行、对齐和空格

和逗号有关的空格都是后置的，要不然就是两侧都插入，没有前置空格。

> 换而言之，“正常、大众”的空格插入方法。
>
> 另外，**下文中**除特殊情况也不再提空格插入的事。
>
> 反例如下：
>
> ```c++
> a ,g ,c
> class A: B;
> class A :B;
> ```

类、结构体的左花括号换行：

```c++
class A
{
};
```

访问权限控制符不缩进：

```c++
class A
{
public:
};
```

类成员缩进一次：

```c++
class A
{
public:
  void foo();
};
```

更确切的说，(在CLion的配置中的描述）是**相较访问权限控制符缩进**一次。

空类的左右花括号放置在同一行且插入空格，但简单类的左右花括号不在同一行：

```c++
class B
{ };

struct C
{
  void* p;
};
```

派生类和基类尽量位于同一行上，如果换行，`:`不换行，基类名称换行且对齐：

```c++
class D : B
{ };

class D : B1,
          B2
{ };
```

不在类作用域结束的分号前插入空格，除非声明了typedef或变量：

```c++
class A
{ }; // OK
class A
{} a_instance; // OK
typedef class A
{} AAA; // OK

class A
{ } ; // NOT
```

#### 构造函数

构造函数的初始化列表依据类成员声明顺序排序。

构造函数的初始化列表换行，且缩进一次：

```c++
constructor()
  : a(1), b(2)
```

#### 空行

每个不同访问控制权限块之间空1行：

```c++
public:
  xxx

private:
  yyy
```

不同类的定义间空1行：

```c++
class A
{ };

class B
{ };
```

#### 其他杂项

重写虚函数时，更倾向使用`override`：

```c++
void foo() override // prefer
{
  // impl
}

virtual void foo() // ok but it is not recommended, unless cpp <= cpp03
{
  // impl
}

// that's fine as long as you don't mind typing more
virtual void foo() override
{
  // impl
}
```

#### 命名风格

大驼峰

### 枚举

#### 换行和对齐

枚举的左花括号换行。

为枚举项定义值时，每个项单独一行，且若长度不超过限制，对齐等号：

```c++
enum class e : int
{
  FLAG_OK      = (1 << 1u);
  FLAG_PENDING = (1 << 2u);
  FLAG_FAILED  = 0;
};
```

#### 命名风格

枚举类按大驼峰命名，枚举项容纳大驼峰、小驼峰、全大写和全小写命名风格，统一即可。

本风格中枚举项默认为全大写。

### 命名空间

#### 换行和缩进

左花括号不换行：

```c++
namespace {
}
```

命名空间内缩进一次：

```c++
namespace std {
  concept aaa = true;
}
```

#### 杂项

更偏好使用嵌套命名空间而非聚合的命名空间：
```c++
namespace A { // prefer
  namespace B {
  }
}

namespace A::B { // fine, but formatter can just choose one, above
}

namespace A { namespace B { // No, No, No, it's worse

}
}
```

命名空间尾部应该有注释：
```c++
namespace A {

} // namespace A
```

但是当前提供的CLion版本中似乎没有此风格的设置（似乎早期有），但是clang-format明确支持这一选项`FixNamespaceComments`。

#### 命名风格

全小写

### extern语句

#### 换行和缩进

作用域的左花括号不换行：
```c++
extern "C" {
}
```

`extern`作用域内不单独缩进：
```c++
extern "C" {
void foo();
}
```

### 变量

#### 对齐

不对变量统一赋值时的等号对齐有要求，但限于格式化器，行为就是强制不对齐。

#### 指针和引用

单一变量的`*`和`&`紧贴类型：
```c++
int* p;
```

多个变量的`*`和`&`紧贴变量：
```c++
int *p, &r;
```

聚合声明的`*`紧贴变量：
```c++
int (*p)(double);
```

#### 命名风格

无论是否是`const/constexpr/constinit`或`volitale`变量，是否是全局或局部变量，均为全小写命名。

### lambda表达式

#### 换行和缩进

lambda的左花括号不换行：
```c++
auto lambda = []() -> int {
};
```

<!--TODO: 这里需要优化lambda的配置项，有描述不一致的地方和格式化错误的地方-->
lambda表达式内缩进一次：
```c++
auto lambda = []() -> int {
  return 0;
};
```

#### 空格插入

<!--TODO: 这里需要优化lambda的配置项，目前允许在模板列表前插入空格-->
只在表示返回类型的箭头符号两侧和返回值类型两侧插入空格
```c++
[]<typename T>(int p) -> int { };
```

### 布尔表达式

#### 换行和对齐

如果换行，三元表达式的`?`和`:`对齐
```c++
pred ? if_true
     : if_false
```

如果`?`换行，那么`?`要对齐到条件：
```c++
auto b = std::is_xxx_v<expr>
         ? if_true
         : if_false;
```

换行时，逻辑运算符至于行首，且对齐到第一个条件
```c++
if (aaa && bbb || ccc
    && ddd)
```

### 初始化

#### 换行、空格、缩进和对齐

列表初始化的左花括号与变量不分离：
```c++
Class c{};
```

初始化列表的两侧不插入空格：
```c++
Class c{1, 2, 3};
```

列表初始化若要换行，每一个参数单独一行且对齐，并缩进一次：
```c++
Class c{
  1,
  2,
  3
};
```

非列表初始化（圆括号初始化）的要求同函数调用。

### 流程控制语句

#### 换行和缩进

流程控制语句的左大括号均不换行：
```c++
if/switch/do/while/for () {
}
```

`else`不单独一行：
```c++
if {
} else {
}
```

`case`标签不相对switch缩进，但case标签下的内容缩进：
```c++
switch (o) {
case 1:
  print(1);
default:
  print(0);
}
```

### 模板

#### 换行、缩进和对齐、空格

声明参数列表时，`template`后不加空格：
```c++
template<>
template<template<typename T> U>
```

`template<...>`始终独立一行：
```c++
template<typename T, typename D>
struct Container;
```

参数列表换行时，以`typename`或`class`关键字为准对齐：
```c++
template<typename T
         typename U>
```

尖括号的换行法则类似函数参数列表圆括号的换行法则。

#### 命名风格

类型或非类型模板形参均用大驼峰命名法。

### requires语句

#### 换行和缩进

requires语句的左花括号不换行：
```c++
requires (T t) {
}
```

模板声明处的requires语句要缩进：
```c++
template<typename T>
  requires std::is_intergral_v<T>
```

`requires`后面的概念或条件在换行时，对齐，方式同布尔表达式。

`requires`关键字要始终和参数列表置于同一行上：
```c++
template<typename T>
  requires B<T> && C<T>
           && requires (T t) {
             expr(t);
           }
```

### 注释

命名空间的尾部、if-endif预处理指令的尾部都要附上注释。

行尾的注释无需对齐，但本风格不推荐大量的行尾注释，更偏好注释单独成行。
