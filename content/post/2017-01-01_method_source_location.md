+++
date = "2017-01-01T15:10:00+09:00"
draft = false
title = "メソッドが定義された場所を調べる"
slug = "method_source_location"
tags = ["ruby","rails"]
image = "images/komainu.jpg"

+++

rubyでは、あるオブジェクトが持つメソッドのソースがどこにあるのかは、自明ではなかったりします。

<!--more-->

includeだのprependだのが使われていると追いにくかったり、、

## pryを使う場合: show-methodを使う

使い方: rails cした後に `show-method [メソッド名]` と入力します。

```ruby
[/Users/cesario/go/src/github.com/hoshinotsuyoshi/s3_explorer]$ bin/rails c
Running via Spring preloader in process 41502
Loading development environment (Rails 5.0.1)
[1] pry(main)> show-method ''.to_json

From: /Users/cesario/go/src/github.com/hoshinotsuyoshi/s3_explorer/vendor/bundle/ruby/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/object/json.rb @line 31:
Owner: ActiveSupport::ToJsonWithActiveSupportEncoder
Visibility: public
Number of lines: 9

def to_json(options = nil)
  if options.is_a?(::JSON::State)
    # Called from JSON.{generate,dump}, forward it to JSON gem's to_json
    super(options)
  else
    # to_json is being invoked directly, use ActiveSupport's encoder
    ActiveSupport::JSON.encode(self, options)
  end
end
```

おすすめです。


## pryを使う場合: RubyのCoreで実装されたメソッドも。

RubyのCoreで実装されたメソッドの場合は、

```ruby
[1] pry(main)> show-method [].select
Error: Cannot locate this method: select. Try `gem-install pry-doc` to get access to Ruby Core documentation.
```

とエラーになってしまうので、`pry-doc` gemを入れます。

Gemfileに`pry-doc`を追加して利用します。

追加した後に実行するとCのコードが吐かれる。

```c
[1] pry(main)> show-method [].select

From: array.c (C Method):
Owner: Array
Visibility: public
Number of lines: 15

static VALUE
rb_ary_select(VALUE ary)
{
    VALUE result;
    long i;

    RETURN_SIZED_ENUMERATOR(ary, 0, 0, ary_enum_length);
    result = rb_ary_new2(RARRAY_LEN(ary));
    for (i = 0; i < RARRAY_LEN(ary); i++) {
        if (RTEST(rb_yield(RARRAY_AREF(ary, i)))) {
            rb_ary_push(result, rb_ary_elt(ary, i));
        }
    }
    return result;
}
```

## pryを使わない場合: Method#source_locationを使う

rubyにはメソッドをオブジェクト化したクラス `Method` クラスがあります。

.method(:メソッド名)でメソッドが取り出せます。

Methodクラスには source_locationというメソッドがあるので、これで該当ファイル・行数を表示することができます。

```ruby
[/Users/cesario/go/src/github.com/hoshinotsuyoshi/s3_explorer]$ bin/rails c
Running via Spring preloader in process 43885
Loading development environment (Rails 5.0.1)
[1] pry(main)> ''.method(:to_json)
=> #<Method: String(ActiveSupport::ToJsonWithActiveSupportEncoder)#to_json>
[2] pry(main)> ''.method(:to_json).source_location
=> ["/Users/cesario/go/src/github.com/hoshinotsuyoshi/s3_explorer/vendor/bundle/ruby/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/object/json.rb", 31]
```

余談ですが、Methodクラスにはおもしろメソッドがいっぱいあって楽しいです。

* Method#parameters
    * Method オブジェクトの引数の情報を返します。
* Method#unbind
    * self のレシーバとの関連を取り除いた UnboundMethod オブ ジェクトを生成して返します。
* Method#super_method
    * super を実行した際に実行されるメソッドを Method オブジェ クトにして返します。
* Method#arity
    * メソッドが受け付ける引数の数を返します。可変長の場合は負の値が返る。
* Method#curry
    * self を元にカリー化した Proc を返します。
* Method#owner
    * このメソッドが定義されている class か module を返します。
* Method#receiver
    * このメソッドオブジェクトのレシーバを返します。

## 参考

* [Source browsing · pry_pry Wiki](https://github.com/pry/pry/wiki/Source-browsing#Show_method)
* [instance method Method#source_location (Ruby 2.4.0)](https://docs.ruby-lang.org/ja/latest/method/Method/i/source_location.html)

## まとめ

pry全然使いこなせていないので、使っていきたいですね
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20170101-1" %}}
