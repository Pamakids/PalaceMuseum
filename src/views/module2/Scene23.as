package views.module2
{
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module2.scene22.MenuGame;
	import views.module2.scene23.DishGame;

	public class Scene23 extends PalaceScene
	{

		private var game:DishGame;

		public function Scene23(am:AssetManager=null)
		{
			super(am);

			initDishGame();
		}

		private function initDishGame():void
		{
			game=new DishGame(assets);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)
			addChild(game);
		}

		private function onGamePlayed(e:Event):void
		{
			removeChild(game);
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener("gameOver", onGamePlayed)
			game.removeEventListener("gameRestart", onGameRestart)
			game.removeChildren();
			removeChild(game);
			game=null;

			game=new DishGame(assets);
			addChild(game);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)
		}
	}
}
