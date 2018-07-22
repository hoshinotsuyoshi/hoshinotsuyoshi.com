+++
date = "2018-07-22T11:57:50+09:00"
draft = false
title = "👻このブログのテーマをhugo-theme-casperからhugo-casper-twoに変えた👻"
slug = "change_blog_theme_casper"
tags = ["casper","ghost","hugo","blog"]
image = "images/ghost_cover.jpg"
+++


[vjeantet/hugo-theme-casper](https://github.com/vjeantet/hugo-theme-casper)から[eueung/hugo-casper-two](https://github.com/eueung/hugo-casper-two)

に変えました。

超ナウい感じになりました(当社比)。

<!--more-->

### before

---

<img alt="old casper" src="/images/old_casper.png" width=600>

---

### after

---

<img alt="casper two" src="/images/casper_two.png" width=600>

---

### after・topページ全体

<img alt="casper two" src="/images/top_small.png" width=100>

大きな画像は[こちら](/images/top_full_ipad.png)

## 

---

## prism.jsの非同期読み込み

コードのシンタックスハイライトをやるprism.css/prism.jsはcasper側に無いので、自前で何とかしないといけない。

prismについての過去記事は[これ](/post/prismjs_intro/)。

ついでに色も微修正した。

テンプレートに手を入れずに、各記事ページにprism.jsを読み込ませる良い方法がわからない。

各記事ページの.mdファイルに毎度`<script>`タグを書くという荒業をやってみた。

👇こんな感じ

https://github.com/hoshinotsuyoshi/hoshinotsuyoshi.com/commit/c2303abec18261b493156a2e959756dfe5ff7c9c

```ruby
require 'pathname'

s = '<script type="text/javascript" src="/js/prism.js" async></script>'

Pathname('content/post').each_child do |md|
  next unless md.extname == '.md'
  File.open(md, 'a') do |f|
    f.puts s
  end
end
```

ruby便利である。

あとこういうやつのasync属性はやっぱり良さそう。lighthouseの評価も良かった。

<script type="text/javascript" src="/js/prism.js" async></script>
