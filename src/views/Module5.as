package views
{
	import com.pamakids.palace.utils.StringUtils;

	import flash.filesystem.File;

	import sound.SoundAssets;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module5.Scene51;
	import views.module5.Scene52;

	public class Module5 extends PalaceModule
	{
		public function Module5(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene51, Scene52];

			Q1="皇帝怎么娱乐休闲？"
			A1="清朝皇宫中有多种多样的娱乐活动，琴棋书画、花鸟虫鱼，各个皇帝的喜好不一样。所有皇帝和后妃们都最喜欢看戏。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}

		override protected function loadAssets(index:int, callback:Function):void
		{
			if (index == 1)
			{
				assetManager=new AssetManager();
				var scene:Class=sceneArr[index] as Class;
				var sceneName:String=StringUtils.getClassName(scene);
				var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/" + sceneName);
				var path:String="assets/module3/scene31/dragMC."
				assetManager.enqueue(file, path + "atf", path + "xml");
				assetManager.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1.0 && callback != null)
						callback();
				});
			}
			else
				super.loadAssets(index, callback);
		}
	}
}
