package views.module3
{
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module3.scene32.JigsawGame;

	public class Scene32 extends PalaceScene
	{
		public function Scene32(am:AssetManager=null)
		{
			super(am);

			initGame();
		}

		private function initGame():void
		{
			var game:JigsawGame=new JigsawGame(assets);
			addChild(game);
		}
	}
}
