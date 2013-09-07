package
{
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	import controllers.MC;

	import models.Const;

	import starling.display.Sprite;
	import starling.events.KeyboardEvent;

	import views.Module3;
	import views.components.base.Container;
	import views.global.Map;
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
						testUserCenter();
			//			Map.show();
						return;
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
//				Map.show();
				MC.instance.moduleIndex=2;
			}
		}

		private function testUserCenter():void
		{
			UserCenterManager.userCenterContainer=this;
			UserCenterManager.showUserCenter();
		}
	}
}

