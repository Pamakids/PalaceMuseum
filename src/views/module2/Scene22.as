package views.module2
{
	import com.pamakids.utils.DPIUtil;

	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module2.scene22.MenuGame;

	public class Scene22 extends PalaceScene
	{

		private var scale:Number;

		public function Scene22(am:AssetManager=null)
		{
			super(am);
			scale=DPIUtil.getDPIScale();

			playMenuGame();

		}

		private function playMenuGame():void
		{
			var game:MenuGame=new MenuGame(assets);
			addChild(game);
		}
	}
}
