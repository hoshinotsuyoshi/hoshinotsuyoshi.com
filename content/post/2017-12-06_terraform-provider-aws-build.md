+++
date = "2017-12-07T00:02:51+09:00"
draft = false
title = "terraform-provider-awsを改造してbuildして手元で使う"
slug = "terraform-provider-aws-build"
tags = ["terraform","aws","golang"]
image = "images/santa_201612.jpg"

+++


今年もre:Inventすごかったですね。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="https://reinvent.awsevents.com/">AWS re:Invent 2017</a></h4><p>At AWS re:Invent 2017, connect with peers and cloud experts, collaborate at our bootcamps, and learn how AWS can improve productivity, security and performance.</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

さて、「噂の新機能を試したいけど、**terraform-provider-awsにまだアノ機能が無いよ（●｀ε´●）!!!!** 」 て時があると思います。

そこで、[terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws) を改造し、buildして手元で使ってみました。

そのときの手順です。

<!--more-->

まずお手元に [terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws) をご用意ください。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/terraform-providers/terraform-provider-aws">terraform-providers/terraform-provider-aws</a></h4><p>terraform-provider-aws - Terraform AWS provider</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

## 手順

### 1. 公式のbuild方法に従いbuildする

make build せい、と書いてあるので、make buildすれば良いです。

```sh
$ make build
==> Checking that code complies with gofmt requirements...
go install
```

<br>


### 2. 出来上がったバイナリを~/.terraform.d/pluginsの下に置く

私の場合は以下のようにコピーしたら読み込んでくれました。

```sh
$ cp $GOPATH/bin/terraform-provider-aws ~/.terraform.d/plugins
```

コピーした後に、利用したいterraformプロジェクトの中で `$ terraform init` する必要があります。

【追記】
このとき `.terraform/plugins/darwin_amd64/` の下に既存のpluginファイルがある場合は、それを消す必要がありました。


<br>

### 3.以上です...!!

以上でpluginが読み込まれると思います。

今思ったのですが、これawsのpluginに限った話じゃないかもしれません 🙊

<br>

## 小ネタ

ちなみに、本当に使われてるかどうかがわからなくなってしまった場合は、

lock.jsonというファイルの中身に、pluginバイナリの**SHA256ダイジェストの値が入っている**ので、それを見ると良いっぽいです! 😊

```sh
$ cat .terraform/plugins/darwin_amd64/lock.json
{
  "aws": "b983c8dba51a06bf55f991c6e53342eb1f83c0b96495a3e6a60da25595f09de1",
  "template": "a7a55a3db915e673d43d09ca92b609481f90cdd19520cbd47633002e58fc2d02"
}%

$ shasum -a 256 ~/.terraform.d/plugins/terraform-provider-aws
b983c8dba51a06bf55f991c6e53342eb1f83c0b96495a3e6a60da25595f09de1
```

<br>
<br>

## ✎動作環境

```sh
$ go version
go version go1.9.2 darwin/amd64
$ terraform version
Terraform v0.11.0
```

<br>
<br>

## ✎まとめ

Go〜
<script type="text/javascript" src="/js/prism.js" async></script>
