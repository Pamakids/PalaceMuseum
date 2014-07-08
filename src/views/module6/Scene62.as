package views.module6
{
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module6.scene62.ArcherGame;

	public class Scene62 extends PalaceScene
	{
		public function Scene62(am:AssetManager=null)
		{
			super(am);

			initGame();
		}

		private function initGame():void
		{
			var game:ArcherGame=new ArcherGame(this.assetManager);
			addChild(game);
		}
	}
}

