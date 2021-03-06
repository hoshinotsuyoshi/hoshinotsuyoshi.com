+++
date = "2018-06-10T12:37:09+09:00"
draft = false
title = "RubyKaigi、shopifyのテストの話が良かった"
slug = "ruby_kaigi_2018_shopify"
tags = ["ruby","rubykaigi","shopify","test"]
image = "images/masamune.JPG"

+++

今年のRubyKaigi、色々良かったんだけど、shopifyの[Scaling Teams using Tests for Productivity and Education](https://rubykaigi.org/2018/presentations/jules2689.html) ([スライドはこちら](https://jnadeau.ca/presentations/rubykaigi2018/))というセッションが、とても良かった。

あまり取り上げている人が多くなさそうなので、書く。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-branding="0" data-card-image="http://rubykaigi.org/2018/images/og_image.png" data-card-type="article"><h4><a href="https://rubykaigi.org/2018/presentations/jules2689.html">RubyKaigi 2018, 5/31...6/2, Sendai, Miyagi, Japan #rubykaigi</a></h4><p>RubyKaigi 2018, 5/31...6/2, Sendai, Miyagi, Japan</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

主観的に抜粋し、また、自分の感想を書いてみようと思う。

<!--more-->

## Cognitive Overload(認知の過負荷)とは

開発者は色々な約束事を覚えなければならない。

* あのgemは使うな! とか、
* 波括弧の前後にスペースを入れろ、とか
* ヘルパーを全テストファイルに入れろ、とか
* ....

> <img alt="presen" src="/images/shopify-10.png" width=600>

いっぺんに言われても覚えられない😇(=認知の過負荷状態)し、

誰もが間違えるものだ😇。

しかし、自動化されたテストで検出✅することはできるはず

> <img alt="presen" src="/images/shopify-15.png" width=600>

## 自動化されたテストで検出✅

テストで検出、とはどういうことか。

#### 例1

命名規則と合っていない名前のテストファイル(例: `*_task.rb`に対しての`*_task_test.rb`)をチェックする

> <img alt="presen" src="/images/shopify-18.png" width=600>

> <img alt="presen" src="/images/shopify-19.png" width=600>

----

#### 例2

`$LOAD_PATH`に、想定とは別の余分なパスが含まれていないかチェックする。

(余分なパスが含まれていると、パフォーマンスに影響してしまうため。)

> <img alt="presen" src="/images/shopify-22.png" width=600>

> <img alt="presen" src="/images/shopify-23.png" width=600>


----

つまり機能そのものではなく**コードベースに対してもユニットテストを書く**ようにする。

また、「なぜ」テストが落ちるのか、「どう治せばいいのか」をテストに書くようにしている。

こうすることで、**まずいコードを書いてしまったときに、ユニットテストがfailすることで、その場で、最小限の情報で、開発者が気づける(=JIT education、と呼んでいる)**ようになる。

もちろんCIで自動テストを回している前提、の話。

これとは別にスタイルまつわることについては、rubocopを利用している。

----

## そういうテストは、いつ書くべきか?

こう考えるといいらしい:

他の開発者に、**何か覚えてもらいたい**ことがあるとき、

* 他の開発者はそれを、いつも覚えておく必要がある?
  * -> yes
      * **テストを書くべきだ。なぜなら他にも覚えるべきことが多いので、覚えてもらえないからだ。**
  * -> no
      * **テストを書くべきだ。なぜならいつも使うものではないので、覚えてもらえないからだ。**

ということになる。

つまりいずれの場合も、覚えてもらいたいことがあるときはそのテストを書くべき、という結論になる。

> <img alt="presen" src="/images/shopify-45.png" width=600>

…ここまでは抜粋。だいぶ私の主観も入ってるけど。

<br>

----

# 考察

この話を聞き、私はおおむね肯定的に感じた。

ここからは私の意見と雑感。

<br>

## 雑感: ありそうな反論

1. テスト遅くなるじゃん?
1. 大規模向けのプラクティスでしょう?
1. 開発者のレベルが低いときのプラクティスでしょう?
1. めんどくない?

<br>

## 雑感: ありそうな反論に対してのアンサー

<br>

### 1. テスト遅くなるじゃん?

テストが増えるんで遅くなると思うけど、微々たるものでしょう。

rubyでテスト書いててテストが遅いときって、だいたいシステムテスト・E2Eテストみたいなやつが遅いわけで、今CircleCIとか使っててその問題に対処してる人たちは、既に並列化とかの工夫をしてると思う。

全部1並列だと60分かかるところを5並列で流して12分ぐらいにしてます、みたいなところに、こういうテストが増えるぐらい、大したことない話だと考えている。

よほどテストの書き方が変でない限りは。

<br>

### 2. 大規模向けのプラクティスでしょう?

2名で進めているようなプロジェクトでも、例えば途中に決めたような決めごとをドキュメントに残すのはだるい。

そして新たなメンバーが加わるときに、そのプロジェクトでの決めごとをインプットするのは難しいことです。

ドキュメントがあったとしても、新メンバーもドキュメントを読むのに時間を費やす必要があるでしょうし。

だからたとえ小規模でも、人の出入りが多いプロジェクトなら、このやり方は効果がある気がします。

<br>

### 3. 開発者のレベルが低いときのプラクティスでしょう?

弘法も筆の誤りですし、スキルというより「覚えていられない」というのがモチベーションなので、レベルの高低はあまり関係ない気がする。

自信ないけど。

<br>


### 4. めんどくない?

それな。。 

PRのレビューで何度も同じことを口を酸っぱくして言ってるな、、みたいな経験があるひとには、効くと思う。。

<br>


## 雑感: その他のツール

ところで、いちいち自作スクリプトを作らなくても、こういうことをやるツールがrubocopの他にもあるかもしれないので、探すと良いかもしれない。

* 例えば[querly gem](https://github.com/soutaro/querly)は、プロジェクト固有の特定のNGパターンをyamlで設定できる。
* 例えば、rubocopのプラグインを探す。
  * 例: [rubocop-hq/rubocop-rspec](https://github.com/rubocop-hq/rubocop-rspec)は、rubocop本体にはない、rspecのスタイルの調整ができる

<br>

## 雑感: 決して同僚を信頼していないわけではない

しかし、いきなりこういうテストを導入するのは、なんだか、同僚を信頼していないやつだ、みたいに捉えられてしまう恐れもあるかもしれない。(特にプロジェクトに参画してから間もない、ときなど!)

これについては、どうすればいいんだろう。

気づいたベースで小さいPRを徐々に出していく、しか無いんだろう。

しかしまあ、いまの仕事で特にこういうチェックをしたい!ということは、特に今は思いつかない。(思いついたら書くかもしれない。)

ちなみに前職で、(今思えば)このやり方に近いテストを1個見たことがあるんだが、確かにそのテストは便利だった。

<br>

## まとめ

* rubyにおいて、「間違えずに書く」なんてのは人間には難しすぎるんじゃないかと思う😇
* つまり迷ったらテストを書いてCIに頼ったほうがいい😇
* テストが遅くなったとしても、大抵はお金で解決すると良い。もう既にE2Eテストで十分遅くなっているはずだし。
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180604-1" %}}
