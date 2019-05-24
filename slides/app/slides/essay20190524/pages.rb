class Gibier::Page0 < Gibier::PageBase
def header
  h1(nil, "vimでrubocopをすっごく速く動かす")
end

def content
  [].tap do |children|
      children << p({className:"author"}, "hoshinotsuyoshi")
      children << p({className:"icon"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/hoshinotsuyoshi.jpg"}, "")))
      children << p({className:"duration"}, "10min")
  end
end
end

class Gibier::Page1 < Gibier::PageBase
def header
  h2(nil, "こんにちは")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/shinchoku.png"}, "")))
  end
end
end

class Gibier::Page2 < Gibier::PageBase
def header
  h2(nil, "アジェンダ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "vimでrubocop動かす"),
                    li(nil, "rubocop-daemonめっちゃ速い"),
                    li(nil, "さらに速くする妄想")
      )
  end
end
end

class Gibier::Page3 < Gibier::PageBase
def header
  h2(nil, "アジェンダ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, b(nil, "vimでrubocop動かす")),
                    li(nil, "rubocop-daemonめっちゃ速い"),
                    li(nil, "さらに速くする妄想")
      )
  end
end
end

class Gibier::Page4 < Gibier::PageBase
def header
  h2(nil, "最初に: rubocopとは")
end

def content
  [].tap do |children|
      children << p(nil, "静的コード解析器であり、Lintツールであり、コードフォーマッタ。")
      children << p(nil, "エディタと連携できる。")
  end
end
end

class Gibier::Page5 < Gibier::PageBase
def header
  h2(nil, "使い方おさらい")
end

def content
  [].tap do |children|
      children << p(nil, code(nil, "rubocop [options] [file1, file2, ...]"))
  end
end
end

class Gibier::Page6 < Gibier::PageBase
def header
  h2(nil, "エディタに関係の深いオプション")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "-a/--auto-correct"),
                  ul(nil,
                    li(nil, "オートコレクト。自動修正できるやつは自動修正する。")
      ),
                  li(nil, "-s/--stdin ",i(nil, "FILE")),
                  ul(nil,
                    li(nil, "標準入力からrubyのコードを受け取る。"),
                    li(nil, "エディタとの連携用。")
      )
      )
  end
end
end

class Gibier::Page7 < Gibier::PageBase
def header
  h2(nil, "余談1: --stdinになんでFILE引数が要るの?")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/stdin-output.png"}, "")))
  end
end
end

class Gibier::Page8 < Gibier::PageBase
def header
  h2(nil, "余談1: --stdinになんでFILE引数が要るの?")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/stdin-output2.jpg"}, "")))
  end
end
end

class Gibier::Page9 < Gibier::PageBase
def header
  h2(nil, "余談2: 他のツールの--stdinオプション")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, code(nil, "eslint(JavaScript)")),
                  ul(nil,
                    li(nil, code(nil, "--stdin")," と ",code(nil, "--stdin-filename ファイル名")," がある")
      ),
                  li(nil, code(nil, "flake8(Python)")),
                  ul(nil,
                    li(nil, code(nil, "--stdin")," と ",code(nil, "--stdin-display-name ファイル名")," がある")
      )
      )
  end
end
end

class Gibier::Page10 < Gibier::PageBase
def header
  h2(nil, "余談3: -aと--stdinを組み合わせると?")
end

def content
  [].tap do |children|
      children << p(nil, "基本的に一緒には使わない。")
      children << p(nil, a({href:"https://github.com/rubocop-hq/rubocop/blob/v0.70.0/lib/rubocop/cli.rb#L330-L340", target:"_brank"}, "https://github.com/rubocop-hq/rubocop/blob/v0.70.0/lib/rubocop/cli.rb#L330-L340"))
  end
end
end

class Gibier::Page11 < Gibier::PageBase
def header
  h2(nil, "余談3: -aと--stdinを組み合わせると?")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/stdin-a.jpg"}, "")))
  end
end
end

class Gibier::Page12 < Gibier::PageBase
def header
  h2(nil, "今日はこういうエディタ環境")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "Neovim"),
                  ul(nil,
                    li(nil, "エディタ")
      ),
                  li(nil, "ALE"),
                  ul(nil,
                    li(nil, "Neovim/Vim8 で動く非同期Lintツール")
      ),
                  li(nil, "rubocop"),
                  ul(nil,
                    li(nil, "0.70.0")
      )
      )
  end
end
end

