# (エッセイ)3月とrailsdmと○○と俺


%duration: 5min

---

スライドのはじまり

---

`s` を押すとタイマーが動きます ([youchan/gibier](https://github.com/youchan/gibier)つかってます)

## 自己紹介

* github.com/hoshinotsuyoshi
* twitter.com/@hoppiestar
* ECサイトをrailsで作ってます

%icon: ![](hoshinotsuyoshi.jpg)

---

注: 投稿内容は私個人の意見であり、所属企業・部門見解を代表するものではありません。

---

今日の表参道.rbは「テーマフリー」

---

%large: ![](theme_free.png)

---

いやー大変でしたね

---

railsdmおつかれさまでした

---

当日スタッフやりました

---

5時起き(含む 子どもの準備とか)

---

23時寝

---

でも楽しかった

---

発表者・参加者の皆さん、ありがとう

---

序文終わり

---

今日のLTタイトル

---

#### 3月とrailsdmと○○と俺

---

○○に入るもの

---

#### CVE-2019-5418

---

次がまとめのスライドです

## まとめ

* railsは4.2以上にしとくと良い
* 多重防御重要
* Google GroupのRuby on Rails: Security購読すると良いかも
* railsは4.2以上にしとくと良い
* railsは4.2以上にしとくと良い

---

おまけ エッセイ

---


注: フィクションです

---

#### 3月14日(木)

---

rails security patch

https://weblog.rubyonrails.org/2019/3/13/Rails-4-2-5-1-5-1-6-2-have-been-released/

---

%large: ![](security_patch.png)

---

redhatのcveのページも見てみる

https://access.redhat.com/security/cve/cve-2019-5418

---

%large: ![](redhat.png)

---

軽く読んで適用

---

%large: ![](rails01.jpg)

---

%large: ![](rails02.jpg)

---

 完

---

 のはずが

---

 レールズの会社なら、複数あったりするじゃないですか

---

 他にもレールズアプリが。

---

#### 3月21日(木・祝) 夜

---

 (ざわつきを感じ始める)

---

 (PoCとか読み始める)

---

 (気づいて)うおー！！！！

---

 あかんやん

---

 (社内の)あのアプリ影響あるやん

---

 あのアプリ = レールズのバージョンが...

---

(レールズのメンテポリシーのおさらい)

---

#### Maintenance Policy for Ruby on Rails

%large: ![](guide01.png)

---

#### Maintenance Policy for Ruby on Rails

%large: ![](guide02.png)

---

#### 駆けめぐる思い

## 「これって何ができるんだっけ?」

## 「これって何ができるんだっけ?」

* (状況によっては)なにもできない
* (状況によっては)環境変数上の秘密情報が見れる
* (状況によっては)リモートコード実行

---

 (手元で)攻撃っぽいことをしてみた -> 再現した 😇

---

情報を元に...

---

%large: ![](google.jpg)

---

注: イメージです

---

%large: ![](diff.jpg)

---


 (手元で)治せた!! 😇

---

 悩む

---

 休みの日の夜だけどPR出すか...(明日railsdmだし)

---

%large: ![](rails03.jpg)

---

 出した

---

%large: ![](rails06.jpg)

---

%large: ![](rails07-1.jpg)

---

%large: ![](rails07.jpg)

---

 優しい人々、、、、！！！！！

---

 (本番に)適用する？

---

 悩む。夜だし。。

---

 適用した。

---

 わーい🙌

---

 精神安定してrailsdmを迎えることが出来た

---

#### 3月23日(土) railsdm 2日目

---

ジェレミーさんのkeynoteで触れられた

---

%large: ![](jeremy02.png)

---

%large: ![](jeremy01.png)

---

ありがとうと思った(こなみかん)

---

## 所感1

* **「これって何ができるんだっけ?」って考える時間の無駄さよ**

## 所感2

* (レールズが古いと)面倒ですね
* 基本セキュリティパッチが出たらbundle updateしちゃおう
    * ノールックはまずいかもだけど
* トリアージ？？？なにそれ

## 所感3

* 重要なのは後対応かも
    * パスワード、パスフレーズ、シークレットキーの変更とか
* redhatの評価とかは参考程度に

## まとめ(2回目)

* railsは4.2以上にしとくと良い
* 多重防御重要
* Google GroupのRuby on Rails: Security購読すると良いかも
* railsは4.2以上にしとくと良い
* railsは4.2以上にしとくと良い

---

スライドの終わり
