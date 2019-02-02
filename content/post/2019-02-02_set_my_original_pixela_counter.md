+++
date = "2019-02-02T14:15:47+09:00"
draft = false
title = "pixelaアクセスカウンターウィジェット自作してこのhugoブログに設置"
slug = "set_my_original_pixela_counter"
tags = ["pixela","hugo"]
image = "images/sougen.jpg"

+++

pixelaアクセスカウンターウィジェットを自作し、このhugoブログの各エントリーに設置してみました。

<!--more-->

[最高のアクセスカウンタソリューションができた](https://blog.a-know.me/entry/2019/01/30/225550)とのことなので、早速設置してみました。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="https://blog.a-know.me/entry/2019/01/30/225550">最高のアクセスカウンターソリューションができたよー！ - えいのうにっき</a></h4><p>すみません釣りタイトルです。最高かどうかはわからないけどでもおもしろいと思うので、ぜひ試してみて欲しいです。 拙作の Pixelaで、比較的かんたんに、サイトのアクセスカウンター（PV数）を GitHub のグラフっぽいやつで設置できるようになったよーというエントリです。 どんなのが設置できるのよ、というと、↓こういうやつが設置できるようになります。 内容的には、 プログラマ ...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

**そのまま貼ってもつまらない**と思ったので、ちょっと(だいぶ?)ひねくれた感じで貼ってみました。

すなわち、**総PV数を数字で表示するようにしてみました**。

もはや草関係ない。

できたのはこんな感じです↓


<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="ja" dir="ltr"><a href="https://t.co/asmvmsiHJS">https://t.co/asmvmsiHJS</a> こういう、はてブボタンのチップ？みたいなやつ勝手に自作してみました！ JSでのスクレイピングなんでDOM変わるとぶっ壊れますが。 いいでしょ！ <a href="https://t.co/Qklp7LwXr0">pic.twitter.com/Qklp7LwXr0</a></p>&mdash; 星野PRO (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1090756891863527426?ref_src=twsrc%5Etfw">January 30, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


このエントリーのフッター([#](#footer-desu))にも貼っております。

### 実装方針

pixelaの、ここの部分をスクレイピングします。

<img alt="pixela" src="/images/pixela-koko.jpg" width=600>

非同期アクセスは[fetchAPI](https://developer.mozilla.org/ja/docs/Web/API/Fetch_API)、スクレイピングは[DOMParser](https://developer.mozilla.org/ja/docs/Web/API/DOMParser)を使いました。

怒られそうな使い方ですが、怒られるまで気にしないことにします。

#### ウィジェット

以下のコード片を作り、layouts/shortcodes配下に保存。今回は `pixela_access_counter.html` という名前にしました。

(JS部分は[この記事](https://sbfl.net/blog/2018/05/26/javascript-streams-api/)をかなり参考にしました。)

```javascript
// pixela_access_counter
{{ $number := .Get 0 }}

// ..(snip)...
// ..svgやstyle要素を貼る...
// ..(snip)...

<script>
(() => {
    const url = 'https://pixe.la/v1/users/{{$number}}.html';
    const decoder = new TextDecoder();
    const parser = new DOMParser();
    let string = '';
    fetch(url).then(response => response.body.getReader())
      .then(reader => {
             const readChunk = ({done, value}) => {
               if(done) {
                 const doc = parser.parseFromString(string,'text/html');
                 document.getElementById('cnt').innerHTML = doc.querySelector('h5.text-success').innerText.match(/Total:\s*(\d+)\s*view/)[1];
                 return;
               }
               string += decoder.decode(value);
               reader.read().then(readChunk);
            };
          reader.read().then(readChunk)
    })
})();
</script>
```

<br/>

#### 各ポストからの呼び出し

こんな感じ。

```javascript
{{ % pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20160302-1" %}}
```

<br/>

なお、エントリーを作るたびに都度pixela側にグラフを作る必要があります。


例:

```javascript
$ curl -X POST https://pixe.la/v1/users/hoshinotsuyoshi/graphs \
-H "X-USER-TOKEN:${PIXELA_TOKEN}" \
-d '{"id":"hblog-20190202-1","name":"hblog-20190202-1","unit":"view(s)","type":"int","color":"shibafu","timezone":"Asia/Tokyo","selfSufficient":"increment"}'
```


<br/>



### ✎まとめ

* 普通に、hugoブログでウィジェット作るやり方について、勉強になった。👽

<script type="text/javascript" src="/js/prism.js" async></script>

<span id ="footer-desu"></span>

---


{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20190202-1" %}}
