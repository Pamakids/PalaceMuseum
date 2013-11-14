package views
{
	import flash.filesystem.File;

	import sound.SoundAssets;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module4.Scene41;
	import views.module4.Scene42;
	import views.module4.Scene43;

	public class Module4 extends PalaceModule
	{
		public function Module4(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene41, Scene42, Scene43];

			Q1="皇帝需要工作吗？"
			A1="清朝的国家大事都由皇帝一个人来决定。早饭后9点到11点是皇帝办公的时间，主要用来批阅奏章，召见官员。定期，皇帝还要一大早在乾清门会见各部官员，直接商讨、处理政务。"

			addQAS();
			addLoading();

			if (assetManager)
			{
				assetManager.purge();
				assetManager=null;
			}
			assetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName);
//			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assetManager.enqueue(file);
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
