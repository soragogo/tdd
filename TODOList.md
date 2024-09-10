### TODOリスト
* 設計図を描く✅
* pongクラスを作る✅
* paddle：サイズ、スピード✅
* ボール：サイズ、スピード、ベクトル✅
* プレイヤー：スコア✅
* pong初期化でpaddle,ボール、プレイヤーが初期化される✅
* PongにGosuを入れる ✅
* Pongがdrawできているのかはどうやってテストすればいいんだ？
*
### notes
[Gosuチュートリアル](https://gist.github.com/myokoym/7148859)
* Gosu::Windowのupdateとdrawを上書きする。
* update()はゲームの主要ロジック。デフォルトで毎秒60回呼ばれる。
* draw()は画面の描画ロジックだけが含まれるべき。
* pongが画面を初期化できているかテストをしたい。
→ initializeで親クラスのinitializerが呼ばれているかテストすることにした
irb(main):005:0> require 'gosu'
=> true
irb(main):006:0> Gosu::Window.any_instance
Gosu::Window.any_instance
=> #<Mocha::ClassMethods::AnyInstance:0x0000000105011250 @stubba_object=Gosu::Window>