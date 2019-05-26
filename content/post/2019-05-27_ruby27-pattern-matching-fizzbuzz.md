+++
date = "2019-05-27T07:12:02+09:00"
draft = false
title = "Ruby2.7のpattern matchingで四則演算と数値リテラルを使わずにFizzBuzz"
slug = "ruby27-pattern-matching-fizzbuzz"
tags = ["ruby"]
image = "defimg/1.jpg"
+++

Ruby2.7のpattern matchingを使うと四則演算と数値リテラルを使わずにFizzBuzzできる。

<!--more-->

パターンマッチ試してみた。

とにかく

* スプラットが強力
* Array Patternが強力

という印象を持った。

こんな感じで書ける!長いけど。

```ruby
NOT_F = /\A[^F]+\z/ 
NOT_B = /\A[^B]+\z/ 
def fizzbuzz(a)
  a << ''
  case a
  in [*, /B/, _, /F/, _, _, x]          ; x << 'FizzBuzz'
  in [*, NOT_F, NOT_F, x]               ; x << 'Fizz'
  in [*, NOT_B, NOT_B, NOT_B, NOT_B, x] ; x << 'Buzz'
  in [*, x]                             ; x << a.size.to_s
  end
  puts a.last
  fizzbuzz(a)
end

fizzbuzz([])
```

正規表現使わなくても、こんな感じで書ける!長いけど。

```ruby
def fizzbuzz(a)
  buffer = ''
  case a
  in [] | [*, :_0] | [[*, :_0]]
    a << :_1
  in [*, :_1] | [[*, :_1]]
    a << :_2
  in [*, :_2] | [[*, :_2]]
    a << :_0
    buffer << 'Fizz'
  end

  case a
  in [[*], _, _, _, _]
  in [_, _, _, _, _] | [[*], _, _, _, _, _]
    a = [a]
    buffer << 'Buzz'
  else
  end

  buffer << a.flatten.size.to_s if buffer.empty?
  puts(buffer)
  fizzbuzz(a)
end

fizzbuzz([])

# []
# [1]
# [1, 2]
# [1, 2, 0]
# [1, 2, 0, 1]
# [[1, 2, 0, 1, 2]]
# [[1, 2, 0, 1, 2], 0]
# [[1, 2, 0, 1, 2], 0, 1]
# [[1, 2, 0, 1, 2], 0, 1, 2]
# [[1, 2, 0, 1, 2], 0, 1, 2, 0]
# [[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1]]
# [[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1], 2]
# [[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1], 2, 0]
# [[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1], 2, 0, 1]
# [[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1], 2, 0, 1, 2]
# [[[[1, 2, 0, 1, 2], 0, 1, 2, 0, 1], 2, 0, 1, 2, 0]]
```

もっとうまく書ける気もする。

使ってるバージョンは下記の通り。

```bash
$ ruby -v
ruby 2.7.0dev (2019-05-25 trunk 65ce14e7b5) [x86_64-darwin17]
```

### その他、パターンマッチングが嬉しいときの例


木構造を扱うときに嬉しいみたい。

#### ✍クイックソート

[メドピアさんのブログ](https://tech.medpeer.co.jp/entry/2019/05/13/090000)の例がよくて

```ruby
def qsort(ary) 
  case ary
  in [piv, *xs] # 要素が2個以上
    lt, rt = xs.partition{|x| x < piv}
    qsort(lt) + [piv] + qsort(rt)
  else # 要素が0個または1個
    ary
  end
end
```

#### ✍赤黒木

<iframe width="978" height="550" src="https://www.youtube.com/embed/1qEhEad5uPI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

このRubyKaigiのトークの[11:12あたり](https://youtu.be/1qEhEad5uPI?t=672)

<script type="text/javascript" src="/js/prism.js" async></script>
