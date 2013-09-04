package controllers
{
	import com.pamakids.utils.Singleton;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	import views.Module1;
	import views.Module2;
	import views.components.Prompt;
	import views.components.base.PalaceModule;
	import views.global.Map;
	import views.global.TopBar;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 主业务控制器
	 * @author mani
	 */
	public class MC extends Singleton
	{

		public static function get instance():MC
		{
			return Singleton.getInstance(MC);
		}

		public function MC()
		{
			super();
		}

		private var _moduleIndex:int;
		private var contentLayer:Sprite;
		private var crtModule:PalaceModule;
		private var currentModule:PalaceModule;

		private var main:Main;
		private var modules:Array=[Module1, Module2]

		public function init(main:Main):void
		{
			this.main=main;
			Prompt.parent=main;
			Map.parent=main;
			PopUpManager.root=main;
			TopBar.parent=main;
			UserCenterManager.userCenterContainer=main;
			PopUpManager.overlayFactory=function defaultOverlayFactory():DisplayObject
			{
				const quad:Quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				return quad;
			};

			initLayers();
		}

		public function get moduleIndex():int
		{
			return _moduleIndex;
		}

		public function set moduleIndex(value:int):void
		{
			if (currentModule)
				currentModule.visible=false;
			if (value != _moduleIndex)
			{
				DC.instance.completeModule();
				Map.show(function(status:int):void
				{
					if (!status)
					{
						_moduleIndex=value;
						showModule();
					}
				}, _moduleIndex, value);
			}
			else
			{
				_moduleIndex=value;
				showModule();
			}
		}

		public function gotoModule(index:int):void
		{
			_moduleIndex=index;
			showModule();
		}

		private function showModule():void
		{
			if (currentModule)
				currentModule.removeFromParent(true);
			currentModule=new modules[moduleIndex];
			contentLayer.addChild(currentModule);
			trace('load new module');
		}

		public function nextModule():void
		{
			if (moduleIndex < modules.length - 1)
				moduleIndex++;
		}

		public function preModule():void
		{
			if (moduleIndex > 0)
				moduleIndex--;
		}

		private function initLayers():void
		{
			contentLayer=new Sprite();
			main.addChild(contentLayer);
		}
	}
}
