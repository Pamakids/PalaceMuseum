package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module1.Scene11;
	import views.module1.Scene12New;
	import views.module1.Scene13;
	import views.module1.Scene14;

	public class Module1 extends PalaceModule
	{
		public function Module1()
		{
			sceneArr=[Scene11, Scene12New, Scene13, Scene14];

			Q1="故宫这么大，皇帝住在哪儿？"
			A1="顺治和康熙帝住在乾清宫，之后的八个皇帝都住在养心殿。"
			Q2="皇帝睡懒觉吗？"
			A2="清朝的皇帝几乎每天5点左右起床。"

			addLoading();
			addQAS();

			var assets:AssetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName);
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assets.enqueue(file, f, "json/hint12.json");
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					assetManager=assets;
					isLoading=false;
					sceneIndex=0;
					loadScene(sceneIndex);
					removeQAS();
				}
			});
		}
	}
}

