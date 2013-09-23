package views.module4
{
	import com.greensock.TweenLite;

	import events.OperaSwitchEvent;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module4.scene41.OperaGame;

	public class Scene41 extends PalaceScene
	{

		private var mc:MovieClip;

		private var game:OperaGame;

		private var gameHolder:Sprite;

		private var curtainL:Image;
		private var curtainR:Image;
		private var offsetX:Number;

		public function Scene41(am:AssetManager=null)
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

		private function initBird():void
		{
			mc=new MovieClip(assets.getTextures("ufo"));
			this.addChild(mc);
			mc.fps=30;
			mc.play();
			mc.x=300;
			mc.y=384;

			Starling.juggler.add(mc);
		}

		private function initGame():void
		{
			game=new OperaGame(assets);
			game.scene=this;
			gameHolder.addChild(game);
			game.addEventListener("gameOver", onGameOver);
			game.addEventListener("gameRestart", onGameRestart);
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener("gameOver", onGameOver);
			game.removeEventListener("gameRestart", onGameRestart);
			gameHolder.removeChild(game);
			game.dispose();
			game=null;

			initGame();
		}

		private function onGameOver(e:Event):void
		{
			// TODO Auto Generated method stub

		}
	}
}
