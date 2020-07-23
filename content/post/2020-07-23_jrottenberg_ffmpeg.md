+++
date = "2020-07-22T23:31:56+09:00"
draft = false
title = "iPhoneで画面収録した.mp4をGitHub用にアニgifにする"
slug = "jrottenberg_ffmpeg"
tags = ["ffmpeg","docker"]
image = "images/iphone_capture.png"
+++

iPhoneの画面収録した.mp4をGitHub用にアニgifにします。

<!--more-->

### 工夫

ffmpegをbrewでinstallすると色々壊れたことがあるので、Dockerを使います。

### 準備

[iPhone、iPad、iPod touch で画面を録画する方法 - Apple サポート](https://support.apple.com/ja-jp/HT207935)で録画しておきます。

### やること

結論のコマンドはこちらです。


```
$ docker run --rm -v `pwd`/input:/input -v `pwd`/output:/output jrottenberg/ffmpeg:3.3-alpine -i /input/input.mp4 -r 24 /output/output.gif
```

これを行う前に、inputディレクトリとoutputディレクトリを作っておきます。

```
$ mkdir input
$ mkdir output
```

あとは、Airdropか何かでmacに転送した.mp4ファイルをinputディレクトリの下にinput.mp4として配置し、

上述のコマンドを実行すると、outputディレクトリの下にoutput.gifが置かれます。🚀



<script type="text/javascript" src="/js/prism.js" async></script>
