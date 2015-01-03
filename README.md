# ゲーム設定型ダイスボット「ボーンズ＆カーズ」

[![Build Status](https://travis-ci.org/torgtaitai/BCDice.svg?branch=master)](https://travis-ci.org/torgtaitai/BCDice)

* 著作権者：[Faceless](http://faceless-tools.cocolog-nifty.com/) & [たいたい竹流](http://www.dodontof.com/)
* ライセンス：[修正BSDライセンス](./LICENSE)
* 連絡先 及び 1次配布：https://github.com/torgtaitai/BCDice

IRC用のダイスボットです。ゲーム設定によって成功度も自動判定します。オープンソースですので、Rubyの読める方はダイスボット作成時に参考・流用してください。

## 使用方法

Windowsで動かす場合にはそのまま**bcdice.exe**をダブルクリックして実行してください。画面が表示されますので、IRCへの設定を入力して「接続」ボタンを押せばつながります。

Windows以外のOSの場合、Ruby1.9をインストールした上で下記のコマンドでライブラリをインストール願います。

```bash
gem install net-irc
gem install wxruby-ruby19
gem install ocra
```

後はsrcディレクトリに移動し、`ruby bcdice.rb` コマンドで画面が表示されます。後はWindows版と同様です。

また、サーバーなどはコマンドラインからも指定できます。書式は

| オプション | 機能           | 書式                      | 例                    |
| ---------- | -------------- | ------------------------- | --------------------- |
| `-s`       | サーバ設定     | `-s(サーバ):(ポート番号)` | `-sirc.trpg.net:6667` |
| `-c`       | チャンネル設定 | `-c(チャンネル名)`        | `-c#Dice_test`        |
| `-n`       | Nick設定       | `-n(Nick)`                | `-nFDiceCOC`          |
| `-m`       | メッセージ設定 | `-m(Notice_flgの番号)`    | `-m0`                 |
| `-g`       | ゲーム設定     | `-g(ゲーム指定文字列)`    | `-gCthulhu`           |
| `-e`       | 拡張カード読込 | `-e(ファイル名)`          | `-etestset.txt`       |
| `-i`       | IRC文字コード  | `-i(文字コード名称)`      | `-iISO-2022-JP`       |

となります。必要な部分だけ書いて、後の部分を省略してもかまいません。順序は自由ですが、各引数の間は半角スペースが必要です。また、`-e` オプションを使うときはカードファイルをこのスクリプトと同じフォルダに置いてください。

例）

```bat
　bcdice.exe -sirc.trpg.net:6667 -c#OnlineTRPG -gCthulhu -nfDICE_CoC
```

プレイ環境ごとにバッチファイルを作っておくと便利です。

終了時はボットにTalkで `お疲れ様` と発言するとボットがサーバから切断して終了します。

## ボットの利用法

IRC 上でヘルプメッセージを見たいときは、Talkでダイスボットに `help` と発言してください。カード機能に関しては `c-help` と発言してください。

* [ダイス](./doc/dice.md)
* [ゲーム固有のコマンド](./doc/diceBots.md)
* [四則計算](./doc/calculator.md)
* [ポイントカウンタ](./doc/pointCounter.md)
* [カード機能](./doc/cards.md)
* [マスターコマンド](./doc/masterCommands.md)
* [オリジナルの表追加](./doc/originalTables.md)

## 更新履歴

* [過去の更新履歴](./CHANGELOG.md)

### Ver2.02.28 2015/01/02

* ダイスボットに同人ゲームのガラコと破界の塔を追加。anony403さん、ブラフマンさんありがとうっ！！
