+++
date = "2017-12-30T02:45:26+09:00"
draft = false
title = "俺がよく打つキー可視化"
slug = "heatmap_keyboard"
tags = ["keyboard","tmux","vim"]
image = "images/keyboard.jpg"

+++

[Keyboard Heatmap](https://www.patrick-wied.at/projects/heatmap-keyboard/)とキーロガー([caseyscarborough/keylogger](https://github.com/caseyscarborough/keylogger))でヒートマップ作ってみたら楽しかった。

結論、こんな感じのデータを得ることができる。

<img alt="slack" src="/images/keyboard.jpg" width=600>

|key|count|
|----|----|
|[left-cmd]|5.3%|
|a|4.9%|
|[return]|4.8%|
|i|4.3%|
|(space)|3.9%|
|e|3.7%|
|[left-ctrl]|3.6%|
|m|3.5%|
|[tab]|3.4%|
|n|3.4%|

<!--more-->

上記のデータは、キーリピートしてると思われる部分を除去している。

キーリピート分もカウントしてみると以下のようになった。

ヴィム使ってそうな感じが垣間見える。

<img alt="slack" src="/images/keyboard_count_keyrepeat.jpg" width=600>

|key|count|
|----|----|
|j|8.8%|
|h|8.5%|
|l|8.1%|
|[left-ctrl]|7.5%|
|k|6.9%|
|[left-cmd]|3.4%|
|[return]|3.3%|
|n|3.0%|
|[del]|2.9%|
|a|2.7%|


# これを作るための準備

### キーロガー

OSX対応のやつ、[caseyscarborough/keylogger](https://github.com/caseyscarborough/keylogger)を利用した。

`$ make` して `$ sudo ./keylogger` すると `/var/log/keystroke.log` にじゃんじゃんログが溜まっていく。

### ヒートマップ

[Keyboard Heatmap](https://www.patrick-wied.at/projects/heatmap-keyboard/) に貼れば良い。

ただしそのままだとctrl、⌘、shiftなどが動いてくれない。

JSを直す必要がある。

[このJS](https://www.patrick-wied.at/projects/heatmap-keyboard/keyboard-layouts.js)に以下のように手を加える。
割り当ててる平仮名とかは適当。。

```diff
--- a/keyboard-layouts.js
+++ b/keyboard-layouts.js
@@ -2,6 +2,19 @@ app.LAYOUTS = {
     QWERTY: {
         "~": [35, 120, 70, 275],
         "`": [35, 120],
+        "コ": [50, 225], // ctrl
+        "左": [202, 330], //左command
+        "リ": [740, 225], //リターン
+        "右": [536, 330], //左command
+        "タ": [50, 174], //タブ
+        "デ": [740, 120], //デリート
+        "ひ": [50, 275], // 左Shift
+        "み": [740, 275], // 右Shift
+        "ス": [374, 330], // スペース
+        "↑": [710, 320], // ↑
+        "↓": [710, 350], // ↓
+        "←": [670, 350], // ←
+        "→": [750, 350], // →
         "1": [90, 120],
         "!": [90, 120, 70, 275],
         "2": [144, 120],
```

さらにこれに対応してローカルのkeystroke.logをパースするためのコード。

```ruby
# /var/log/keystroke.logの中身を読み
# https://www.patrick-wied.at/projects/heatmap-keyboard/に貼れるように整形する

require 'pp'

# trueにするとキーリピート分もカウントする
COUNT_KEY_REPEAT = true

# trueにするとサマリを表示する
# falseにすると10000文字分サンプリングする
SUMMARY = false

convert = {
  "[left-cmd]"=>"左",
  "[return]"=>"リ",
  "[left-ctrl]"=>"コ",
  "[tab]"=>"タ",
  "[right-cmd]"=>"右",
  "[del]"=>"デ",
  "[left-shift]"=>"ひ",
  "[right-shift]"=>"み",
  "[left]"=>"←",
  "[up]"=>"↑",
  "[right]"=>"→",
  "[down]"=>"↓",
  " "=>"ス"
}

s = File.read('/var/log/keystroke.log')
ss = s[50..-1]
r = /\[[^\[]+?\]/
m = ss.scan(r)
h = Hash.new(0)
memo = nil
m.each do |c|
  h[c] += 1 if (COUNT_KEY_REPEAT || c != memo)
  memo = c
end
sss = ss.gsub(r){ "" }
sss.each_char do |c|
  h[c] += 1 if (COUNT_KEY_REPEAT || c != memo)
  memo = c
end

if SUMMARY
  sum = h.values.sum
  pp h.sort_by{|_k, v| v}.reverse.map{|k, v| [k, sprintf("%#.02g%", v.to_f/sum*100)]}.to_h
else
  new = {}
  h.each do |k, v|
    if convert[k]
      new[convert[k]] = v
    else
      new[k] = v if k.size == 1
    end
  end
  a = []
  new.each do |k, v|
    v.times { a << k }
  end
  puts a.shuffle.sample(10000).join
end
```

この実行結果をtextareaに貼るとヒートマップを得られる。

### ✎まとめ

* キーロガーを使って自分のキーボードのヒートマップを出力してみました。
* こういうの簡単にできるツール、既に別で存在してる気もする。。あれば教えて欲しい。
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20171230-1" %}}
