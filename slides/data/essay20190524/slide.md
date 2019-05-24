# vimでrubocopをすっごく速く動かす

%author: hoshinotsuyoshi

%icon: ![](hoshinotsuyoshi.jpg)

%duration: 10min

## こんにちは

%big: ![](shinchoku.png)

## アジェンダ

* vimでrubocop動かす
* rubocop-daemonめっちゃ速い
* さらに速くする妄想

## アジェンダ

* <b>vimでrubocop動かす</b>
* rubocop-daemonめっちゃ速い
* さらに速くする妄想

## 最初に: rubocopとは

静的コード解析器であり、Lintツールであり、コードフォーマッタ。

エディタと連携できる。

## 使い方おさらい

`rubocop [options] [file1, file2, ...]`

## エディタに関係の深いオプション

* -a/--auto-correct
    * オートコレクト。自動修正できるやつは自動修正する。
* -s/--stdin <i>FILE</i>
    * 標準入力からrubyのコードを受け取る。
    * エディタとの連携用。

## 余談1: --stdinになんでFILE引数が要るの?

%big: ![](stdin-output.png)

## 余談1: --stdinになんでFILE引数が要るの?

%big: ![](stdin-output2.jpg)

## 余談2: 他のツールの--stdinオプション

* `eslint(JavaScript)`
    * `--stdin` と `--stdin-filename ファイル名` がある
* `flake8(Python)`
    * `--stdin` と `--stdin-display-name ファイル名` がある

## 余談3: -aと--stdinを組み合わせると?

基本的に一緒には使わない。

https://github.com/rubocop-hq/rubocop/blob/v0.70.0/lib/rubocop/cli.rb#L330-L340

## 余談3: -aと--stdinを組み合わせると?

%big: ![](stdin-a.jpg)

## 今日はこういうエディタ環境

* Neovim
    * エディタ
* ALE
    * Neovim/Vim8 で動く非同期Lintツール
* rubocop
    * 0.70.0

## 今日のエディタ設定と、裏側で動くオプション

* ALEのlinter
    * バッファに変更があると `rubocop --stdin` が走る
    * 違反行にマークがつく
* ALEのfixer
    * 保存時に `rubocop -a` が走る

## アジェンダ

* <del>vimでrubocop動かす</del>
* <b>rubocop-daemonめっちゃ速い</b>
* さらに速くする妄想

---

#### "rubocop -a is slow"

### "rubocop -a is slow"

