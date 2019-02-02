+++
date = "2017-12-08T03:32:07+09:00"
draft = false
title = '🎅terraformで理解する、"Fargate"と従来型ECSとの違い🎅'
slug = "terraform-fargate"
tags = ["terraform","fargate","aws","ecs","docker","advent_calender"]
image = "images/pharlap.jpg"

+++

<br>

🎄 このエントリは[AWS Fargate Advent Calendar 2017](https://qiita.com/advent-calendar/2017/aws-fargate)の8日目の記事です 🎄

従来型ECS(EC2/ECS)とFargateの違いについて、

**.tfファイルの差分を見ることで理解を深めよう!!** という試みです。

このエントリでは、以下のような流れで説明していきます。

----

#### step1. terraformでバーーンと**インフラ一式(ECS含む)を立ち上げ**


<img alt="slack" src="/images/step1-ec2ecs.png" width=600>


#### step2. terraformでstep1の状態からバーーンと**Fargateに移行**


<img alt="slack" src="/images/step2-fargate.png" width=600>


#### step3. step1とstep2の.tfファイルの**diffを眺める!👀**

<br>

----


<!--more-->

<br>

## 🙊 この記事執筆時点での事情

<br>

まず、そもそも**terraformはFargateをサポートしているのか？** という大事な話がありますが、

12/8時点で、**masterではサポートしているようです!!🎉**

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-branding="0" data-card-type="article"><h4><a href="https://github.com/terraform-providers/terraform-provider-aws/pull/2483">ECS Fargate Support by apricote · Pull Request #2483 · terraform-providers/terraform-provider-aws</a></h4><p>Depends on #2474 Closes #2471 Hello all, I have never before implemented something in Go, but the features promised by Fargate were just too impressive to wait for. I Implemented most (all?) endpoi...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

しかし、[このコメント](https://github.com/terraform-providers/terraform-provider-aws/pull/2483#issuecomment-349458118)で言われているとおり、**「パブリックIPアドレスの自動付与」というオプションを指定することができず😥**、、、結果として、VPC内でNATゲートウェイを運用したりしない限り、ネットワーク周りで支障をきたすらしいです。

私は最初これに気づかず、docker pullで失敗しまくってハマっていました😢

ということで、なにかしらやっていく必要があります。😊 

<br>

## 💪 自分でビルド!💪

<br>

今回は、**その部分が解消されている↓下記のPR**のバージョンでterraform(-providers-aws)を動かしていくことにします。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-branding="0" data-card-type="article"><h4><a href="https://github.com/terraform-providers/terraform-provider-aws/pull/2559">Feature/fargate support v2 by johnnorton · Pull Request #2559 · terraform-providers/terraform-provider-aws</a></h4><p>The previous merge for ECS Fargate support did not include the ability to ENABLE "Assign Public IP" when creating the ECS Service. From what I can tell, this is an option that only works for servic...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

ちなみに[この時点のコミット](https://github.com/terraform-providers/terraform-provider-aws/commits/36934737ab354734b6b7dee841d3a310df09907c)で試しています。

terraform pluginのビルド方法は[昨日書きました](/post/terraform-provider-aws-build/)ので、どうぞご参考までに。

## step1. terraformでバーーンとインフラ一式(ECS含む)を立ち上げる

今回のterraformの設定ファイルはこちらに上げました↓

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-branding="0" data-card-type="article"><h4><a href="https://github.com/hoshinotsuyoshi/study-fargate">hoshinotsuyoshi/study-fargate</a></h4><p>Contribute to study-fargate development by creating an account on GitHub.</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

[最初](https://github.com/hoshinotsuyoshi/study-fargate/commit/a220c5e7d557f38f54992a3cdfbcb55337c5a4e7)の状態は↓こんな感じ。resource名をそのままファイル名にしています。

```sh
$ tree
.
├── main.tf
└── modules
    └── fastladder
        ├── aws_alb.tf
        ├── aws_alb_listener.tf
        ├── aws_alb_target_group.tf
        ├── aws_autoscaling_group.tf
        ├── aws_cloudwatch_log_group.tf
        ├── aws_db_instance.tf
        ├── aws_db_parameter_group.tf
        ├── aws_db_subnet_group.tf
        ├── aws_ecs_cluster.tf
        ├── aws_ecs_service.tf
        ├── aws_ecs_task_definition.tf
        ├── aws_iam_instance_profile.tf
        ├── aws_iam_role.tf
        ├── aws_iam_role_policy_attachment.tf
        ├── aws_internet_gateway.tf
        ├── aws_launch_configuration.tf
        ├── aws_route_table.tf
        ├── aws_route_table_association.tf
        ├── aws_security_group.tf
        ├── aws_subnet.tf
        ├── aws_vpc.tf
        ├── data.tf
        ├── output.tf
        └── variable.tf

2 directories, 25 files
```

<br>

**各.tfファイルが対応するものを、わかりやすく図の中に書いてみました↓**


<img alt="slack" src="/images/3-ec2ecs.png" width=1200>


terraform applyし、webアプリ(今回は例としてfastladder使いました)が立ち上がることを確認したら、step2に移ります。

<br>

## step2. step1.の状態からバーーンとFargateに移行

[こんな感じの修正](https://github.com/hoshinotsuyoshi/study-fargate/commit/edf7da56868049821e3f97afab34f629af39a4c6)でterraform applyするとFargate化することができ、無事fastladderが動きました! 🎉 (<a href="#footer1">注1.</a>)

以下の3つのファイルがなくなりました。

* modules/fastladder/aws_autoscaling_group.tf
* modules/fastladder/aws_iam_instance_profile.tf
* modules/fastladder/aws_launch_configuration.tf

さっきと同様に.tfに対応するものを図の中に表記するとこんな感じです↓

<img alt="slack" src="/images/4-fargate.png" width=1200>


Fargateなので当然ですが、オートスケーリンググループや起動設定が削除できていることがわかると思います。

ecs-agentやdockerデーモンの管理をAWSにやってもらえて、本当にラクそうですね👼


## step3. step1.とstep2.の.tfファイルのdiffを眺める

では、動かすために何が必要だったのか、少し詳しく見ていきます。

手前味噌なコミット解説で、しかも表面上しかわかっていなくて恐縮なのですが、おつきあいください👼


#### ✎「aws_ecs_task_definition(タスク定義)」に必要だった変更

<br>

```diff
+  cpu                      = 256
+  memory                   = 512
```

これは何をしているかというと、**タスクのCPUの値を256(1CPU=1024に相当)、メモリの量を512MB**にしています。

実はFargateでは、タスクは**予めAWSが決めているメモリ量/CPU量の組み合わせ**にマッチしていないと動いてくれません。

メモリ量/CPU量 の組み合わせは以下のような形で定義されており([公式のFargate](https://aws.amazon.com/jp/blogs/news/aws-fargate/)参照)、
例えば最小にするにはピッタリ0.5GB(=512MB)にする必要があります。

```
CPU (vCPU)	Memory Values (GB)
0.25	0.5, 1, 2
0.5	1, 2, 3, 4
1	Min. 2GB and Max. 8GB, in 1GB increments
2	Min. 4GB and Max. 16GB, in 1GB increments
4	Min. 8GB and Max. 30GB in 1GB increments
```

また、タスク全体だけではなく、コンテナ定義のなかにもmemoryとcpuの設定が必要でした。

#### ✎「aws_ecs_task_definition(タスク定義)」に必要だった変更 2

<br>


```diff
+  requires_compatibilities = ["FARGATE"]
+  network_mode             = "awsvpc"
+  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
```

ここでは3点変更しています。

* `requires_compatibilities`は、Fargateで動かすには 少なくとも`FARGATE`を入れる必要があるので入れました。
* `network_mode`は、Fargateで動かすには "awsvpc" である必要があるので、そう設定しました。
* `network_configuration` ecs-agentとDockerデーモンが引き受けるロールのとのこと。`ecsTaskExecutionRole` という既存のロールを指定しました。

#### ✎「aws_alb_target_group(ALBターゲットグループ)」に必要だった変更

<br>

```diff
+  target_type = "ip"
```

ターゲットグループの `target_type` はデフォルト `EC2` なのですが、Fargateの場合は必ず`ip`にする必要があるようでした。


#### ✎「aws_ecs_service(ECSサービス)」に必要だった変更

<br>

```diff
--- a/terraform/modules/fastladder/aws_ecs_service.tf
+++ b/terraform/modules/fastladder/aws_ecs_service.tf
@@ -2,7 +2,7 @@ resource "aws_ecs_service" "fastladder_rails" {
   cluster                            = "${aws_ecs_cluster.fastladder.id}"
   deployment_minimum_healthy_percent = 50
   desired_count                      = "${var.aws_ecs_service_desired_count_rails}"
-  iam_role                           = "${aws_iam_role.fastladder_ecs.arn}"
+  launch_type                        = "FARGATE"
   name                               = "${var.resource_base_name}_rails"

   load_balancer {
@@ -11,5 +11,19 @@ resource "aws_ecs_service" "fastladder_rails" {
     target_group_arn = "${aws_alb_target_group.fastladder_rails.arn}"
   }

+  network_configuration {
+    subnets = [
+      "${aws_subnet.fastladder_public_a.id}",
+      "${aws_subnet.fastladder_public_c.id}",
+    ]
+
+    security_groups = [
+      "${aws_security_group.fastladder_alb.id}",
+      "${aws_security_group.fastladder_web.id}",
+    ]
+
+    assign_public_ip = "ENABLED"
+  }
+
```

ここでは3点変更しています。

* Fargateで動くサービスであることを明記する必要があるようで、`launch_type` なるものに「FARGATE」を指定しました。
* Fargateで動くサービスの場合、サービスにIAM RoleをつけることはできないようなのでIAM Roleの設定を削除しました。
* `network_configuration` というものを書く必要があります。
  * (AutoScalingGroupがなくなったので、そこでやっていたネットワーク設定がここに移ってきた、というように解釈しました。)


#### 以上です

...主な差分は以上です!!

### ✎まとめ

* 表面上の説明だけにとどまりましたが、terraformでFargateに必要なインフラの説明を試みました。
* 今回の.tfファイルの差分は `52 insertions(+), 84 deletions(-)` 程度でした。規模の小さいWebアプリなら、この程度のようです。
* terraformやっていきましょう

#### 脚注

<div id="footer1">1.</div>【余談】実を言うとここでのterraform applyは、そのままでは失敗してしまいます。Fargateとは関係なく[この不具合](https://github.com/terraform-providers/terraform-provider-aws/issues/636#issue-235679014)があるため、のようです。手でリスナーを先に削除すると、terraform applyは成功します。
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20171207-1" %}}
