package views
{
	import com.pamakids.palace.utils.StringUtils;

	import flash.filesystem.File;

	import sound.SoundAssets;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module2.Scene21;
	import views.module2.Scene22;

	public class Module2 extends PalaceModule
	{
		public function Module2(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene21, Scene22];
			birdArr=[-1,2,3];

			Q1="皇帝爱学习吗？"
			A1="清朝皇帝喜爱学习－儒家经典、汉语诗文、满文、蒙文和骑马射箭，样样要精通。"
			Q2="皇帝起床后第一件事做什么？"
			A2="先给太后请安，之后的第一件事就是早读学习。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}

		override protected function loadAssets(index:int, callback:Function):void
		{
			if (index < 0)
				index=0
			if (index == 0)
			{
				if(assetManager)
					assetManager.purge()
				assetManager=null;
				assetManager=new AssetManager();
				var scene:Class=sceneArr[index] as Class;
				var sceneName:String=StringUtils.getClassName(scene);
				var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/" + sceneName);
				var path:String="assets/module1/scene12/kingExp"
				var birdIndex:int=birdArr[index];
				if(birdIndex<0||checkBird(birdIndex))
				{
					assetManager.enqueue(file, path + ".png", path + ".xml");
				}else{
					assetManager.enqueue(file, path + ".png", path + ".xml");
					assetManager.enqueue("assets/global/handbook/bird_collection_" + birdIndex + ".png",
										 "assets/global/handbook/mainUI/background_2.png");
				}
//				assetManager.enqueue(file, path + ".atf", path + ".xml");
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


