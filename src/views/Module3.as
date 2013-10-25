package views
{
	import flash.filesystem.File;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceModule;
	import views.module3.Scene34;
	import views.module3.Scene31;
	import views.module3.Scene32;
	import views.module3.Scene33;

	public class Module3 extends PalaceModule
	{
		public function Module3(_skipIndex:int=-1)
		{
			skipIndex=_skipIndex;
			if (skipIndex == 3)
				skipIndex=0;
			else if (_skipIndex > -1)
				skipIndex++;
			sceneArr=[Scene34, Scene31, Scene32, Scene33];

			if (skipIndex < 2)
				loadFirst();
			else
				loadSecond();
		}

		private function loadFirst():void
		{
			Q1="御膳房是什么地方？"
			A1="皇宫中专门管理皇帝吃饭的机构叫“御膳房”。紫禁城里大大小小的宫院里，都有各自的膳房。没有人准确地知道，究竟有多少人为皇帝一家的吃喝服务。据记载，仅“养心殿”一个御膳房，就有几百人之多。"
			addQAS();
			addLoading();

			if (assetManager)
			{
				assetManager.purge();
				assetManager=null;
			}
			assetManager=new AssetManager();
			var file1:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/scene30");
			var file2:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/scene31");
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assetManager.enqueue(file1, file2, f);
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					isLoading=false;
					addNext();
				}
			});
		}

		private function loadSecond():void
		{
			Q1="什么是“传膳”？"
			A1="皇帝吃饭称为“传膳”或“用膳”，没有固定地点，就在休息、办公的地方放桌子、摆盘子。"
			Q2="皇帝也是一日三餐吗？"
			A2="清朝皇帝一天只吃两顿正餐，早饭在7点到9点之间，晚饭在下午1点到3点之间。"
			addQAS();
			addLoading();

			if (assetManager)
			{
				assetManager.purge();
				assetManager=null;
			}
			assetManager=new AssetManager();
			var file1:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/scene32");
			var file2:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/scene33");
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			assetManager.enqueue(file1, file2, f);
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					assetManager=assetManager;
					isLoading=false;
					addNext2();
				}
			});
		}

		protected function addNext2():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (load)
				load.removeFromParent(true);
			if (skipIndex < 2)
			{
				var next:ElasticButton=new ElasticButton(getImage("nextButton"));
				addChild(next);
				next.x=1024 - 100;
				next.y=768 - 100;
				next.addEventListener(ElasticButton.CLICK, initScene2);
			}
			else
			{
				sceneIndex=skipIndex;
				loadScene(sceneIndex);
			}
		}

		private function initScene2(e:Event):void
		{
			tfHolder.removeFromParent(true);
			var next:ElasticButton=e.currentTarget as ElasticButton;
			next.removeFromParent(true);
			loadScene(sceneIndex);
		}

		override protected function nextScene(e:Event):void
		{
			sceneIndex++;
			if (sceneIndex == 2)
			{
				if (crtScene)
					crtScene.removeFromParent(true);
				loadSecond();
			}
			else
				loadScene(sceneIndex);
		}
	}
}
