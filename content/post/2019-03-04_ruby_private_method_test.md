+++
date = "2019-03-04T01:07:55+09:00"
draft = false
title = "privateメソッドのテストについての考え方 #yochiyochirb を読んで 私も知りたい"
slug = "ruby_private_method_test"
tags = ["ruby","rails"]
image = "/defimg/2.jpg"
+++

privateメソッドのテストについての考え方 #yochiyochirb を読んで

<!--more-->

私も知りたい話題なので書きます。

## 与件とサンプルコード

 <blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="http://highwide.hatenablog.com/entry/2019/03/03/220653">privateメソッドのテストについての考え方 #yochiyochirb - No Purpose</a></h4><p>よちよち.rbに久しぶりに参加した。 yochiyochirb.doorkeeper.jp 今日の回はjnchitoさんがゲストとして招かれていて、あれこれ質問できるという会だった。 「昔からよちよち.rbに参加してくれてる人も是非」と言ってもらったので参加させてもらった。 jnchitoさんといえば、今でも RSpecのまとめ記事や Rubyの新しいバージョンのまとめ記事はよく拝見するし、</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

```ruby
module Tasks
  module Hoge
    class Sender
      def self.execute
        data = aggregate_data
        processed_data = process_data(data)
        send_s3(processed_data)
      end
    end
  end
end
```

#### レスポンス

* <a href="https://sinsoku.hatenablog.com/entry/2019/03/03/235030">「privateメソッドのテストについての考え方」を読んで #yochiyochirb - アジャイルSEの憂鬱</a>

## プライベートクラスっぽく書く

最近わりと「優等生ではない」コードが好きです

↓こう書くのが一年後もう一度読んでも読みやすい感じになると思う。

つまり、rubyでも、**気軽にプライベートクラスみたいの** を作っちゃえばいいんじゃないかなと思います。

```ruby
# app/models/tasks/hoge/sender.rb
module Tasks
  module Hoge
    class Sender
      def self.execute
        data = Aggregator.execute
        data = Processor.execute(data)
        S3.execute(data)
      end
    end
  end
end
```

```ruby
# app/models/tasks/hoge/sender/aggregator.rb
module Tasks
  class Hoge::Sender::Aggregator
    def self.execute
      # 処理...
    end
  end
end
```

```ruby
# app/models/tasks/hoge/sender/processer.rb
module Tasks
  class Hoge::Sender::Processor
    def self.execute(data)
      # 処理...
    end
  end
end
```

```ruby
# app/models/tasks/hoge/sender/s3.rb
module Tasks
  class Hoge::Sender::S3
    def self.execute(data)
      # 処理...
    end
  end
end
```

で、**外側のクラスのテストは、もう、こんな感じにしちゃう。**

```ruby
describe Tasks::Hoge::Sender do
  describe '.execute' do
    it 'calls Aggregator.execute, Processor.execute, and S3.execute' do
      aggregated_data = double
      processed_data  = double
      s3_result       = double
      expect(Aggregator).to recieve(:execute) { aggregated_data }
      expect(Processor).to recieve(:execute).with(aggregated_data) { processed_data }
      expect(S3).to recieve(:execute).with(processed_data) { s3_result }
      expect(Tasks::Hoge::Sender.execute).to eq s3_result
    end
  end
end
```

(これはあまり振る舞いのテストになってないから、微妙だと思う人はいるかも。)

(もちろん、Aggregatorとかのテストは書く。そっちは書きやすいはず)

# メリットとか、考えとか

## 前提として私は「関心がある」ことはテストしたい

この例の場合だと、aggregate_data、processed_data、send_s3などの振る舞いは、私は関心がある。

私は振る舞いが変わったらテストで気づきたいと思ってる。

なのでユニットテストを書く。

どの単位でテストを書くのが良いのかは難しいけど、**私は、メンテする人が関心のある単位でテストを書いたほうが、メンテもラクになると思っている。**

## プライベートメソッド化しない理由

まず単純に、Senderのaggregate_data, processed_data, send_s3をプライベート化すると、
テストでObject#sendを使わないといけないのが気持ち悪い。

パブリックメソッドSender.execute経由でプライベートメソッド化した部品の振る舞いを
**「間接的に」テストすることは可能だし、全然書けるんだけど、のちのちに場合分けと組み合わせの量で死ねる** ことがある。

組み合わせの多さはshared_exampleでなんとかなるけど、それでもある程度の読みづらさは残る。

## クラスの名前空間を利用したプライベートクラス宣言

この例で、Tasks::Hoge::Sender::Aggregator.executeはパブリックなんだけど、

Senderクラスの名前空間の中にいるので、見た目の上下関係がスッキリしていて良いと思う。

## .new使わないの?

これはあまり関係ない。やる内容によって使ってもいいと思う。

例えばキャッシュとかをインスタンス変数に入れたくなる+スレッドセーフにする場合には明らかにインスタンスを作るのが良い。

## クラスを増やすとファイルが多くなり、ファイルが多くなると読むのが辛いと思う人がいると思う

rubyって普通に賢く書くとすごく短く書けてしまうので、
どうも人は自分の書いたコードを「大したことは書いてない」と過小評価する癖があると思ってる。

同じことをコンパイル言語で書こうとすることを想像すると良いかも。

この例みたいに十分複雑なことをやっている(と私は思う)場合は、ファイルの数がテストとか含めて10個ぐらい増えても、割と妥当だと思うようになってきました。

一方で**ファイル数が増えることによってエディタで眺めるときに視認性が悪いと感じる人はいるんじゃないかなと思ってる。(私は今はそうは思わない派)**

([記事「プライベートメソッドのユニットテストは書かないもの？ - QA@IT」](https://qa.atmarkit.co.jp/q/2784) は、良記事っぽい記事なんだけど、rubyに特化した話ではないし、あまりファイル数の話は されていなかった)

## まあ

まあ実際、ぶっちゃけそこまでこだわりはないし(おい)、仕事のコードではテストコードも含めて周囲のコードの雰囲気に合わせるようにしている。

<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20190304-1" %}}
