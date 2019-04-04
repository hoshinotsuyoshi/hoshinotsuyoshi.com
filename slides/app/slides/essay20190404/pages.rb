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
      children << p(nil, "スライドのはじまり")
  end
end
end

class Gibier::Page2 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, code(nil, "s")," を押すとタイマーが動きます")
  end
end
end

class Gibier::Page3 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "注: 投稿内容は私個人の意見であり、所属企業・部門見解を代表するものではありません。")
  end
end
end

class Gibier::Page4 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "今日の表参道.rbは「テーマフリー」")
  end
end
end

class Gibier::Page5 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/theme_free.png"}, "")))
  end
end
end

class Gibier::Page6 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "いやー大変でしたね")
  end
end
end

class Gibier::Page7 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "railsdmおつかれさまでした")
  end
end
end

class Gibier::Page8 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "当日スタッフやりました")
  end
end
end

class Gibier::Page9 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "5時起き(含む 子どもの準備とか)")
  end
end
end

class Gibier::Page10 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "23時寝")
  end
end
end

class Gibier::Page11 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "でも楽しかった")
  end
end
end

class Gibier::Page12 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "発表者・参加者の皆さん、ありがとう")
  end
end
end

class Gibier::Page13 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "序文終わり")
  end
end
end

class Gibier::Page14 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "今日のLTタイトル")
  end
end
end

class Gibier::Page15 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "3月とrailsdmと○○と俺")
  end
end
end

class Gibier::Page16 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "○○に入るもの")
  end
end
end

class Gibier::Page17 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "CVE-2019-5418")
  end
end
end

class Gibier::Page18 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "次がまとめのスライドです")
  end
end
end

class Gibier::Page19 < Gibier::PageBase
def header
  h2(nil, "まとめ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "多重防御重要"),
                    li(nil, "Google GroupのRuby on Rails: Security購読すると良いかも"),
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "railsは4.2以上にしとくと良い")
      )
  end
end
end

class Gibier::Page20 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "おまけ エッセイ")
  end
end
end

class Gibier::Page21 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "注: フィクションです")
  end
end
end

class Gibier::Page22 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "3月14日(木)")
  end
end
end

class Gibier::Page23 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "rails security patch")
      children << p(nil, a({href:"https://weblog.rubyonrails.org/2019/3/13/Rails-4-2-5-1-5-1-6-2-have-been-released/", target:"_brank"}, "https://weblog.rubyonrails.org/2019/3/13/Rails-4-2-5-1-5-1-6-2-have-been-released/"))
  end
end
end

class Gibier::Page24 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/security_patch.png"}, "")))
  end
end
end

class Gibier::Page25 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "redhatのcveのページも見てみる")
      children << p(nil, a({href:"https://access.redhat.com/security/cve/cve-2019-5418", target:"_brank"}, "https://access.redhat.com/security/cve/cve-2019-5418"))
  end
end
end

class Gibier::Page26 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/redhat.png"}, "")))
  end
end
end

class Gibier::Page27 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "軽く読んで適用")
  end
end
end

class Gibier::Page28 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails01.jpg"}, "")))
  end
end
end

class Gibier::Page29 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails02.jpg"}, "")))
  end
end
end

class Gibier::Page30 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 完")
  end
end
end

class Gibier::Page31 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " のはずが")
  end
end
end

class Gibier::Page32 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " レールズの会社なら、複数あったりするじゃないですか")
  end
end
end

class Gibier::Page33 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 他にもレールズアプリが。")
  end
end
end

class Gibier::Page34 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "3月21日(木・祝) 夜")
  end
end
end

class Gibier::Page35 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (ざわつきを感じ始める)")
  end
end
end

class Gibier::Page36 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (PoCとか読み始める)")
  end
end
end

class Gibier::Page37 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (気づいて)うおー！！！！")
  end
end
end

class Gibier::Page38 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あかんやん")
  end
end
end

class Gibier::Page39 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (社内の)あのアプリ影響あるやん")
  end
end
end

class Gibier::Page40 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " あのアプリ = レールズのバージョンが...")
  end
end
end

class Gibier::Page41 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " メンテポリシーのおさらい")
  end
end
end

class Gibier::Page42 < Gibier::PageBase
def header
  h2(nil, "Maintenance Policy for Ruby on Rails")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/guide01.png"}, "")))
  end