class Gibier::Page13 < Gibier::PageBase
def header
  h2(nil, "今日のエディタ設定と、裏側で動くオプション")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "ALEのlinter"),
                  ul(nil,
                    li(nil, "バッファに変更があると ",code(nil, "rubocop --stdin")," が走る"),
                    li(nil, "違反行にマークがつく")
      ),
                  li(nil, "ALEのfixer"),
                  ul(nil,
                    li(nil, "保存時に ",code(nil, "rubocop -a")," が走る")
      )
      )
  end
end
end

class Gibier::Page14 < Gibier::PageBase
def header
  h2(nil, "アジェンダ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, del(nil, "vimでrubocop動かす")),
                    li(nil, b(nil, "rubocop-daemonめっちゃ速い")),
                    li(nil, "さらに速くする妄想")
      )
  end
end
end

class Gibier::Page15 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "\"rubocop -a is slow\"")
  end
end
end

class Gibier::Page16 < Gibier::PageBase
def header
  h3(nil, "\"rubocop -a is slow\"")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, a({href:"https://github.com/rubocop-hq/rubocop/issues/6492", target:"_blank"}, "rubocop-hq/rubocop#6492")),
                    li(nil, "(この人もエディタからrubocop呼んでる)"),
                    li(nil, "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　"),
                    li(nil, "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　"),
                    li(nil, "　"),
                    li(nil, "　")
      )
  end
end
end

class Gibier::Page17 < Gibier::PageBase
def header
  h3(nil, "\"rubocop -a is slow\"")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, a({href:"https://github.com/rubocop-hq/rubocop/issues/6492", target:"_blank"}, "rubocop-hq/rubocop#6492")),
                    li(nil, "(この人もエディタからrubocop呼んでる)"),
                    li(nil, "「とある1100行ぐらいの.rbファイル (",a({href:"https://raw.githubusercontent.com/rails/rails/master/actionpack/lib/action_controller/metal/strong_parameters.rb", target:"_blank"}, "strong_parameter.rb"),") で rubocop -a を試した」"),
                    li(nil, "　"),
                    li(nil, "　")
      )
  end
end
end

class Gibier::Page18 < Gibier::PageBase
def header
  h3(nil, "\"rubocop -a is slow\"")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, a({href:"https://github.com/rubocop-hq/rubocop/issues/6492", target:"_blank"}, "rubocop-hq/rubocop#6492")),
                    li(nil, "(この人もエディタからrubocop呼んでる)"),
                    li(nil, "「とある1100行ぐらいの.rbファイル (",a({href:"https://raw.githubusercontent.com/rails/rails/master/actionpack/lib/action_controller/metal/strong_parameters.rb", target:"_blank"}, "strong_parameter.rb"),") で rubocop -a を試した」"),
                    li(nil, "「実行に 1.37secかかる」"),
                    li(nil, "「そのうち",u(nil, "requireに0.66sec"),"かかっている」")
      )
  end
end
end

class Gibier::Page19 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "どういうことか")
  end
end
end

class Gibier::Page20 < Gibier::PageBase
def header
  h1(nil, "exe/rubocopを読む")
end

def content
  [].tap do |children|
  end
end
end

class Gibier::Page21 < Gibier::PageBase
def header
  h1(nil, "exe/rubocopを読む")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/require-run-raw.png"}, "")))
  end
end
end

class Gibier::Page22 < Gibier::PageBase
def header
  h1(nil, "exe/rubocopを読む")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/require-run.jpg"}, "")))
  end
end
end

class Gibier::Page23 < Gibier::PageBase
def header
  h1(nil, "exe/rubocopを読む")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/require-run-066.jpg"}, "")))
  end
end
end

class Gibier::Page24 < Gibier::PageBase
def header
  h1(nil, "exe/rubocopを読む")
end

def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/require-run-0.jpg"}, "")))
  end
end
end

class Gibier::Page25 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "\"rubocop-daemon使うと速いよ\"")
  end
end
end

class Gibier::Page26 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "👀 ",a({href:"github.com/forte/rubocop-daemon", target:"_blank"}, "github.com/forte/rubocop-daemon"))
  end
end
end

