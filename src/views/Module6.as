package views
{
	import sound.SoundAssets;

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

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}
	}
}

