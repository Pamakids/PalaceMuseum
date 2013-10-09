package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.Intro.IntroScene;
	import views.components.base.PalaceModule;

	public class Intro extends PalaceModule
	{
		public function Intro(am:AssetManager=null, width:Number=0, height:Number=0)
		{
			sceneArr=[IntroScene];

			addLoading();

			var assets:AssetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName);
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assets.enqueue(file, f);
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					assetManager=assets;
					isLoading=false;
					sceneIndex=0;
					loadScene(sceneIndex);
				}
			});
		}
	}
}