class Gibier::Page27 < Gibier::PageBase
def content
  [].tap do |children|
      children << p({className:"big"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rubocop-daemon.png"}, "")))
  end
end
end

class Gibier::Page28 < Gibier::PageBase
def header
  h1(nil, "rubocop-daemonのexec.rb")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rubocop-daemon-exec.png"}, "")))
  end
end
end

class Gibier::Page29 < Gibier::PageBase
def header
  h1(nil, "rubocop-daemonのexec.rb")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rubocop-daemon-exec-mark.jpg"}, "")))
  end
end
end

class Gibier::Page30 < Gibier::PageBase
def header
  h1(nil, "rubocop-daemonのexec.rb")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/rubocop-daemon-exec-mark-2.jpg"}, "")))
  end
end
end

class Gibier::Page31 < Gibier::PageBase
def header
  h1(nil, a({href:"https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper", target:"_blank"}, "rubocop-daemon-wrapper"))
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "rubocop-daemonとnetcatでやりとりするbashスクリプト!"),
                  ul(nil,
                  li(nil, "rubocop-daemonの自動起動"),
                  ul(nil,
                    li(nil, "動いてなかったら動かす")
      ),
                  li(nil, "netcat使うから速い"),
                  ul(nil,
                    li(nil, "netcat使うから速いらしい(くわしくない🙇)")
      )
      ),
                    li(nil, "PATH通ってるところに置いて使う")
      )
  end
end
end

class Gibier::Page32 < Gibier::PageBase
def header
  h1(nil, a({href:"https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper", target:"_blank"}, "rubocop-daemon-wrapper"))
end

def content
  [].tap do |children|
      children << code({ dangerouslySetInnerHTML: { __html: %q{<div class="highlight"><table style="border-spacing: 0"><tbody><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1
2
3</pre></td><td class="code"><pre>curl https://raw.githubusercontent.com/fohte/rubocop-daemon/master/bin/rubocop-daemon-wrapper -o /tmp/rubocop-daemon-wrapper
sudo mv /tmp/rubocop-daemon-wrapper /usr/local/bin/rubocop-daemon-wrapper
sudo chmod +x /usr/local/bin/rubocop-daemon-wrapper
</pre></td></tr></tbody></table>
</div>
} } })
  end
end
end

class Gibier::Page33 < Gibier::PageBase
def header
  h1(nil, "vimタイム")
end

def content
  [].tap do |children|
      children << code({ dangerouslySetInnerHTML: { __html: %q{<div class="highlight"><table style="border-spacing: 0"><tbody><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1
2</pre></td><td class="code"><pre>- let g:ale_ruby_rubocop_executable = 'rubocop'
+ let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper'
</pre></td></tr></tbody></table>
</div>
} } })
  end
end
end

class Gibier::Page34 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "速いですね🎉")
  end
end
end

class Gibier::Page35 < Gibier::PageBase
def header
  h2(nil, "アジェンダ")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, del(nil, "vimでrubocop動かす")),
                    li(nil, del(nil, "rubocop-daemonめっちゃ速い")),
                    li(nil, b(nil, "さらに速くする妄想"))
      )
  end
end
end

class Gibier::Page36 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "さらに速くなる余地を考えてみました!")
  end
end
end

class Gibier::Page37 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "その1: キャッシュを消すのをやめる")
  end
end
end

class Gibier::Page38 < Gibier::PageBase
def header
  h1(nil, "【参考】rubocopのキャッシュとは")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "yamlデフォルトで ",code(nil, "AllCops: UseCache")),
                    li(nil, "オプション ",code(nil, "-C/--cache FLAG")," でオン・オフを指定できる"),
                  li(nil, "ただし ",code(nil, "--stdin")," のときはキャッシュが効かない"),
                  ul(nil,
                    li(nil, "つまり「バッファ変更時(rubocop --stdin)」は効かない"),
                    li(nil, "「save時(rubocop -a)」は効く")
      )
      )
  end
end
end

class Gibier::Page39 < Gibier::PageBase
def header
  h1(nil, "【参考】rubocopのキャッシュとは")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "offence(違反)のキャッシュ。"),
                    li(nil, "1ファイルにつき1個のJSONファイル。"),
                    li(nil, "~/.cache/rubocop_cacheの下に溜まっていく。")
      )
  end
end
end

class Gibier::Page40 < Gibier::PageBase
def header
  h1(nil, "【参考】rubocopのキャッシュとは")
end

def content
  [].tap do |children|
      children << p({className:"large"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/cache-tree.png"}, "")))
  end
end
end

class Gibier::Page41 < Gibier::PageBase
def header
  h1(nil, "【参考】rubocopのキャッシュとは")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "ディレクトリ2層+ファイル名"),
                  ul(nil,
                    li(nil, "$LOADED_FEATURESのファイル全部の中身を連結した文字列のSHA1 digest"),
                    li(nil, "optionのSHA1 digest"),
                    li(nil, "対象ファイルの中身及び設定に由来するデータのSHA1 digest")
      )
      )
  end
