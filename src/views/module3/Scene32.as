package views.module3
{
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module3.scene32.Telescope;

	public class Scene32 extends PalaceScene
	{
		public function Scene32(am:AssetManager=null)
		{
			super(am);

			initTelescope();
		}

		private function initTelescope():void
		{
			var tele:Telescope=new Telescope(assets)
			addChild(tele);
		}
	}
}
