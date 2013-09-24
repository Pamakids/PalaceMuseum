package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module4.Scene41;
	import views.module4.Scene42;

	public class Module4 extends PalaceModule
	{
		public function Module4(am:AssetManager=null, width:Number=0, height:Number=0)
		{
			sceneArr=[Scene41, Scene42];

			Q1="皇帝爱学习吗？"
			A1="清朝皇帝喜爱学习－儒家经典、汉语诗文、满文、蒙文和骑马射箭，样样要精通。"
			Q2="皇帝起床后第一件事做什么？"
			A2="先给太后请安，之后的第一件事就是早读学习。"

			addLoading();
			addQAS();

			var assets:AssetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName);
			assets.enqueue(file,
				"assets/common/button_close.png", "assets/common/game-start-down.png", "assets/common/nextButton.png",
				"assets/common/game-start.png", "assets/common/gamebg.jpg", "assets/common/lion.png");
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					isLoading=false;
					assetManager=assets;
					sceneIndex=0;
					loadScene(sceneIndex);
					removeQAS();
				}
			});
		}
	}
}
