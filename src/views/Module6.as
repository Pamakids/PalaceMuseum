package views
{
	import com.pamakids.palace.utils.StringUtils;

	import flash.filesystem.File;

	import sound.SoundAssets;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module6.Scene61;
	import views.module6.Scene62;

	public class Module6 extends PalaceModule
	{
		public function Module6(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene61, Scene62];
			birdArr=[-1,-1];

//			Q1="皇帝怎么娱乐休闲？"
//			A1="清朝皇宫中有多种多样的娱乐活动，琴棋书画、花鸟虫鱼，各个皇帝的喜好不一样。所有皇帝和后妃们都最喜欢看戏。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}
	}
}

