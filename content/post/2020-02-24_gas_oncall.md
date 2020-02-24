+++
date = "2020-02-24T15:58:14+09:00"
draft = false
title = "社内ヘルプ担当者をランダムで決めるbotをJS(GAS)で動かしてることとその工夫"
slug = "gas_oncall"
tags = ["javascript","googleappscript"]
image = "images/robot.png"
+++

<!--more-->

現職、社内管理画面とかもろもろのサポートするのに、エンジニアのサポートが必要だったりしてて、

それをバックエンドエンジニア4名で回している。


↓こんな感じ。

------

<img alt="" src="/images/garapiko_circle.jpg" width=600>


問い合わせは全部slackで(当然だが)公開チャンネルでやっている。

ランダムでその日の担当を決めることにより、

* (ローテじゃないことによる)気軽さ、ゆるさ
* それによる属人性の排除

が生まれるような気がしている。

数日連続で指名されてしまうこともあるけど。

このやりかたは、わりと気に入っている。

## bot

私の要件としては

1. ランダム性
2. 1日1回、朝動いてほしい
3. 会社の営業日だけ動いてほしい。祝日判定もほしい(休日にメンションしてほしくない)

ということがあった。

1.と2.はslackの機能だけでできるけど、

3.の機能がほしかったので、自分でGAS用のスクリプトを書いた。

2.の機能はGASの定時実行機能でやればよい。

だいたいこんなようなコード。

わかりやすくコメントを追記した。

```javascript

// 🤖
const main = () => {
  const date = new Date();
  date.setTime(date.getTime() + 1000*60*60*9);
  if (isWeekend(date) || isCompanyHoliday(date) || isJapanHoliday(date)) return false;
  const sample = () => {
    const strings = [
      "今日engineer-helpを担当するバックエンドエンジニアは xxさん <@xxxx>",
      "今日engineer-helpを担当するバックエンドエンジニアは yyさん <@yyyy>",
      "今日engineer-helpを担当するバックエンドエンジニアは zzさん <@zzzz>"
    ];
    return strings[Math.floor(Math.random() * strings.length)];
  }
  const post_data = {
    "text": sample(),
    "channel": "#engineer-help",
    "username": "ガラピコ",
    "icon_emoji" : ":garapiko:",
    "attachments": [
        {
            "fallback": "くじ",
            "color": "#36afff",
            // ここにGASのスクリプトのURLを貼ると他の人も編集できて超絶べんり
            "footer": "改造する場合は  <https://script.google.com/a/smarby.jp/d/xxxxxxxxxxxxxxxxxxxx/edit|🤖こちら🤖>"
        }
    ]
  };
  const url = "https://hooks.slack.com/services/xxxxxxxxxxxxxxxxxxxxxxxxxxxx"; 
  const payload = JSON.stringify(post_data);
  const headers = {"Accept":"application/json"}
  const options = {
    "method":"POST",
    "headers": headers,
    "payload": payload
  };
  UrlFetchApp.fetch(url, options);
  return false;
}

// 土日
const isWeekend = (date) => {
  return(date.getDay() >= 6 || date.getDay() == 0);
}
// 会社の休日。年末年始。
const isCompanyHoliday = (date) => {
  const mm_dd = date.toJSON().slice(5, 10);
  const arr = [
    "12-29",
    "12-30",
    "12-31",
    "01-01",
    "01-02",
    "01-03"
  ];
  return arr.includes(mm_dd);
}
// 日本の祝日。
// https://raw.githubusercontent.com/holiday-jp/holiday_jp-ruby/master/holidays.yml
const isJapanHoliday = (date) => {
  const yy_mm_dd = date.toJSON().slice(0, 10);
  const arr = [
    "2019-11-23",
    "2020-01-01",
    "2020-01-13",
    "2020-02-11",
    "2020-02-23",
    "2020-02-24",
    "2020-03-20",
    "2020-04-29",
    "2020-05-03",
    "2020-05-04",
    "2020-05-05",
    "2020-05-06",
    "2020-07-23",
    "2020-07-24",
    "2020-08-10",
    "2020-09-21",
    "2020-09-22",
    "2020-11-03",
    "2020-11-23",
    "2021-01-01",
    "2021-01-11",
    "2021-02-11",
    "2021-02-23",
    "2021-03-20",
    "2021-04-29",
    //....snip...
  ];
  return arr.includes(yy_mm_dd);
```

## 工夫したポイント

### 自分のスクリプトのURLのリンクを貼っている

「こちら」のところからGASのコードに飛ぶことができる。

<img alt="" src="/images/garapiko_circle_2.jpg" width=600>

「このslack通知、どのGASで送ってるんだっけ？」が発生しなくて良い。

<br>

### V8使ってみた

最近[V8が使える](https://developers.google.com/apps-script/guides/v8-runtime/migration)ようになってて、以下のことを導入して書き直した。

* `const`
* `Array.prototype.includes`
* アロー関数式


### ✎まとめ

* 祝日考慮したコードってめんどいですね。
* GASはトランスパイルしなくてもそこそこ新し目のJS使えるようになった。


<script type="text/javascript" src="/js/prism.js" async></script>
