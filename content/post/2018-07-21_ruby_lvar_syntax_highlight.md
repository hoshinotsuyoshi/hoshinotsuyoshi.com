+++
date = "2018-07-21T13:53:24+09:00"
draft = false
title = "rubyで、「ローカル変数かメソッドか」は区別できるということと、vimのシンタックスハイライト"
slug = "ruby_lvar_syntax_highlight"
tags = ["ruby","neovim","dein","rubocop"]
image = "images/lvar_after.png"

+++

<!--more-->

## ローカル変数 か メソッドか

以下のファイルを用意し、

```ruby
# test.rb
@a
:x
Hash
a = 1
a
b

puts(:ended!)
```

`ruby -cw test.rb` を実行すると

`@a`, `:x`, `Hash`, `a` のところは警告が出る。

```shellscript
$ ruby -cw test.rb
test.rb:2: warning: possibly useless use of a variable in void context
test.rb:3: warning: possibly useless use of a literal in void context
test.rb:4: warning: possibly useless use of a constant in void context
test.rb:6: warning: possibly useless use of a variable in void context
Syntax OK
```

rubocopの `Lint/Void` も同じような警告を出す。

しかし、`b` のところは**警告が出ない。**

これは、**`b` というローカル変数が、前もって定義されていないことがわかっている** から。

標準添付の `ripper` ライブラリや `parser` gem(rubocopが使ってるやつ)で解析できる。

これを利用してローカル変数とメソッドを区別してシンタックスハイライトするのが [todesking/ruby_hl_lvar.vim](https://github.com/todesking/ruby_hl_lvar.vim)。

<a class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-type="article-full" href="http://www.todesking.com/blog/2014-04-29-highlight-ruby-local-variables-in-vim/">Rubyのローカル変数をシンタクスハイライトするVimプラグインを書いた - TODESKING</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>


手元のneovimでも動いた。これを入れるとこうなる👇。

### before

<img alt="ruby neovim lvar before" src="/images/lvar_before.png" width=600>

### after

<img alt="ruby neovim lvar before" src="/images/lvar_after.png" width=600>


---

自分の場合は `$ gem install neovim` が必要だった。

なお、自分のcolorscheme設定だと、他には特に何も設定せずに、いい感じに色がついた。


## iro.vim

そして[pocke/iro.vim](https://github.com/pocke/iro.vim)というやつでもこれは実現できる。ということを手元でも確認した。

rubykaigiでもトークがあったやつ。

<iframe width="560" height="315" src="https://www.youtube.com/embed/8tarr2k0kMI?start=793" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>


こっちは、私の色の設定がうまくいかなかったので、今日はここまで。

### ✎まとめ

理論はわかるんだが、vimの色設定周りがよくわからん
<script type="text/javascript" src="/js/prism.js" async></script>
