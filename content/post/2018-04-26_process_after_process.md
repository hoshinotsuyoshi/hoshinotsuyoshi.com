+++
date = "2018-04-26T23:32:09+09:00"
draft = false
title = "あるプロセスが終わるのを待って、そのあと何かをする"
slug = "process_after_process"
tags = ["ruby","linux", "mac"]
image = "images/yokosuka.jpg"

+++

あるプロセスが終わるのを待ってから、別の何かをしたいときがある。

うっかり長い処理を走らせてしまったときとか。

<!--more-->

* それが終わった後に、dateコマンドを叩いて、終わった時刻が知りたい
* それが終わった後に、何か別のことをやりたい(通知とか)

とかとか。


子プロセスなら `wait` が使えるのだけど。

### こういうのでどうか

終わった後に `date` を叩きたいとして、

```sh
$ # pgrepとかでプロセス番号を調べておく
$ #
$ ruby -e "loop { Process.getpgid(プロセス番号) ; sleep 1 } " ; date
```

これならrubyさえあれば動く。

シェルスクリプトでループを書くやり方が覚えられない👼
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180426-1" %}}
