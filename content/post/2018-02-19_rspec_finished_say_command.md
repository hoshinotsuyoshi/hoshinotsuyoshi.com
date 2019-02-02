+++
date = "2018-02-19T01:46:22+09:00"
draft = false
title = "テストの実行が終わったら「rspecが終わりました📢」と音声で通知する"
slug = "rspec_finished_say_command"
tags = ["rspec","rails","macOS"]

+++

rspecの実行が終わったら「rspecが終わりました📢」と音声で通知するようにしてみた。

意外と良い。

ちょっと長めの `$ rspec spec/requests` とか流したときに、slack眺めたり別のことができる。

<!--more-->

### コマンド

zshrcとかにこう書いておく。

```zsh
alias rspec='(){ rspec "$*" ; say "アールスペックが終わりました" }'
```

### ちなみに

上記コマンドだと単体で `rspec` とやるとうまく動かない。直すの面倒なので放置。

あと終了コードとかも全然考慮してない。そのまま使うのは注意が必要。
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180219-1" %}}
