package controllers
{
	import com.pamakids.utils.Singleton;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import feathers.core.PopUpManager;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	import views.Module1;
	import views.Module2;
	import views.Module3;
	import views.Module4;
	import views.Module5;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.TopBar;
	import views.global.map.Map;
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

		private var _moduleIndex:int=-1;
		private var contentLayer:Sprite;
		public var currentModule:PalaceModule;

		public var main:Container;
		private var modules:Array=[Module1, Module2, Module3, Module4, Module5];

		public var stage:PalaceMuseum;
		private var topBarLayer:Sprite;

		public function init(main:Container):void
		{
			this.main=main;
			Prompt.parent=main;
			Map.parent=main;
			PopUpManager.root=main;
			UserCenterManager.userCenterContainer=main;
			PopUpManager.overlayFactory=function defaultOverlayFactory():starling.display.DisplayObject
			{
				const quad:Quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				return quad;
			};

			initLayers();
		}

		public function addChild(displayObject:flash.display.DisplayObject):void
		{
			stage.addChild(displayObject);
		}

		public function removeChild(displayObject:flash.display.DisplayObject):void
		{
			stage.removeChild(displayObject);
		}

		public function addMC(mc:MovieClip):void
		{
			stage.addChild(mc);
			mc.visible=(UserCenterManager.getCrtUserCenter() == null);
		}

		public function removeMC(mc:MovieClip):void
		{
			if (stage.contains(mc))
				stage.removeChild(mc);
		}

		public function hideMC():void
		{
			for (var i:int=0; i < MC.instance.stage.numChildren; i++)
			{
				var obj:flash.display.DisplayObject=stage.getChildAt(i);
				if (obj is MovieClip)
					obj.visible=false;
			}
		}

		public function showMC():void
		{
			for (var i:int=0; i < MC.instance.stage.numChildren; i++)
			{
				var obj:flash.display.DisplayObject=stage.getChildAt(i);
				if (obj is MovieClip)
					obj.visible=true;
			}
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

		public function gotoModule(index:int, sceneIndex:int=-1):void
		{
			_moduleIndex=index;
			showModule(sceneIndex);
		}

		public function clearCrtModule():void
		{
			if (currentModule)
			{
				currentModule.removeFromParent();
				currentModule.dispose();
				currentModule=null;
			}
		}

		private function showModule(index:int=-1):void
		{
			clearCrtModule();
			if (moduleIndex < 0)
				moduleIndex=0;
			currentModule=new modules[moduleIndex](index);
			contentLayer.addChild(currentModule);
			trace('load new module');
		}

		public function nextModule():void
		{
			if (moduleIndex < modules.length - 1)
				moduleIndex++;
			else
				moduleIndex=0;
		}

		public function preModule():void
		{
			if (moduleIndex > 0)
				moduleIndex--;
		}

		private function initLayers():void
		{
			contentLayer=new Sprite();
			topBarLayer=new Sprite();
			main.addChild(contentLayer);
			main.addChild(topBarLayer);
			TopBar.parent=topBarLayer;
		}

		public function set contentEnable(value:Boolean):void
		{
			contentLayer.touchable=value;
		}
	}
}
