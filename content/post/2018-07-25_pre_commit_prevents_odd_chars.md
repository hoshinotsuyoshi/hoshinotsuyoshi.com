+++
date = "2018-07-25T00:25:48+09:00"
draft = false
title = "濁点の合成文字がソースコードに入っちまった💢 -> gitのpre-commit hookで打ち勝った"
slug = "pre_commit_prevents_odd_chars"
tags = ["ruby","git"]

image = "images/slack_display.png"
+++

濁点文字をソースコードに入れてしまって不具合を起こしてしまうということがありました。

<!--more-->

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">自分の書いたカタカナの濁点が合成文字になってて(バ= ハ+゛みたいなやつ)そのバグに気づかなくて30分ぐらい無駄にしたアカウントです</p>&mdash; hoshinotsuyoshi🥴 (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1021316434062819329?ref_src=twsrc%5Etfw">July 23, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

なんという不覚。。

githubで見ても手元のvimで見ても見た目上は全く違いがわからんという状態。

いや、見た目でわかると思ったんですけどね

ちょっと以下3つの「バ」を見てください。


### 濁点アリの1文字「バ」

* [U+30D0 KATAKANA LETTER BA](https://codepoints.net/U+30D0)

```
バ
```

これが普通のバ。

### 2文字「ハ」+「゛」

* [U+30CF KATAKANA LETTER HA](https://codepoints.net/U+30CF)
* [U+309B KATAKANA-HIRAGANA VOICED SOUND MARK](https://codepoints.net/U+309B)

```
ハ゛
```

👆くっつきかたが、ちょっと不自然だね!?不自然だね!?

IMEで「てんてん」と打って変換されるやつがこれ。

### 2文字「ハ」+「゙」

* [U+30CF KATAKANA LETTER HA](https://codepoints.net/U+30CF)
* [U+3099 COMBINING KATAKANA-HIRAGANA VOICED SOUND MARK](https://codepoints.net/U+3099)

```
バ
```

👆くっつきかたが、、、え、、、自然だね!?
これ最初のやつと見分けつかんね!?

今回はこいつにやられました。。

## そもそも濁点は2種類あった!

**「船は「2隻」あったッ!」って感じなんですが(ジョジョ5部アニメ楽しみですね)**、

濁点は2つあるのか、、

* [U+3099 COMBINING KATAKANA-HIRAGANA VOICED SOUND MARK](https://codepoints.net/U+3099)
* [U+309B KATAKANA-HIRAGANA VOICED SOUND MARK](https://codepoints.net/U+309B)

**COMBINING** のほうは、合成されるやつなんですね。 http://bardiel-of-may.blogspot.com/2013/05/blog-post.html こんな感じで。

## どう防ぐか 🤔

見た目上は区別つかないし、vimの設定やるのもダルいので、

gitのpre-commit hookで防ぐことを思いつきました!

もともと私のpre-commit hookは、「AWSのシークレットキーっぽい文字列が入ったらfailすること」を書いていました。

以下のようにシェルスクリプトで書いていました。

```sh
#!/bin/sh
GREP_RESULT=`git diff --cached | grep AKIA`
if [[ -n "${GREP_RESULT}" ]]; then
  echo "\033[31m\]AWS_ACCESS_KEY might be in this index. Please check with git diff --cached"
  echo ${GREP_RESULT}
  exit 1
fi
```

これを、さらに **合成文字の濁点・半濁点が入ったらfailするようにすれば良さそう** です。

最終的には、以下のようにしました。

```ruby
#!/usr/bin/ruby
# frozen_string_literal: true

diff = `git diff --cached`

diff.each_line.grep(/^\+[^\+]/).each do |d|
  if /\bAKIA/ =~ d
    puts 'AWS_ACCESS_KEY might be in this index. Please check with git diff --cached'
    puts d
    exit 1
  end

  # see https://codepoints.net/U+3099
  # see https://codepoints.net/U+309A
  #
  dakuten_handakuten = /[\u{3099}\u{309A}]/

  next unless dakuten_handakuten =~ d
  puts 'dakuten or handakuten might be in this index. Please check with git diff --cached'
  puts d
  exit 1
end
```

えへへ。rubyで書き直しました。もともとmacでしかgit commitしないし、これで十分っぽい気がします。


### ✎まとめ

合成文字の濁点問題に対し、gitのpre-commit hookを使うことにより、現実的でラクな対応をしました。


<script type="text/javascript" src="/js/prism.js" async></script>
