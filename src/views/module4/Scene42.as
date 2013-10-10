package views.module4
{
	import com.greensock.TweenLite;

	import events.OperaSwitchEvent;

	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module4.scene42.OpearaGame2;
	import views.module4.scene42.OperaGame;

	/**
	 * 娱乐模块
	 * 看戏场景(京剧游戏1,2)
	 * @author Administrator
	 */
	public class Scene42 extends PalaceScene
	{

		private var mc:MovieClip;

		private var game:OperaGame;

		private var gameHolder:Sprite;

		private var curtainL:Image;
		private var curtainR:Image;
		private var offsetX:Number;

		private var game2:OpearaGame2;

		public function Scene42(am:AssetManager=null)
		{
			super(am);

			gameHolder=new Sprite();
			addChild(gameHolder);

			curtainL=getImage("opera-curtainL");
			offsetX=curtainL.width;
			curtainL.x=0;
			addChild(curtainL);
			curtainR=getImage("opera-curtainR");
			curtainR.x=1024 - offsetX;
			addChild(curtainR);

			initGame();
//			initGame2();
		}

		public function onOperaSwitch(e:OperaSwitchEvent):void
		{
			TweenLite.killDelayedCallsTo(this);
			TweenLite.killTweensOf(curtainL);
			TweenLite.killTweensOf(curtainR);
			switch (e.action)
			{
				case OperaSwitchEvent.OPEN:
				{
					openCurtains(e.openCallback);
					break;
				}

				case OperaSwitchEvent.CLOSE:
				{
					closeCurtains(e.closeCallback);
					break;
				}

				case OperaSwitchEvent.OPEN_CLOSE:
				{
					openCurtains(function():void {
						if (e.openCallback != null)
							e.openCallback();
						TweenLite.delayedCall(e.delay, function():void {
							closeCurtains(e.closeCallback);
						});
					});
					break;
				}

				case OperaSwitchEvent.CLOSE_OPEN:
				{
					closeCurtains(function():void {
						if (e.closeCallback != null)
							e.closeCallback();
						TweenLite.delayedCall(e.delay, function():void {
							openCurtains(e.openCallback);
						});
					});
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function closeCurtains(closeCallback:Function=null):void
		{
			TweenLite.to(curtainL, 1, {x: 0});
			TweenLite.to(curtainR, 1, {x: 1024 - offsetX, onComplete: closeCallback});
		}

		private function openCurtains(openCallback:Function=null):void
		{
			TweenLite.to(curtainL, 1, {x: -offsetX});
			TweenLite.to(curtainR, 1, {x: 1024, onComplete: openCallback});
		}

		private function initGame():void
		{
			game=new OperaGame(assets);
			game.scene=this;
			gameHolder.addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGameOver);
			game.addEventListener("nextGame", onPlayGame2);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}

		private function onPlayGame2(e:Event):void
		{
			var lvl:int=game.gamelevel;
			if (game.isWin())
				showAchievement(lvl == 0 ? 28 : 29);
			game.removeEventListener(PalaceGame.GAME_OVER, onGameOver);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			game.removeEventListener("nextGame", onPlayGame2);
			gameHolder.removeChild(game);
			game.dispose();
			game=null;

			initGame2(lvl);
		}

		private function initGame2(lvl:int):void
		{
			game2=new OpearaGame2(lvl, assets);
			gameHolder.addChild(game2);
			game2.scene=this;
			game2.addEventListener(PalaceGame.GAME_OVER, onGame2Over);
		}

		private function onGame2Over(e:Event):void
		{
			showAchievement(27);
			sceneOver();
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener(PalaceGame.GAME_OVER, onGameOver);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			game.removeEventListener("nextGame", onPlayGame2);
			gameHolder.removeChild(game);
			game.dispose();
			game=null;

			initGame();
		}

		private function onGameOver(e:Event):void
		{
			var lvl:int=game.gamelevel;
			game.removeEventListener(PalaceGame.GAME_OVER, onGameOver);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			game.removeEventListener("nextGame", onPlayGame2);
			gameHolder.removeChild(game);
			game.dispose();
			game=null;

			initGame2(lvl);
		}
	}
}