* [rubocop-hq/rubocop#6492](https://github.com/rubocop-hq/rubocop/issues/6492)
* (この人もエディタからrubocop呼んでる)
* 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
* 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
* 　
* 　

### "rubocop -a is slow"

* [rubocop-hq/rubocop#6492](https://github.com/rubocop-hq/rubocop/issues/6492)
* (この人もエディタからrubocop呼んでる)
* 「とある1100行ぐらいの.rbファイル ([strong_parameter.rb](https://raw.githubusercontent.com/rails/rails/master/actionpack/lib/action_controller/metal/strong_parameters.rb)) で rubocop -a を試した」
* 　
* 　

### "rubocop -a is slow"

* [rubocop-hq/rubocop#6492](https://github.com/rubocop-hq/rubocop/issues/6492)
* (この人もエディタからrubocop呼んでる)
* 「とある1100行ぐらいの.rbファイル ([strong_parameter.rb](https://raw.githubusercontent.com/rails/rails/master/actionpack/lib/action_controller/metal/strong_parameters.rb)) で rubocop -a を試した」
* 「実行に 1.37secかかる」
* 「そのうち<u>requireに0.66sec</u>かかっている」

---

#### どういうことか

# exe/rubocopを読む

# exe/rubocopを読む

%big: ![](require-run-raw.png)

# exe/rubocopを読む

%big: ![](require-run.jpg)

# exe/rubocopを読む

%big: ![](require-run-066.jpg)

# exe/rubocopを読む

%big: ![](require-run-0.jpg)

---

#### "rubocop-daemon使うと速いよ"

---

#### 👀 [github.com/forte/rubocop-daemon](github.com/forte/rubocop-daemon)

---

%big: ![](rubocop-daemon.png)

# rubocop-daemonのexec.rb

%large: ![](rubocop-daemon-exec.png)

# rubocop-daemonのexec.rb

%large: ![](rubocop-daemon-exec-mark.jpg)

# rubocop-daemonのexec.rb

%large: ![](rubocop-daemon-exec-mark-2.jpg)

# [rubocop-daemon-wrapper](https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper)

* rubocop-daemonとnetcatでやりとりするbashスクリプト!
    * rubocop-daemonの自動起動
        * 動いてなかったら動かす
    * netcat使うから速い
        * netcat使うから速いらしい(くわしくない🙇)
* PATH通ってるところに置いて使う

# [rubocop-daemon-wrapper](https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper)

```
curl https://raw.githubusercontent.com/fohte/rubocop-daemon/master/bin/rubocop-daemon-wrapper -o /tmp/rubocop-daemon-wrapper
sudo mv /tmp/rubocop-daemon-wrapper /usr/local/bin/rubocop-daemon-wrapper
sudo chmod +x /usr/local/bin/rubocop-daemon-wrapper
```

# vimタイム

```diff
- let g:ale_ruby_rubocop_executable = 'rubocop'
+ let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper'
```

---

#### 速いですね🎉

## アジェンダ

* <del>vimでrubocop動かす</del>
* <del>rubocop-daemonめっちゃ速い</del>
* <b>さらに速くする妄想</b>

---

#### さらに速くなる余地を考えてみました!

---

#### その1: キャッシュを消すのをやめる

# 【参考】rubocopのキャッシュとは

* yamlデフォルトで `AllCops: UseCache`
* オプション `-C/--cache FLAG` でオン・オフを指定できる
* ただし `--stdin` のときはキャッシュが効かない
    * つまり「バッファ変更時(rubocop --stdin)」は効かない
    * 「save時(rubocop -a)」は効く

# 【参考】rubocopのキャッシュとは

* offence(違反)のキャッシュ。
* 1ファイルにつき1個のJSONファイル。
* ~/.cache/rubocop_cacheの下に溜まっていく。

# 【参考】rubocopのキャッシュとは

%large: ![](cache-tree.png)

# 【参考】rubocopのキャッシュとは

* ディレクトリ2層+ファイル名
    * $LOADED_FEATURESのファイル全部の中身を連結した文字列のSHA1 digest
    * optionのSHA1 digest
    * 対象ファイルの中身及び設定に由来するデータのSHA1 digest

# キャッシュONのとき

* キャッシュを探す
* キャッシュがあればその中身を返す
* キャッシュを掃除するべきか調べる
* 量が多ければ(デフォルト20000)キャッシュを消す

# キャッシュONのとき

* キャッシュを探す
* キャッシュがあればその中身を返す
* <u>キャッシュを掃除するべきか調べる</u> <- 8000個で220ms❗
* 量が多ければ(デフォルト20000)キャッシュを消す

# エディタの時はキャッシュを消すのをやめたい!

* エディタの時は、対象ファイルは1個のはず
* キャッシュが1個増えるだけだから、掃除しなくてもよいのでは?

=> (エディタの時でもそうでないときでも) 対象ファイルが1個のときは、キャッシュを消さなくてもいいのでは?

# PR出した!!

* 出した! [rubocop-hq/rubocop#7069](https://github.com/rubocop-hq/rubocop/pull/7069)
    * 昨日(2019/5/23)マージされた! 🎉

---

#### その2: バッファ変更時にもキャッシュが効くようにしたい(願望)

# バッファ変更時にもキャッシュが効くようにする

* まだPR出してない
* 調査中
    * 何故かこれやるとALEが動かない気がする...
    * (何か勘違いしてて)もしかしたらできないかも...
    * 詳しい人教えてくれ
* 実現できれば、strong_parameter.rbで 300msぐらい速くなりそう!

# まとめ1: rubocop-daemonすごい

* 使うだけでほとんどの場合 -0.80sec 🚀 ぐらいいくはず!

# まとめ2: 保存時のパフォーマンスアップ

* キャッシュがたくさんあったときにも、遅くならないようにしたつもり!
   * (例：8000個ぐらいのときに) 従来比: -0.22sec 🚀
* 0.70.0の次のバージョンで!

# まとめ3: バッファ変更時のパフォーマンスアップ(妄想)

* これ妄想
* strong_parameters.rbで -0.3secぐらい速くなりそう!

## 自己紹介

* [github.com/hoshinotsuyoshi](https://github.com/hoshinotsuyoshi)
* [twitter.com/@hoppiestar](https://twitter.com/hoppiestar)
* ECサイトをrailsで作ってます

%icon: ![](hoshinotsuyoshi.jpg)
