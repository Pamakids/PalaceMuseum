package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module2.Scene21;
	import views.module2.Scene22;

	public class Module2 extends PalaceModule
	{
		public function Module2(_skipIndex:int=-1)
		{
			skipIndex=_skipIndex;
			sceneArr=[Scene21, Scene22];

			Q1="皇帝爱学习吗？"
			A1="清朝皇帝喜爱学习－儒家经典、汉语诗文、满文、蒙文和骑马射箭，样样要精通。"
			Q2="皇帝起床后第一件事做什么？"
			A2="先给太后请安，之后的第一件事就是早读学习。"

			addQAS();
			addLoading();

			if (assetManager)
			{
				assetManager.purge();
				assetManager=null;
			}
			assetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName);
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assetManager.enqueue(file, f);
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					isLoading=false;
					addNext();
				}
			});
		}
	}
}
