+++
date = "2024-01-11T23:38:36+09:00"
draft = false
title = "rails7.1使うなら`config.active_support.message_serializer` は `:json` か `:message_pack` でよさそう"
slug = "rails_serialization"
tags = ["ruby","rails"]
image = "defimg/1.jpg"
+++

TL;DR

* rails7.0まではActiveStorageのBlobのkeyなどをクライアントとやり取りする際のメッセージのシリアライズに、(自分で差し替えない限り) `Marshal` が使われていました。
* rails7.1では`config.active_support.message_serializer=`が設定可能になりました。
  * rails7.1で新規でwebアプリを作る場合、marshalを使う場面は基本ないと考えられるため、この設定値は `:json` か `:message_pack` でよさそうに思いました。

<!--more-->

### `config.active_support.message_serializer` とは

`config.active_support.message_serializer` は、メッセージのシリアライズ(ActiveStorageのBlobのkeyなどをクライアントとやり取りする際、およびActiveRecordの一部機能generates_token_forとか)に、デフォルトのシリアライザーを定義することができます。

これはrails7.0にはありませんでした。rails7.1からです。

指定できるのは5種類(`:marshal`, `:json`, `:json_allow_marshal`, `:message_pack`, `:message_pack_allow_marshal`)のようです。

それぞれ、以下のようなロジックでシリアライズ・デシリアライズ・デシリアライズできなかったときのフォールバックが定義されています。

出典： https://guides.rubyonrails.org/v7.1/configuring.html#config-active-support-message-serializer

<table role="table">
<thead>
<tr>
<th>Serializer</th>
<th>Serialize and deserialize</th>
<th>Fallback deserialize</th>
</tr>
</thead>
<tbody>
<tr>
<td>:marshal</td>
<td>Marshal</td>
<td>ActiveSupport::JSON, ActiveSupport::MessagePack</td>
</tr>
<tr>
<td>:json</td>
<td>ActiveSupport::JSON</td>
<td>ActiveSupport::MessagePack</td>
</tr>
<tr>
<td>:json_allow_marshal</td>
<td>ActiveSupport::JSON</td>
<td>ActiveSupport::MessagePack, Marshal</td>
</tr>
<tr>
<td>:message_pack</td>
<td>ActiveSupport::MessagePack</td>
<td>ActiveSupport::JSON</td>
</tr>
<tr>
<td>:message_pack_allow_marshal</td>
<td>ActiveSupport::MessagePack</td>
<td>ActiveSupport::JSON, Marshal</td>
</tr>
</tbody>
</table>

なお、デフォルト(指定しなかったとき)は `:json_allow_marshal` になるようです。


<br>

### デシリアライズに `Marshal` は使わなくてよさそう

関連のrailsのPRをいくつか見てみると、「将来の署名秘密の漏洩がデシリアライズ攻撃のアタックベクターにならないようにする」というような意図のものがありました( https://github.com/rails/rails/pull/42843 )。

rails7.1ではデフォルトは `:json_allow_marshal` になっていますが、 rails7.2ではデフォルトが `:json` になることも可能? なようです。 ( https://github.com/rails/rails/issues/48118#issuecomment-1535445995 , https://github.com/rails/rails/pull/48170 )

rails7.1で新規でwebアプリを作る場合は、`:json` もしくは `:message_pack` を選んで良いと思いました。

### 動作確認等

`:marshal` にくらべて `:json` や `:message_pack` がどれぐらい遅くなるか確認してみました。

自分の書いた例の範囲では、遅くならず、少し速くなるようでした。(ご利用は自己責任で..)

省略しない全容等は https://github.com/hoshinotsuyoshi/study_rails_7_1_serialization/blob/main/bench.rb に置きました

```ruby
# frozen_string_literal: true
require 'benchmark/ips'

marshal_encoded_key = "..." # 省略
# Marshal.load(Base64.decode64(marshal_encoded_key))
# => {"_rails"=>
#   {"data"=>
#     {:key=>"ar9inp6c5f9064jbooi0xt753829",
#      :disposition=>"attachment; filename=\"Gemfile\"; filename*=UTF-8''Gemfile",
#      :content_type=>"application/octet-stream",
#      :service_name=>:local},
#    "exp"=>"2025-01-03T08:25:57.300Z",
#    "pur"=>"blob_key"}}

message_pack_encoded_key = "..." # 省略
json_encoded_key = "..." # 省略

secret = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base, iterations: 1000).generate_key('ActiveStorage')

message_pack_verifier = ActiveSupport::MessageVerifier.new(secret, serializer: ActiveSupport::Messages::SerializerWithFallback::MessagePackWithFallback)
marshal_verifier      = ActiveSupport::MessageVerifier.new(secret, serializer: Marshal)
json_verifier         = ActiveSupport::MessageVerifier.new(secret, serializer: JSON)

Benchmark.ips do |x|
  x.report("message_pack") { message_pack_verifier.verify(message_pack_encoded_key, purpose: 'blob_key') }
  x.report("marshal")      {      marshal_verifier.verify(marshal_encoded_key,      purpose: 'blob_key') }
  x.report("json")         {         json_verifier.verify(json_encoded_key,         purpose: 'blob_key') }
  x.compare!
end

# $ bundle exec rails r bench.rb
# ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [arm64-darwin22]
# Warming up --------------------------------------
#         message_pack     8.424k i/100ms
#              marshal     6.404k i/100ms
#                 json     6.474k i/100ms
# Calculating -------------------------------------
#         message_pack     83.365k (± 2.0%) i/s -    421.200k in   5.054535s
#              marshal     65.144k (± 8.1%) i/s -    326.604k in   5.080721s
#                 json     66.535k (± 1.8%) i/s -    336.648k in   5.061440s
#
# Comparison:
#         message_pack:    83365.3 i/s
#                 json:    66535.3 i/s - 1.25x  slower
#              marshal:    65143.5 i/s - 1.28x  slower
```

### その他メモなど

* https://github.com/rails/rails/pull/39623
  * ActiveStorage使ってる場合のSecret Key Base のローテートについて https://github.com/rails/rails/pull/39623#issuecomment-1251580872
* https://github.com/rails/rails/pull/44179
* https://github.com/rails/rails/pull/47963
* https://github.com/rails/rails/pull/47964
  * message_packのサポート
* https://github.com/rails/rails/pull/48103
* https://github.com/rails/rails/pull/48170
  * デフォルトを `:json` にするのは問題があったみたいで、7.2までに各自やってくれということらしい

以上です!

<script type="text/javascript" src="/js/prism.js" async></script>
