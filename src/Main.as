package
{
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	import controllers.MC;

	import models.Const;
	import models.FontVo;

	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.Module5;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.global.map.Map;
	import views.global.userCenter.UserCenterManager;

	public class Main extends Container
	{
		private var testingModule:Sprite;
		private var testingModuleClass:Class=Module5;

		public function Main()
		{
//			SOService.instance.clear();
			super(Const.WIDTH, Const.HEIGHT);
			scaleX=scaleY=scale;
			MC.instance.init(this);
			//以免第一次初始化提示的时候卡顿
			var label:TextField=new TextField(1, 1, '0', FontVo.PALACE_FONT, 16, 0x561a1a, true);
			addChild(label);

			var am:AssetManager=new AssetManager();
			am.enqueue("assets/common/hint-bg.png", "assets/common/hint-bg-large.png", "assets/common/hint-bg-mid.png", "assets/common/hint-bg-k.png", "assets/common/hint-bg-k-large.png", "assets/common/hint-bg-k-mid.png");
			am.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
					Prompt.addAssetManager(am);
			})
		}

		override protected function init():void
		{
//			testFont();
//			testUserCenter();
//			Map.show();
//			return;
			debugInit();
			Map.show();
		}

		private function debugInit():void
		{
			if (Capabilities.isDebugger)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
				{
					if (e.keyCode == Keyboard.ENTER)
					{
						if (testingModule)
						{
							removeChild(testingModule);
							testingModule=null;
						}
						else
						{
							testingModule=new testingModuleClass();
							addChild(testingModule);
						}
					}
					else if (e.keyCode == Keyboard.RIGHT)
					{
//						LionMC.instance.say(Math.random().toString());
						MC.instance.nextModule();
					}
				});
//				stage.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void
//				{
//					var t:Touch=e.getTouch(stage, TouchPhase.ENDED);
//					if (t)
//					{
//						var am:AssetManager=new AssetManager();
//						am.enqueue('assets/common/hint-bg.png');
//						am.loadQueue(function(ratio:Number):void
//						{
//							if (ratio == 1)
//							{
//								Prompt.addAssetManager(am);
//								Prompt.show(100, 100, '', 'test');
//							}
//						});
//					}
//				});
				return;
			}
		}

		private function testFont():void
		{
//			FeathersControl.defaultTextRendererFactory = function():TextFieldTextRenderer
//			{
//				var render:TextFieldTextRenderer = new TextFieldTextRenderer();
//				render.textFormat = new TextFormat(FontVo.PALACE_FONT,26, 0xffffff );
//				render.wordWrap = true;
//				return render;
//			};
//			FeathersControl.defaultTextRendererFactory = function():BitmapFontTextRenderer
//			{
//				var render:BitmapFontTextRenderer = new BitmapFontTextRenderer();
//				render.textFormat = new BitmapFontTextFormat(FontVo.PALACE_FONT,26, 0xffffff );
//				render.wordWrap = true;
//				return render;
//			};
//			
//			var label:Label = new Label();
//			label.width = 100;
//			label.text = "位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体";
//			label.textRendererProperties.wordWrap = true;
//			this.addChild( label );
//			label.x = 500;
//			label.y = 300;

			var t:TextField=new TextField(300, 200, "位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体", FontVo.PALACE_FONT, 18, 0xffffff);
			t.hAlign="left";
			this.addChild(t);
		}

		private function testUserCenter():void
		{
			UserCenterManager.userCenterContainer=this;
			UserCenterManager.showUserCenter();
		}
	}
}

