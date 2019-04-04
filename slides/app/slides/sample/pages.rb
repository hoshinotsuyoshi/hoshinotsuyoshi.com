class Gibier::Page0 < Gibier::PageBase
def header
  h1(nil, "(エッセイ)3月とrailsdmと○○と俺")
end

def content
  [].tap do |children|
      children << p({className:"author"}, "hoshinotsuyoshi")
      children << p({className:"icon"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/hoshinotsuyoshi.jpg"}, "")))
      children << p({className:"duration"}, "5min")
  end
end
end

class Gibier::Page1 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "序文")
  end
end
end

class Gibier::Page2 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "いやー大変でしたね")
  end
end
end

class Gibier::Page3 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "railsdmおつかれさまでした")
  end
end
end

class Gibier::Page4 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "当日スタッフやりました")
  end
end
end

class Gibier::Page5 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "5時起き")
  end
end
end

class Gibier::Page6 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "23時寝")
  end
end
end

class Gibier::Page7 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "でも楽しかった")
  end
end
end

class Gibier::Page8 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "ジェレミーさん")
  end
end
end

class Gibier::Page9 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "デイビッドさん")
  end
end
end

class Gibier::Page10 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "他さん")
  end
end
end

class Gibier::Page11 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "ありがとう")
  end
end
end

class Gibier::Page12 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "序文終わり")
  end
end
end

class Gibier::Page13 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "今日のLTタイトル")
  end
end
end

class Gibier::Page14 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "3月とrailsdmと○○と俺")
  end
end
end

class Gibier::Page15 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "○○に入るもの")
  end
end
end

class Gibier::Page16 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "CVE-2019-5418")
  end
end
end

class Gibier::Page17 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "次が最後のスライドです")
  end
end
end

class Gibier::Page18 < Gibier::PageBase
def header
  h2(nil, "まとめ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "多重防御重要"),
                    li(nil, "RSS購読すると良いかも"),
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "railsは4.2以上にしとくと良い")
      )
  end
end
end

class Gibier::Page19 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "おまけ(エッセイ)")
  end
end
end

class Gibier::Page20 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "フィクションです")
  end
end
end

class Gibier::Page21 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "MITライセンスです")
  end
end
end

class Gibier::Page22 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "3月14日")
  end
end
end

class Gibier::Page23 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "rails security patch")
  end
end
end

class Gibier::Page24 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "軽く読んで適用")
  end
end
end

class Gibier::Page25 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "redhatのページ見る")
  end
end
end

class Gibier::Page26 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 完")
  end
end
end

class Gibier::Page27 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " のはずが")
  end
end
end

class Gibier::Page28 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あったりするじゃないですか")
  end
end
end

class Gibier::Page29 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 他にもレールズアプリが。")
  end
end
end

class Gibier::Page30 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 3月21日")
  end
end
end

class Gibier::Page31 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " うおー！！！！")
  end
end
end

class Gibier::Page32 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あかんやん")
  end
end
end

class Gibier::Page33 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あのアプリ影響あるやん")
  end
end
end

class Gibier::Page34 < Gibier::PageBase
def header
  h2(nil, "Maintenance Policy for Ruby on Rails")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/guide01.png"}, "")))
  end
end
end

class Gibier::Page35 < Gibier::PageBase
def header
  h2(nil, "Maintenance Policy for Ruby on Rails")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/guide02.png"}, "")))
  end
end
end

class Gibier::Page36 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 悩む。")
  end
end
end

class Gibier::Page37 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 夜中だけど。")
  end
end
end

class Gibier::Page38 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 出すかPR。")
  end
end
end

class Gibier::Page39 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 出す。")
  end
end
end

class Gibier::Page40 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 優しい人々、、、、！！！！！")
  end
end
end

class Gibier::Page41 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あてる？")
  end
end
end

class Gibier::Page42 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 悩む。")
  end
end
end

class Gibier::Page43 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あてた。")
  end
end
end

class Gibier::Page44 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " わーい🙌")
  end
end
end

class Gibier::Page45 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 精神安定した")
  end
end
end

class Gibier::Page46 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 3月23日")
  end
end
end

class Gibier::Page47 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "ジェレミーさんの話で触れられた")
  end
end
end

class Gibier::Page48 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "所感")
  end
end
end

class Gibier::Page49 < Gibier::PageBase
def content
  [].tap do |children|
  end
end
end

class Gibier::Page50 < Gibier::PageBase
def header
  h2(nil, "所感")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "ノールックはまずいけどとりあえずあてとけ、はだいぶスマート"),
                    li(nil, "トリアージ？？？なにそれ"),
                    li(nil, "重要なのは後対応"),
                    li(nil, "パスワード、パスフレーズ、シークレットキーの変更とか"),
                    li(nil, "redhatの評価とか見なくていい")
      )
  end
end
end

class Gibier::Page51 < Gibier::PageBase
def content
  [].tap do |children|
  end
end
end

class Gibier::Page52 < Gibier::PageBase
def header
  h2(nil, "Image")
end

def content
  [].tap do |children|
      children << code({ dangerouslySetInnerHTML: { __html: %q{<div class="highlight"><table style="border-spacing: 0"><tbody><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1</pre></td><td class="code"><pre>%large: ![](guide02.png)
</pre></td></tr></tbody></table>
</div>
} } })
  end
end
end

Gibier.page_count = 53
Gibier.title = "(エッセイ)3月とrailsdmと○○と俺"
