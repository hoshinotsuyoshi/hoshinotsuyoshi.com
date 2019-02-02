+++
date = "2018-03-24T17:25:37+09:00"
draft = false
title = "slack-ruby-botを使ってみる"
slug = "slack_ruby_bot"
tags = ["slack","ruby","bot","ruboty"]

+++

SlackのXMPPゲートウェイが閉じるという話があり、近いうちにruboty-slack gem(現在xmppに依存している)が使えなくなるらしいので、
[slack-ruby-bot](https://github.com/slack-ruby/slack-ruby-bot)を試してみました。

<!--more-->

### Slack の XMPP ゲートウェイ対応終了について

今日時点で、内容はこちら https://my.slack.com/account/gateways で確認できます。以下内容抜粋。

> これまで進化を続ける中で、Slack は、共有チャンネル、スレッドや絵文字リアクションといった IRC / XMPP ゲートウェイでは対応できない機能などのビルドを続けてきました。あらゆるプラットフォームを通じて安全で質の高いエクスペリエンスを提供することが Slack の使命です。そのため、このたび、これらのゲートウェイへの対応を終了することとしました。

> ゲートウェイの対応終了予定は以下のとおりです :

> 2018年3月6日 : 新規作成されたワークスペースでの利用終了

> 2018年4月3日 : ゲートウェイが使用されていないã

> 2018年5月15日 : その他の全てのワークスペースでの利用終了

### ちなみに: ruboty-slack_rtm gemについて

ruboty-slackは使えなくなるので、rubotyを使っている人は、[ruboty-slack_rtm](https://github.com/rosylilly/ruboty-slack_rtm) を試すと良いかもしれません。

私はまだ試していません。

今回はもうひとつの選択肢として、という話なので、rubotyのことは一旦忘れます。

### slack-ruby-bot gemを使ってみる

2d6(サイコロを2個振る)に反応するbotを書いてみました。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-branding="0" data-card-type="article"><h4><a href="https://github.com/hoshinotsuyoshi/dicebot">hoshinotsuyoshi/dicebot</a></h4><p>dicebot - slack-ruby-botの習作</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

```ruby
# dicebot.rb
#
# ボットのクラス
require 'slack-ruby-bot'
require 'dicebot/dice'

class DiceBot < SlackRubyBot::Bot
  command '2d6' do |client, data, _match|
    client.say(text: "#{dice} #{dice}", channel: data.channel)
  end

  command '円周率を教えて!' do |client, data, _match|
    pi = Math::PI
    client.say(text: "#{pi}です", channel: data.channel)
  end
end
```

```ruby
# dicebot/dice.rb
# 
# サイコロを振るメソッドをもつモジュール
class DiceBot < SlackRubyBot::Bot
  module Dice
    private

    def dice
      (rand * 6).to_i + 1
    end
  end

  extend Dice
end
```

次にbotのintegrationを1つ作っておき、トークンを環境変数SLACK_API_TOKENにセットします。

あとは、手元のPCおもむろにで `DiceBot.run` すれば動きます。

#### 様子

<img alt="slack" src="/images/slack_dicebot.png" width=400>

#### その他の動かし方

[rackアプリを書いて動かしたほうが安定する?](https://github.com/slack-ruby/slack-ruby-bot/blob/v0.10.5/TUTORIAL.md)みたいなことが書いてありましたが、試していません。

herokuで動かす時はこのほうが安定するのかな。

### テストについて

[READMEの下のほう](https://github.com/slack-ruby/slack-ruby-bot#rspec-shared-behaviors) にrspecのカスタムマッチャについて書かれています。

説明に従いspec/spec_helper.rbを書くと、

こんな感じで動かすことができました。

```ruby
# vcr, rspec, webmock, rack-test が必要
# require 'slack-ruby-bot/rspec' が必要

describe DiceBot do
  context 'given 2d6' do
    it 'returns 2 dices' do
      expect(message: 'rubybot 2d6')
        .to respond_with_slack_message(/[1-6] [1-6]/)
    end
  end

  context 'given "円周率を教えて"' do
    it 'returns pi' do
      stub_const('Math::PI', 3)
      expect(message: 'rubybot 円周率を教えて!')
        .to respond_with_slack_message(/\A3です\z/)
    end
  end
end
```

カスタムマッチャ('slack-ruby-bot/rspec') については、日本語の記事があまり見つけられませんでした。

githubに公開されているいくつかのbotを参考にしたら一応動きました。

まだそれぞれのクラスの役割がよく分かってないので、本体のコード読んで理解するしか無さそうです。

### ✎まとめ

* bot自体はすぐ動くと思います。
  * 本格利用はしてないのでrackアプリ化が必要なのかどうかはいまひとつわからない。
* なんとなくテストも動きました。
  * カスタムマッチャは使いやすいかどうかはまだわからない。。
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180324-1" %}}
