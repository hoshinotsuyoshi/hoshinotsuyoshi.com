+++
date = "2018-06-24T05:56:48+09:00"
draft = false
title = "⚡neovim + 🍻ale + 🚓rubocop"
slug = "neovim_rubocop_autocorrect"
tags = ["neovim","vim","rubocop","lint","ale"]

+++

## TL;DR

* neovimにale([w0rp/ale](https://github.com/w0rp/ale)、vimの非同期Linter)を入れて編集中にrubocopが走るようにしてみました。
  * 自分の場合は5行追加で動いた
* また、お試しで保存時(:w)にauto-correctが走るようにしてみました。
  * 自分の場合は1行追加で動いた

<!--more-->

## 編集中に非同期的にrubocopが走る 🚓

未保存の状態でも違反箇所がわかるようになります。

以下の例だと、`--` がついた箇所が違反箇所です。

違反箇所にカーソルを合わせるとvimのステータスラインに違反内容が表示されます。

<img alt="neovim_rubocop" src="/images/neovim_rubocop.gif" width=800>

### 👆 をやるための設定

#### rubocop

rubocop gemはgemコマンドやbundleコマンドでインストールされていることが前提です。

自分の場合はbundler経由でも特に問題なく動作しました。

[ale側のソース](https://github.com/w0rp/ale/blob/34aa3437e0fc062215020b423bdf57da449e9400/autoload/ale/fixers/rubocop.vim)読むとそのあたりはaleがよしなにやってくれそうな雰囲気を感じました。

#### ale

aleを利用できるようにします。

ググって[この記事](https://wonderwall.hatenablog.com/entry/2017/03/01/223934)とかを参考にしましたが、
自分の場合はdein.tomlみたいな設定ファイルで管理してるので、以下を追記して `call dein#install()` で。

```toml
[[plugins]]
repo = 'w0rp/ale'
```

次にaleが呼ぶlinterとしてrubocopを指定します。
自分の場合は~/.config/nvim/init.vimにベタに書きました。

```vimscript
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\}
```

これだけ。

## さらに保存時にrubocop --auto-correctが走るようにする 🚓

保存直後に、自動的に直せるところは直すようにしてみました。

<img alt="neovim_rubocop_autocorrect" src="/images/neovim_rubocop_autocorrect.gif" width=800>

これは便利そうですが、うざいときはうざそうなので、様子を見て考えます。

### 👆 をやるためのneovim設定

以下を追記します。

```vimscript
let g:ale_fix_on_save = 1
```

### ✎まとめ

* 保存直後にオートコレクトするやつは様子見る
