package views.module3
{
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module3.scene32.Telescope;
	import views.module3.scene32.TriangularPrism;

	public class Scene32 extends PalaceScene
	{
		public function Scene32(am:AssetManager=null)
		{
			super(am);

//			initTelescope();
			initPrism();
		}

		private function initTelescope():void
		{
			var tele:Telescope=new Telescope(assets)
			addChild(tele);
		}

		private function initPrism():void
		{
			var prism:TriangularPrism=new TriangularPrism(assets);
			addChild(prism);
		}
	}
}
