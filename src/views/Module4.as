package views
{
	import flash.filesystem.File;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module4.Scene41;
	import views.module4.Scene42;

	public class Module4 extends PalaceModule
	{
		public function Module4(_skipIndex:int=-1)
		{
			skipIndex=_skipIndex;
			sceneArr=[Scene41, Scene42];

			Q1="皇帝需要工作吗？"
			A1="清朝的国家大事都由皇帝一个人来决定。早饭后9点到11点是皇帝办公的时间，主要用来批阅奏章，召见官员。定期，皇帝还要一大早在乾清门会见各部官员，直接商讨、处理政务。"

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
					isLoading=false;
					assetManager=assets;
//					sceneIndex=0;
//					loadScene(sceneIndex);
					addNext();
				}
			});
		}
	}
}
