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

			//			back=false;
			Starling.juggler.add(mc);
			//			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var _back:Boolean=false;

		public function get back():Boolean
		{
			return _back;
		}

		public function set back(value:Boolean):void
		{
			_back=value;
			if (mc)
				mc.rotation=_back ? 0 : Math.PI / 2
		}


		private function onEnterFrame(e:Event):void
		{
			if (!back)
				mc.x+=3;
			else
				mc.x-=3;
			mc.y+=Math.random() * 2 - 1;
			if (mc.y < 100)
				mc.y=0;
			else if (mc.y > 600)
				mc.y=768;
			if (mc.x > 800)
				back=true;
			else if (mc.x < 200)
				back=false;
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