end
end

class Gibier::Page43 < Gibier::PageBase
def header
  h2(nil, "Maintenance Policy for Ruby on Rails")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/guide02.png"}, "")))
  end
end
end

class Gibier::Page44 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "駆けめぐる思い")
  end
end
end

class Gibier::Page45 < Gibier::PageBase
def header
  h2(nil, "「これって何ができるんだっけ?」")
end

def content
  [].tap do |children|
  end
end
end

class Gibier::Page46 < Gibier::PageBase
def header
  h2(nil, "「これって何ができるんだっけ?」")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "(状況によっては)なにもできない"),
                    li(nil, "(状況によっては)環境変数上の秘密情報が見れる"),
                    li(nil, "(状況によっては)リモートコード実行")
      )
  end
end
end

class Gibier::Page47 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (手元で)攻撃っぽいことをしてみた -> 再現した 😇")
  end
end
end

class Gibier::Page48 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "情報を元に...")
  end
end
end

class Gibier::Page49 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/google.jpg"}, "")))
  end
end
end

class Gibier::Page50 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "注: イメージです")
  end
end
end

class Gibier::Page51 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/diff.jpg"}, "")))
  end
end
end

class Gibier::Page52 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (手元で)治せた!! 😇")
  end
end
end

class Gibier::Page53 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 悩む")
  end
end
end

class Gibier::Page54 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 休みの日の夜だけどPR出すか...(明日railsdmだし)")
  end
end
end

class Gibier::Page55 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails03.jpg"}, "")))
  end
end
end

class Gibier::Page56 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 出した")
  end
end
end

class Gibier::Page57 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails06.jpg"}, "")))
  end
end
end

class Gibier::Page58 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails07-1.jpg"}, "")))
  end
end
end

class Gibier::Page59 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rails07.jpg"}, "")))
  end
end
end

class Gibier::Page60 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 優しい人々、、、、！！！！！")
  end
end
end

class Gibier::Page61 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " (本番に)適用する？")
  end
end
end

class Gibier::Page62 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 悩む。夜だし。。")
  end
end
end

class Gibier::Page63 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 適用した。")
  end
end
end

class Gibier::Page64 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " わーい🙌")
  end
end
end

class Gibier::Page65 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, " 精神安定してrailsdmを迎えることが出来た")
  end
end
end

class Gibier::Page66 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "3月23日(土) railsdm 2日目")
  end
end
end

class Gibier::Page67 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "ジェレミーさんのkeynoteで触れられた")
  end
end
end

class Gibier::Page68 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/jeremy02.png"}, "")))
  end
end
end

class Gibier::Page69 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/jeremy01.png"}, "")))
  end
end
end

class Gibier::Page70 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "ありがとうと思った(こなみかん)")
  end
end
end

class Gibier::Page71 < Gibier::PageBase
def content
  [].tap do |children|
  end
end
end

class Gibier::Page72 < Gibier::PageBase
def header
  h2(nil, "所感1")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, strong(nil, "「これって何ができるんだっけ?」って考える時間の無駄さよ")),
                    li(nil, "(レールズが古いと)面倒ですね"),
                  li(nil, "基本セキュリティパッチが出たらbundle updateしちゃおう"),
                  ul(nil,
                    li(nil, "ノールックはまずいかもだけど")
      ),
                    li(nil, "トリアージ？？？なにそれ")
      )
  end
end
end

class Gibier::Page73 < Gibier::PageBase
def header
  h2(nil, "所感2")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "重要なのは後対応かも"),
                  ul(nil,
                    li(nil, "パスワード、パスフレーズ、シークレットキーの変更とか")
      ),
                    li(nil, "redhatの評価とかは参考程度に")
      )
  end
end
end

class Gibier::Page74 < Gibier::PageBase
def header
  h2(nil, "まとめ(2回目)")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "多重防御重要"),
                    li(nil, "Google GroupのRuby on Rails: Security購読すると良いかも"),
                    li(nil, "railsは4.2以上にしとくと良い"),
                    li(nil, "railsは4.2以上にしとくと良い")
      )
  end
end
end

class Gibier::Page75 < Gibier::PageBase
def content
  [].tap do |children|
      children << p(nil, "スライドの終わり")
  end
end
end

Gibier.page_count = 76
Gibier.title = "(エッセイ)3月とrailsdmと○○と俺"
