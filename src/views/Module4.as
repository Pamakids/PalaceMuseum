package views
{
	import controllers.MC;

	import sound.SoundAssets;

	import views.components.ElasticButton;
	import views.components.base.PalaceModule;
	import views.global.TopBar;
	import views.module4.Scene41;
	import views.module4.Scene42;
	import views.module4.Scene43;
	import views.module4.Scene44;

	public class Module4 extends PalaceModule
	{
		public function Module4(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			sceneArr=[Scene41, Scene42, Scene43, Scene44];
			birdArr=[9,10,-1,-1];

			Q1="皇帝需要工作吗？"
			A1="清朝的国家大事都由皇帝一个人来决定。早饭后9点到11点是皇帝办公的时间，主要用来批阅奏章，召见官员。定期，皇帝还要一大早在乾清门会见各部官员，直接商讨、处理政务。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}

		override protected function addNext():void
		{
			TopBar.enable=true;
			MC.instance.main.removeMask();
			removeLoading();
			if (skipIndex < 0 || skipIndex == 2)
			{
				var next:ElasticButton=new ElasticButton(getImage("nextButton"));
				addChild(next);
				next.pivotX=next.width >> 1;
				next.pivotY=33;
				next.x=1024 - 100;
				next.y=768 - 100;
				next.addEventListener(ElasticButton.CLICK, initScene);
			}
			else
			{
				sceneIndex=skipIndex;
				loadScene(sceneIndex);
			}
		}
	}
}


