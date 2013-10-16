package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module3.Scene31;
	import views.module3.Scene32;
	import views.module3.Scene33;

	public class Module3 extends PalaceModule
	{
		public function Module3(_skipIndex:int=-1)
		{
			skipIndex=_skipIndex;
			sceneArr=[Scene31, Scene32, Scene33];

			Q1="什么是“传膳”？"
			A1="皇帝吃饭称为“传膳”或“用膳”，没有固定地点，就在休息、办公的地方放桌子、摆盘子。"
			Q2="皇帝也是一日三餐吗？"
			A2="清朝皇帝一天只吃两顿正餐，早饭在7点到9点之间，晚饭在下午1点到3点之间。"

			addLoading();
			addQAS();

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
//					sceneIndex=0;
//					loadScene(sceneIndex);
					addNext();
				}
			});
		}
	}
}
