package views
{
	import flash.filesystem.File;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module2.scene22.MenuGame;
	import views.module2.scene23.DishGame;
	import views.module3.scene31.JigsawGame;
	import views.module4.scene42.OperaGame;

	public class GameScene extends PalaceScene
	{
		private var gamePathArr:Array=["22", "23", "31", "42"];
		private var gameArr:Array=[MenuGame, DishGame, JigsawGame, OperaGame];

		private var game:PalaceGame;
		private var crtGameIndex:int;

		public function GameScene(gameIndex:int)
		{
			crtGameIndex=gameIndex;
			assets=new AssetManager();
			var _name:String=gamePathArr[gameIndex];
			var file:File=File.applicationDirectory.resolvePath("assets/" + "module" + _name.charAt(0) + "/scene" + _name);
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assets.enqueue(file, f);
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
					initGame(crtGameIndex);
			});
		}

		private function initGame(index:int):void
		{
			var cls:PalaceGame=gameArr[index];
			game=new cls(assets);
			game.fromCenter=true;
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}

		private function onGameRestart(e:Event):void
		{
			onGamePlayed(null);
			initGame(crtGameIndex);
		}

		private function onGamePlayed(e:Event):void
		{
			removeChild(game);
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			if (e)
				game.dispose();
		}
	}
}
