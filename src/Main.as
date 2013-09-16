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

	import views.Module3;
	import views.components.base.Container;
	import views.global.map.Map;
	import views.global.userCenter.UserCenterManager;

	public class Main extends Container
	{
		private var testingModule:Sprite;
		private var testingModuleClass:Class;

		public function Main()
		{
			super(Const.WIDTH, Const.HEIGHT);
			scaleX=scaleY=scale;
			MC.instance.init(this);
		}

		override protected function init():void
		{
//			testFont();
//			testUserCenter();
//			Map.show();
//			return;
			if (Capabilities.isDebugger && testingModuleClass)
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
				});
				return;
			}
			else
			{
				Map.show();
//				MC.instance.moduleIndex=0;
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

			var t:TextField=new TextField(300, 200, "位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体位图字体", FontVo.PALACE_FONT, 26, 0xffffff);
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

