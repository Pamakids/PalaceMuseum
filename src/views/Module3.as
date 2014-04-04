package views
{
	import sound.SoundAssets;

	import views.components.base.PalaceModule;
	import views.module3.Scene31;
	import views.module3.Scene32;
	import views.module3.Scene33;
	import views.module3.Scene34;

	public class Module3 extends PalaceModule
	{
		public function Module3(_skipIndex:int=-1)
		{
			SoundAssets.addModuleSnd(moduleName);
			skipIndex=_skipIndex;
			if (skipIndex == 3)
				skipIndex=0;
			else if (_skipIndex > -1)
				skipIndex++;
			sceneArr=[Scene34, Scene31, Scene32, Scene33];
			birdArr=[-1,4,5,6];

//			if (skipIndex < 2)
//				loadFirst();
//			else
//				loadSecond();

			Q1="御膳房是什么地方？"
			A1="皇宫中专门管理皇帝吃饭的机构叫“御膳房”。紫禁城里大大小小的宫院里，都有各自的膳房。没有人准确地知道，究竟有多少人为皇帝一家的吃喝服务。据记载，仅“养心殿”一个御膳房，就有几百人之多。"
			addQAS();
			addLoading();

			loadAssets(skipIndex, addNext);
		}

//		private function loadFirst():void
//		{
//			Q1="御膳房是什么地方？"
//			A1="皇宫中专门管理皇帝吃饭的机构叫“御膳房”。紫禁城里大大小小的宫院里，都有各自的膳房。没有人准确地知道，究竟有多少人为皇帝一家的吃喝服务。据记载，仅“养心殿”一个御膳房，就有几百人之多。"
//			addQAS();
//			addLoading();
//
//			loadAssets(skipIndex, addNext);
//		}
//
//		private function loadSecond():void
//		{
//			Q1="什么是“传膳”？"
//			A1="皇帝吃饭称为“传膳”或“用膳”，没有固定地点，就在休息、办公的地方放桌子、摆盘子。"
//			Q2="皇帝也是一日三餐吗？"
//			A2="清朝皇帝一天只吃两顿正餐，早饭在7点到9点之间，晚饭在下午1点到3点之间。"
//			addQAS();
//			addLoading();
//
//			if (sceneIndex < 2)
//				sceneIndex=Math.max(skipIndex, 2);
//			loadAssets(sceneIndex, addNext2);
//		}

//		protected function addNext2():void
//		{
//			TopBar.enable=true;
//			MC.instance.main.removeMask();
//			removeLoading();
//			if (skipIndex < 2)
//			{
//				var next:ElasticButton=new ElasticButton(getImage("nextButton"));
//				addChild(next);
//				next.pivotX=next.width >> 1;
//				next.pivotY=33;
//				next.x=1024 - 100;
//				next.y=768 - 100;
//				next.addEventListener(ElasticButton.CLICK, initScene2);
//			}
//			else
//			{
//				sceneIndex=skipIndex;
//				loadScene(sceneIndex);
//			}
//		}

//		private function initScene2(e:Event):void
//		{
//			tfHolder.removeFromParent(true);
//			var next:ElasticButton=e.currentTarget as ElasticButton;
//			next.removeFromParent(true);
//			loadScene(sceneIndex);
//		}

//		override protected function nextScene(e:Event):void
//		{
//			if (sceneIndex == 1)
//			{
//				sceneIndex++;
//				if (crtScene)
//					crtScene.removeFromParent(true);
//				loadSecond();
//			}
//			else
//				super.nextScene(e);
//		}
	}
}


