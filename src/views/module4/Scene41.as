package views.module4
{
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module4.scene41.OperaGame;

	public class Scene41 extends PalaceScene
	{
		public function Scene41(am:AssetManager=null)
		{
			super(am);

			var game:OperaGame=new OperaGame(am);
			addChild(game);
			game.addEventListener("gameOver", onGameOver);
		}

		private function onGameOver(e:Event):void
		{
			// TODO Auto Generated method stub

		}
	}
}
