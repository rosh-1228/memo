# メモ帳アプリ
フィヨルドブートキャンプの課題にて作成したメモアプリです。
以下の機能を備えています。
- メモの作成
- メモの編集
- メモの削除
## システム要件
```
ruby 3.0.0
```
## 使用方法
- メモアプリ起動

以下のコマンドを実行してください。
```
bundle exec ruby app.rb
```
- メモアプリにアクセス

ブラウザを開き、`127.0.0.1:4567`を入力してEnterを押します。

## デモ
- メモの作成

![new_memo](https://user-images.githubusercontent.com/64620506/141740522-6c659d45-e54c-4e72-99c8-d7273845c16f.gif)

- メモの編集

![update_memo](https://user-images.githubusercontent.com/64620506/141740844-bda0e051-7f84-4462-9ee8-3067a8afae06.gif)

- メモの削除

![delete_memo](https://user-images.githubusercontent.com/64620506/141740924-09ad1101-d87c-4e13-9851-525cfc4f015c.gif)

## テスト
以下のコマンドを実行してください。
```
bundle exec ruby test/test.rb
```