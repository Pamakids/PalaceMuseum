package views.module4.scene41
{
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class OperaGame extends PalaceGame
	{
		public function OperaGame(am:AssetManager=null)
		{
			super(am);
		}

		private var layer1:Sprite;
		private var layer2:Sprite;
		private var layer3:Sprite;

		private var startHolder:Sprite;
		private var gameHolder:Sprite;
		private var endHolder:Sprite;

		private var gameLevel:int;

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
		}

		private function initGame():void
		{
			removeChild(startHolder);
			startHolder.dispose();
			startHolder=null;

			gameHolder=new Sprite();
			addChild(gameHolder);

			layer3=new Sprite();

		}

		private function initResult():void
		{
			removeChild(gameHolder);
			gameHolder.dispose();
			gameHolder=null;

			endHolder=new Sprite();
			addChild(endHolder);
		}
	}
}
