+++
date = "2016-08-14T14:36:41+09:00"
draft = false
title = "[テスト投稿]jqの--exit-statusオプションについて調べてまとめたので100ブクマぐらいお願いします"
slug = "jq-exit-status"
tags = ["jq"]
image = "images/saturn-sendai-city-museum.jpg"

+++

manすると1文が長くてつらい。neither A nor Bとか懐かしい。両方否定ね。 

> man jq 

>        o   -e / --exit-status:
           Sets  the exit status of jq to 0 if the last output values was nei-
           ther false nor null, 1 if the last output value was either false or
           null,  or 4 if no valid result was ever produced. Normally jq exits
           with 2 if there was any usage problem or system error, 3  if  there
           was a jq program compile error, or 0 if the jq program ran.


## まとめ

 command | stdout | exit status
---------|---------|---------
$ echo '{}'    \| jq               .  | `{}`    | `0`
$ echo '{}'    \| jq --exit-status .  | `{}`    | `0`
$ echo 'true'  \| jq               .  | `true`  | `0`
$ echo 'true'  \| jq --exit-status .  | `true`  | `0`
$ echo 'false' \| jq               .  | `false` | `0`
$ echo 'false' \| jq --exit-status .  | `false` | `1`
$ echo 'null'  \| jq               .  | `null`  | `0`
$ echo 'null'  \| jq --exit-status .  | `null`  | `1`
$ echo 'foo'   \| jq               .  | ((エラー出力にparse error: Invalid literal at line 2, column 0))      | `4`
$ echo 'foo'   \| jq --exit-status .  |  ((エラー出力にparse error: Invalid literal at line 2, column 0))       | `4`

以上です

元ページ：

<iframe src="http://hoppie.hatenablog.com/embed/2016/07/29/142935" title="jqの--exit-statusオプションについて調べてまとめたので100ブクマぐらいお願いします - パラボラアンテナと星の日記" class="embed-card embed-blogcard" scrolling="no" frameborder="0" style="display: block; width: 100%; height: 190px; max-width: 500px; margin: 10px 0px;"></iframe>
