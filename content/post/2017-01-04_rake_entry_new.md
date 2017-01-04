+++
date = "2017-01-04T23:25:39+09:00"
draft = false
title = "このブログの記事の土台を生成するrakeタスクを作った"
slug = "rake_entry_new"
tags = ["hugo","blog","ruby","rake"]
image = "images/blog_mvim.png"

+++

少しでも記事を書くのをラクにする試みです。

<!--more-->

### このブログで記事を書き始めるまでの作業

１. 前の記事をコピーして`content/post/yyyy-mm-dd_slug名.md`の形で保存。

２. このへん↓のメタ情報を編集して

```markdown
+++
date = "2017-01-04T23:21:39+09:00"
draft = false
title = "記事のひな形から記事の土台を生成するrakeタスクを作った"
slug = "rake_entry_new"
tags = ["hugo","blog"]
image = "images/blog_mvim.png"

+++
(...ここから記事本文...)
```

３. 記事本文を書き始める

という流れでした。いろいろとめんどい💦

1と2の作業は、slugさえ決まれば自動的に決まります。
あと、時刻とかも自動的に挿入できそうです。
このへんを自動化してみました。

### 記事のひな形とRakeタスクを作った

#### 記事のひな形

今まで前の記事をコピーしていたので、ひな形は作っていなかったのですが、
今回作りました。こんな形です。

```markdown
+++
date = "<%= (Time.now + 2*60*60).iso8601 %>"
draft = false
title = "テンプレです💪"
slug = "<%= @slug %>"
tags = ["tag1","tag2"]
image = "images/slack_display.png"

+++

見出し文

<!--more-->

### h3

imgタグ例
<img alt="slack" src="/images/slack_sidebar.png" width=400>

### ✎まとめ

* まとめ内容です

```

`Time#iso8601`を使っているのがミソ(死語)です。

ちょうど"2017-01-04T23:21:39+09:00" というフォーマットで出力してくれます💪

ちなみに`Time#iso8601`は、`require 'time'`しないと使えません。

`Time`クラスは、`require 'time'`する場合としない場合で挙動が変わる、珍しいクラスです。知ってたかい！ 詳しくは[こちら](https://docs.ruby-lang.org/ja/latest/library/time.html)。

#### Rakeタスク

`@slug`というインスタンス変数経由でmarkdownにslugを渡します。

```ruby
# Rakefile
namespace :entry do
  desc 'Put a new entry'
  task :new, 'title'
  task :new do |task, args|
    puts
    template = ERB.new(File.read('entry_template.md.erb'))
    @slug = args['title'] || 'slug'
    File.write(
      "./content/post/#{Date.today}_#{@slug}.md",
      template.result
    )
  end
end
```

#### このRakeタスクの使い方

つまり

`$ rake 'entry:new[hoge]'`とやると`content/post/2017-01-04_hoge.md`というファイルが自動生成され、メタ情報のslugにも`hoge`がセットされます💪。

これで記事を書く手間が少し減りました☺

ところで、こういうふうに、 **rakeタスクには引数が渡せるんだよ**。知ってたかい。

`[`がシェル的に解釈されちゃう問題があるのでシングルクオートで括る必要がありますが。

(これがダサいと考える派の人は環境変数使うんだろうなと思います)


### ✎まとめ

rakeタスクに引数、使っていこうな()
