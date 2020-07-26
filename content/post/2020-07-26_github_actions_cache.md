+++
date = "2020-07-26T22:03:36+09:00"
draft = false
title = "GitHub Actionsのキャッシュ"
slug = "github_actions_cache"
tags = ["github","CI"]
image = "images/ferris-wheel-and-ship-705771.jpg"
+++

このエントリーではGitHub Actionsを使ったCI/CDをやる上でのキャッシュ設定について書きます。

<!--more-->

photograph: https://www.pexels.com/photo/ferris-wheel-and-ship-705771/

基本的にCircleCIのキャッシュに似てるのですが、少し違う部分もあります。

CI(主にテスト)とCD(主にdocker push)に分けて書きます。職業柄、Webアプリケーション(というかRailsアプリ)よりの文脈です。


# 前提: GitHub ActionsにはCircleCIのDocker Layer Cacheにあたるやつは無い

ドキュメントの[この辺り](https://docs.github.com/ja/actions/migrating-to-github-actions/migrating-from-circleci-to-github-actions)に書いてあります。

> GitHub Actionsは、CircleCIのDocker Layer Caching（DLC）に相当する機能を持っていません。

ただし、CircleCIの`restore_cache` にあたるやつはあります(後述)。

あと、docker imageをtarで固めてキャッシュするactionも公開されているようです(後述)。


# CIのキャッシュ

## 手動でキャッシュする設定

https://docs.github.com/ja/actions/configuring-and-managing-workflows/caching-dependencies-to-speed-up-workflows のそのままの例ですが、以下のように `uses: actions/cache@...` と書きます。

```yaml
name: Caching with npm

on: push

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Cache node modules
      uses: actions/cache@v2
      env:
        cache-name: cache-node-modules
      with:
        # npm cache files are stored in `~/.npm` on Linux/macOS
        path: ~/.npm
        key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package-lock.json') }}
        restore-keys: |
          ${{ runner.os }}-build-${{ env.cache-name }}-
          ${{ runner.os }}-build-
          ${{ runner.os }}-

    - name: Install Dependencies
      run: npm install

    - name: Build
      run: npm build

    - name: Test
      run: npm test
```

**寄り道✍️:** ちなみにひとつひとつのActionは、CircleCIのorbの用に、内部実装がオープンソースとして公開されています。
例えば `actions/cache` は https://github.com/actions/cache で公開されています。

このActionは、restore-keysで指定した順序でマッチするキャッシュを探し、解凍します。


## CircleCIの `restore_cache` / `save_cache` との違い

CircleCIでは明示的に`npm install`の後のどこかで明示的に`save_cache`を呼ぶ必要がありましたが、GitHubの`actions/cache`の場合、キャッシュのsaveについては最後のpost jobという形で行われます。

post jobというのはworkflowの中の最後の処理にフックするみたいなものです。

以下のyamlの例で言うと

```yaml
name: CI

on: push

jobs:
  container-cache-mode:
    runs-on: ubuntu-latest

    services:
      db:
        image: mysql:5.7.12

    container:
      image: ruby:2.6.6

    steps:
    - uses: actions/checkout@v2

    - name: install middlewares
      run: |
        apt-get ....

    - uses: actions/cache@v2
      with:
        path: vendor/bundle
        key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
        restore-keys: |
          ${{ runner.os }}-gems-

    - name: Setup and RSpec
      run: |
        bundle config set deployment 'true'
        bundle config path vendor/bundle
        bundle install --jobs 9 --retry 3
        bundle exec rails db:create db:migrate spec RAILS_ENV=test
```

この例では 最後のステップは「Setup and RSpec」となっていますが、途中でpost jobを含有しているアクション「actions/checkout@v2」と「actions/cache@v2」を実行しているので、
それぞれ最後にpost jobが実行されます。(以下の画像の赤丸のところ)
「actions/cache@v2」の場合、この段階でキャッシュへのsaveが行われます。

<img alt="cache_save" src="/images/cache_save.png" width=400 >


## RailsアプリのCIでは何をキャッシュするか

Railsアプリでは、キャッシュすると嬉しいものは

* bundlerでインストールする `gems`
  * キャッシュキーは `Gemfile.lock`
* yarnとかnpmでインストールする `node_modules`
  * キャッシュキーは `yarn.lock` または `package-lock.json`

の2点になると思います。

あとは、(私はできてないですが、 )`assets:precompile` の結果をキャッシュするのもいいかもしれません。

こういうやつです⬇️。

[CircleCI 2.0に移行して新機能を活用したらCIの実行時間が半分になった話 - クラウドワークス エンジニアブログ](https://engineer.crowdworks.jp/entry/2017/04/04/202719)

Gitのコミットハッシュの取り回しなどに工夫が要りそうですが。

## fastladderでやってみた

手元のRailsアプリ(fastladder)でやってみた様子を貼っておきます。

* PullRequest https://github.com/hoshinotsuyoshi/fastladder/pull/1
* Actions
  * 1回目 **2m28s** https://github.com/hoshinotsuyoshi/fastladder/runs/911620774
  * 2回目 **1m12s** https://github.com/hoshinotsuyoshi/fastladder/runs/911631844

### workflow file(yaml)

```yaml
name: CI

on: push

jobs:
  container-cache-mode:
    runs-on: ubuntu-latest

    services:
      db:
        image: mysql:5.7.12
        env:
          TZ: Asia/Tokyo
          MYSQL_ROOT_PASSWORD: root

    container:
      image: ruby:2.6.6
      env:
        RAILS_ENV: test
        TZ: Asia/Tokyo

    steps:
    - uses: actions/checkout@v2

    - name: install middlewares
      run: |
        apt-get update -qq
        apt-get install -y nodejs build-essential curl apt-transport-https wget
    - uses: actions/cache@v2
      with:
        path: vendor/bundle
        key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
        restore-keys: |
          ${{ runner.os }}-gems-
    - name: Build and setup
      run: |
        bundle config path vendor/bundle
        bundle install --jobs 9 --retry 3
        bundle exec rake db:create db:migrate
    - run: bundle exec rake spec
```

## CDの場合・docker imageのキャッシュ

CDの場合、buildしたimageをどこかのdocker registry(AWSのECR・Docker Hubとか)にpushする上で、途中のimageのキャッシュが利用できれば便利!!ということになるかと思います。

関連のactionsを2つ見つけたのでそれぞれメモを書いておきます。

## 1. [`whoan/docker-build-with-cache-action`](https://github.com/marketplace/actions/build-docker-images-using-cache)

このアクションは使ったことないのですが、remoteのdocker registryにビルド途中のイメージもpushする? みたいな感じのようです。

> By default, it pushes the image with all the stages to a registry (needs username and password),
> but you can disable this feature by setting push_image_and_stages to false.

## 2. [`satackey/action-docker-layer-caching`](https://github.com/marketplace/actions/docker-layer-caching)

このアクションは実際に使ってみました(動きました)。

docker saveでtarで固めてしまってGitHub Actions側のキャッシュに保存し、docker loadでそれをrestoreする、という実装になっているようです。

実際に使ったPullRequestとActionsの結果を貼っておきます。

* PullRequest https://github.com/hoshinotsuyoshi/fastladder/pull/2
* Actions
  * 1回目 **3m26s** https://github.com/hoshinotsuyoshi/fastladder/runs/911692797
  * 2回目 **2m19s** https://github.com/hoshinotsuyoshi/fastladder/runs/911714333


### workflow file(yaml)

```yaml
# see https://github.com/marketplace/actions/docker-layer-caching

name: CI

on: push

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - run: docker-compose pull

    - uses: satackey/action-docker-layer-caching@v0.0.3

    - run: docker-compose run web sh -c "./wait-for-it.sh db:3306 && bin/rake db:create db:migrate spec RAILS_ENV=test"
```

CIで使うなら、docker-composeでrspec動かしてるような時には1行足すだけで使えます。ただ、心なしか(仕組み上)docker imageのサイズによってはリストアに時間がかかりすぎるような気もします。


## 次は

次はRailsアプリでCIでsystem testするやつを書きます(書きたい)
