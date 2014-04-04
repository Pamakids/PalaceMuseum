package views
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.filesystem.File;
	import flash.geom.Point;

	import assets.embed.EmbedAssets;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.global.TopBar;
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
			birdArr=[0,-1,1,-1];

			Q1="故宫这么大，皇帝住在哪儿？"
			A1="顺治和康熙帝住在乾清宫，之后的八个皇帝都住在养心殿。"
			Q2="皇帝睡懒觉吗？"
			A2="清朝的皇帝几乎每天5点左右起床。"

			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}

		override protected function nextScene(e:Event):void
		{
			var is11:Boolean;
			if(crtScene)
			{
				if(crtScene is Scene11){
					is11=true;
				}
			}

			UserBehaviorAnalysis.trackEvent("click", "next");
			TopBar.enable=false;

			if(crtScene)
			{
				if(capture)
				{
					capture.removeFromParent(true);
					capture=null;
				}
				capture=new Image(crtScene.getCapture());
				addChild(capture);
				crtScene.removeFromParent(true);
				if(!is11)
					crtScene=null;
			}

			if (nextButton){
				nextButton.touchable=false;
				this.setChildIndex(nextButton,numChildren-1);
			}
			TweenLite.killTweensOf(shakeNext);

			addMask(0);
			sceneIndex++;
			loadAssets(sceneIndex, function():void {
				if(is11){
					Scene11(crtScene).removeMC();
					crtScene=null
				}
				removeMask();
				loadScene(sceneIndex);
			});
		}

		override public function dispose():void{
			var is11:Boolean;
			if(crtScene)
			{
				if(crtScene is Scene11){
					Scene11(crtScene).removeMC();
				}
			}

			super.dispose();
		}
	}
}

