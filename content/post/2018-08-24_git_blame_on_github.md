+++
date = "2018-08-25T00:15:53+09:00"
draft = false
title = "neovimからgithubのblameのページに飛べるようにした"
slug = "git_blame_on_github"
tags = ["neovim","vim","git","github"]
image = "images/pc_manual_irasutoya.png"

+++

### モチベーション

* 大抵のことは黒い画面でgitコマンド使う。しかし
* vimでソース読んでて経緯を知りたいことがある
  * その場所を **最後に編集したPRを読みたくなる**
  * vimから離れる -> git blame -> commit番号を調べる -> PRを見る
  * ↑ **これが手間**
* tigとかhubとかは使い方覚えられない(覚えろ)


という感じで、vimからすぐPRに飛びたいのです。

<!--more-->

### 既存のプラグインと改造

「開いているファイルの、githubのblobページに移動する」というプラグインがありました。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-type="article"><h4><a href="https://github.com/tonchis/vim-to-github">tonchis/vim-to-github</a></h4><p>vim-to-github - Will take you from Vim to GitHub</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

これを真似すればよさそうです。

forkし、**blobページではなくblameページに遷移するように改造しました。**

https://github.com/hoshinotsuyoshi/vim-to-github/commit/a670449c1bf09e01f0dbd974ea75d7a308274c5b

あとはこんなふうにdein経由でこのリポジトリの場所を指定すればインストールできます。


```toml
# 自分の場合は dein.toml で管理している
[[plugins]]
repo = 'hoshinotsuyoshi/vim-to-github'
```

<br>
<br>

### ショートカットキーの設定

ノーマルモードから `スペース2回+g` で発動するように設定しました

```
" ~/.config/nvim/init.vim

" GitHubで開く https://github.com/tonchis/vim-to-github
nnoremap <silent> <Space><Space>g :<C-u>ToGithub<CR>
```

### 動き

<img alt="slack" src="/images/vim_to_github_blame.gif" width=800>

これ **2ヶ月ぐらい使ってますが、ちょうべんりです**

### ✎まとめ

* ちょうべんりです
* vimscript書けると世界が広がりそう

<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180824-1" %}}