end
end

class Gibier::Page42 < Gibier::PageBase
def header
  h1(nil, "キャッシュONのとき")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "キャッシュを探す"),
                    li(nil, "キャッシュがあればその中身を返す"),
                    li(nil, "キャッシュを掃除するべきか調べる"),
                    li(nil, "量が多ければ(デフォルト20000)キャッシュを消す")
      )
  end
end
end

class Gibier::Page43 < Gibier::PageBase
def header
  h1(nil, "キャッシュONのとき")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "キャッシュを探す"),
                    li(nil, "キャッシュがあればその中身を返す"),
                    li(nil, u(nil, "キャッシュを掃除するべきか調べる")," <- 8000個で220ms❗"),
                    li(nil, "量が多ければ(デフォルト20000)キャッシュを消す")
      )
  end
end
end

class Gibier::Page44 < Gibier::PageBase
def header
  h1(nil, "エディタの時はキャッシュを消すのをやめたい!")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "エディタの時は、対象ファイルは1個のはず"),
                    li(nil, "キャッシュが1個増えるだけだから、掃除しなくてもよいのでは?")
      )
      children << p(nil, "=> (エディタの時でもそうでないときでも) 対象ファイルが1個のときは、キャッシュを消さなくてもいいのでは?")
  end
end
end

class Gibier::Page45 < Gibier::PageBase
def header
  h1(nil, "PR出した!!")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "出した! ",a({href:"https://github.com/rubocop-hq/rubocop/pull/7069", target:"_blank"}, "rubocop-hq/rubocop#7069")),
                  ul(nil,
                    li(nil, "昨日(2019/5/23)マージされた! 🎉")
      )
      )
  end
end
end

class Gibier::Page46 < Gibier::PageBase
def content
  [].tap do |children|
      children << h4(nil, "その2: バッファ変更時にもキャッシュが効くようにしたい(願望)")
  end
end
end

class Gibier::Page47 < Gibier::PageBase
def header
  h1(nil, "バッファ変更時にもキャッシュが効くようにする")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "まだPR出してない"),
                  li(nil, "調査中"),
                  ul(nil,
                    li(nil, "何故かこれやるとALEが動かない気がする..."),
                    li(nil, "(何か勘違いしてて)もしかしたらできないかも..."),
                    li(nil, "詳しい人教えてくれ")
      ),
                    li(nil, "実現できれば、strong_parameter.rbで 300msぐらい速くなりそう!")
      )
  end
end
end

class Gibier::Page48 < Gibier::PageBase
def header
  h1(nil, "まとめ1: rubocop-daemonすごい")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "使うだけでほとんどの場合 -0.80sec 🚀 ぐらいいくはず!")
      )
  end
end
end

class Gibier::Page49 < Gibier::PageBase
def header
  h1(nil, "まとめ2: 保存時のパフォーマンスアップ")
end

def content
  [].tap do |children|
      children << ul(nil,
                  li(nil, "キャッシュがたくさんあったときにも、遅くならないようにしたつもり!"),
                  ul(nil,
                    li(nil, "(例：8000個ぐらいのときに) 従来比: -0.22sec 🚀")
      ),
                    li(nil, "0.70.0の次のバージョンで!")
      )
  end
end
end

class Gibier::Page50 < Gibier::PageBase
def header
  h1(nil, "まとめ3: バッファ変更時のパフォーマンスアップ(妄想)")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, "これ妄想"),
                    li(nil, "strong_parameters.rbで -0.3secぐらい速くなりそう!")
      )
  end
end
end

class Gibier::Page51 < Gibier::PageBase
def header
  h2(nil, "自己紹介")
end

def content
  [].tap do |children|
      children << ul(nil,
                    li(nil, a({href:"https://github.com/hoshinotsuyoshi", target:"_blank"}, "github.com/hoshinotsuyoshi")),
                    li(nil, a({href:"https://twitter.com/hoppiestar", target:"_blank"}, "twitter.com/@hoppiestar")),
                    li(nil, "ECサイトをrailsで作ってます")
      )
      children << p({className:"icon"}, p({class:""}, img({src:"#{Gibier.assets_path}/images/hoshinotsuyoshi.jpg"}, "")))
  end
end
end

Gibier.page_count = 52
Gibier.title = "まとめ3: バッファ変更時のパフォーマンスアップ(妄想)"
