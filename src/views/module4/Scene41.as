package views.module4
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module4.scene41.OperaGame;

	public class Scene41 extends PalaceScene
	{

		private var mc:MovieClip;

		public function Scene41(am:AssetManager=null)
		{
			super(am);

			initGame();
//			initBird();

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
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{
			mc.x-=20;
//			mc.y+=Math.random() * 2 - 1;
//			if (mc.y < 100)
//				mc.y=0;
//			else if (mc.y > 600)
//				mc.y=768;
			if (mc.x < -100)
				mc.x=1024;
		}

		private function initGame():void
		{
			var game:OperaGame=new OperaGame(assets);
			addChild(game);
			game.addEventListener("gameOver", onGameOver);
		}

		private function onGameOver(e:Event):void
		{
			// TODO Auto Generated method stub

		}
	}
}
