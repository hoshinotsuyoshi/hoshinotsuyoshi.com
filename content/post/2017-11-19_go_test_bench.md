+++
date = "2017-11-19T00:01:29+09:00"
draft = false
title = "go testの-benchを使いつつProject Eulerの4問目を解いた・速くした🚀"
slug = "go_test_bench"
tags = ["golang","test","project_euler"]
image = "images/euler.jpg"

+++

趣味プログラミングです。

go test の-benchを使い、Project Eulerの問題を解くプログラムを速くしていった過程を書きます。

解く&テスト書く -> 速くする という流れです。

<!--more-->

## 今日のお題

Project Eulerの第4問[日本語訳](http://odz.sakura.ne.jp/projecteuler/index.php?cmd=read&page=Problem%204)から。

> 左右どちらから読んでも同じ値になる数を回文数という.

> 2桁の数の積で表される回文数のうち, 最大のものは 9009 = 91 × 99 である.

> では, 3桁の数の積で表される回文数の最大値を求めよ.

適当なループを書くと `995*583=580085` みたいな答えが出てきて誤答します。

誤答しませんか。私は間違えました👼


## 解く&テスト書く

さて、間違えずに、以下のようにして解いた、とします。

このパッケージではSolveという関数が計算結果を返しています。

### euler004/main.go

```go
package euler004

const max = 999
const min = 100

func Solve() int {
	i := max
	candidate := 0
	for {
		j := i
		for {
			x := i * j
			if reversible(x) {
				if candidate < x {
					candidate = x
				}
			}
			j--
			if j < min {
				break
			}
		}
		i--
		if i < min {
			break
		}
	}
	return candidate
}

func reversible(arg int) bool {
	x := arg
	if x%10 == 0 {
		return false
	}
	y := 0

	for {
		y += (x % 10)
		x = x / 10
		if x == 0 {
			break
		}
		y = y * 10
	}

	return arg == y
}
```

### euler004/main_test.go

Solveの出力をチェックするテストも書いておきます。

```go
package euler004_test

import (
	"fmt"
	e "github.com/hoshinotsuyoshi/study-go/euler/euler004"
)

func Example_Solve() {
	fmt.Println(e.Solve())
	// Output:
	// 906609
}
```

このテストは 以下のように実行できます

```sh
$ go test euler004/main_test.go
ok      command-line-arguments  0.007s
```

<br/>
<br/>

## 計測 ⏳

さて、ここから本題です。

まず、テスト側にベンチマークをとるためのコードを入れます。

```diff
--- a/euler/euler004/main_test.go
+++ b/euler/euler004/main_test.go
@@ -3,7 +3,6 @@ package euler004_test
 import (
        "fmt"
        e "github.com/hoshinotsuyoshi/study-go/euler/euler004"
+       "testing"
 )

 func Example_Solve() {
@@ -11,9 +10,3 @@ func Example_Solve() {
        // Output:
        // 906609
 }
+
+func Benchmark_Solve(b *testing.B) {
+       for i := 0; i < b.N; i++ {
+               e.Solve()
+       }
+}
```

これを `-bench` をつけて実行します。

```sh
$ go test -bench . euler/euler004/main_test.go
goos: darwin
goarch: amd64
Benchmark_Solve-4            300           5796457 ns/op
PASS
ok      command-line-arguments  1.180s
```

1回の処理に `5796457 ns` かかっていることがわかりました。


<br/>
<br/>

## 速くする 🚀

速くできる余地を後から見つけました(と、いうことにしましょう!)。修正します。

```diff
--- a/euler/euler004/main.go
+++ b/euler/euler004/main.go
@@ -5,23 +5,27 @@ const min = 100

 func Solve() int {
        i := max
+       element := 0
        candidate := 0
        for {
                j := i
                for {
                        x := i * j
                        if reversible(x) {
+                               if element < j {
+                                       element = j
+                               }
                                if candidate < x {
                                        candidate = x
                                }
                        }
                        j--
-                       if j < min {
+                       if j < element || j < min {
                                break
                        }
                }
                i--
-               if i < min {
+               if i < element || i < min {
                        break
                }
        }
```

もう一度test実行。


```sh
$ go test -bench . euler/euler004/main_test.go
goos: darwin
goarch: amd64
Benchmark_Solve-4          10000            115018 ns/op
PASS
ok      command-line-arguments  1.180s
```

`5796457 ns` -> `115018 ns`になりました!
50倍ぐらい速くなりました!!! 🚀🚀 わーい!(わざとらしい)

ちなみに、私はアルゴリズム詳しくないので、もっと速くなると思います👼


## まとめ

今回は`_test.go`なファイルの中にベンチマーク測定のコードを入れる方法を説明しました。

go楽しいですね。

以上です🎅

## 環境とか

```
$ go version
go version go1.9.2 darwin/amd64
```

## 参考

[Go でベンチマーク - Block Rockin’ Codes](http://jxck.hatenablog.com/entry/20131123/1385189088)
<script type="text/javascript" src="/js/prism.js" async></script>
