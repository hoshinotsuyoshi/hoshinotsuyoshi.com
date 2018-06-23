+++
date = "2018-06-24T05:13:28+09:00"
draft = false
title = "tmuxで今prefixキーが押されているかどうかをわかるようにした"
slug = "tmux_show_prefix_key_status"
tags = ["tmux"]

+++

ほぼ[この記事](https://qiita.com/dtan4/items/363e92525e7c5a16f3fc) のとおりにやりました。

<!--more-->

prefix key(私の場合 `C-j`に設定している)を押すと、左上に置いた文字 `tmux` が反転するようにしました。

<img alt="tmux" src="/images/tmux_prefix_key_status.gif" width=800>

<br>
<br>

### ✎.tmux.confに設定追加

<br>

```diff:.tmux.conf
+# https://qiita.com/dtan4/items/363e92525e7c5a16f3fc
+set-option -g status-left '#[fg=cyan,bg=#303030]#{?client_prefix,#[reverse],} tmux #[default]'
+
```

<br>
<br>

### 何が嬉しいか

<br>

**間違えて大文字のJとかを打って、効かなくて???ってなることが、年に100回ぐらいある気がする** ので、これで生活力が向上しそうです。


<br>
<br>
