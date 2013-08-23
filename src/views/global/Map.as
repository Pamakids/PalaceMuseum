package views.global
{
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;

	public class Map extends PalaceModule
	{
		public function Map()
		{
			super(new AssetManager());
			LoadManager.instance.loadImage('assets/global/mapBG.png', bgLoadedHandler);
		}

		private function bgLoadedHandler(b:Bitmap):void
		{

		}

		public static function show():void
		{

		}
	}
}
