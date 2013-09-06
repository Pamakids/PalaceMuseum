package views.module3
{
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module3.scene32.JigsawGame;
	import views.module3.scene32.Telescope;

	public class Scene32 extends PalaceScene
	{
		private var game:JigsawGame;

		public function Scene32(am:AssetManager=null)
		{
			super(am);

			initTelescope();

//			initGame();
		}

		private function initTelescope():void
		{
			var tele:Telescope=new Telescope(assets)
			addChild(tele);
		}

		private function initGame():void
		{
			game=new JigsawGame(assets);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)
			addChild(game);
		}

		private function onGamePlayed(e:Event):void
		{
			game.removeEventListener("gameOver", onGamePlayed)
			game.removeEventListener("gameRestart", onGameRestart)
			game.removeChildren();
			removeChild(game);
			game=null;

		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener("gameOver", onGamePlayed);
			game.removeEventListener("gameRestart", onGameRestart);
			game.removeChildren();
			removeChild(game);
			game=null;

			game=new JigsawGame(assets);
			addChild(game);
			game.addEventListener("gameOver", onGamePlayed);
			game.addEventListener("gameRestart", onGameRestart);
//			game.startGame();
		}
	}
}
