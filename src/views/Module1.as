package views
{
	import flash.filesystem.File;
	import flash.geom.Point;

	import assets.loadings.LoadingAssets;

	import sound.SoundAssets;

	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module1.Scene11;
	import views.module1.Scene12;
	import views.module1.Scene13;
	import views.module1.Scene14;

	public class Module1 extends PalaceModule
	{
		public function Module1(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene11, Scene12, Scene13, Scene14];

			Q1="故宫这么大，皇帝住在哪儿？"
			A1="顺治和康熙帝住在乾清宫，之后的八个皇帝都住在养心殿。"
			Q2="皇帝睡懒觉吗？"
			A2="清朝的皇帝几乎每天5点左右起床。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}
	}
}

