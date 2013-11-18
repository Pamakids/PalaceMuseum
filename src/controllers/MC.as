package controllers
{
	import com.greensock.TweenMax;
	import com.pamakids.manager.SoundManager;
	import com.pamakids.utils.Singleton;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import feathers.core.PopUpManager;

	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	import views.Interlude;
	import views.Module1;
	import views.Module2;
	import views.Module3;
	import views.Module4;
	import views.Module5;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.TailBar;
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
//			SoundManager.instance.init("json/sound.json");
			SoundAssets.init();
		}

		private var _moduleIndex:int=-1;
		private var contentLayer:Sprite;
		public var currentModule:PalaceModule;

		public var main:Container;
		private var modules:Array=[Module1, Module2, Module3, Module4, Module5];

		public var stage:PalaceMuseum;
		public var topBarLayer:Sprite;
		private var centerLayer:Sprite;
		private var mapLayer:Sprite;

		public function init(main:Container):void
		{
			this.main=main;
			Prompt.parent=main;
			PopUpManager.root=main;
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
				Map.show(null, _moduleIndex, value);
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
			UserCenterManager.closeUserCenter();
			if (Map.map)
				Map.map.clear(0);
		}

		public function clearCrtModule():void
		{
			TweenMax.killAll();
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
			{
				moduleIndex++;
			}
			else //gameover
			{
				main.touchable=false;
				removeAllMC();
				if (Map.map)
					Map.map.clear(1);
				TopBar.hide();
				TailBar.hide();
				clearCrtModule();
				LionMC.instance.hide();
				SOService.instance.setSO("lastScene", "end");
				var end:Interlude=new Interlude("assets/video/end.mp4", false, null, onEnd);
				Starling.current.nativeStage.addChild(end);
				SoundManager.instance.stopAll();
			}
		}

		private function removeAllMC():void
		{
			for (var i:int=0; i < stage.numChildren; i++)
			{
				var d:flash.display.DisplayObject=stage.getChildAt(i);
				if (d is MovieClip)
					stage.removeChild(d);
			}

		}

		private function onEnd():void
		{
			restart();
		}

		public static var assetManager:AssetManager;

		public function restart():void
		{
			main.touchable=false;
			removeAllMC();
			if (Map.map)
				Map.map.clear(1);
			clearCrtModule();
//			LionMC.instance.hide();

			UserCenterManager.closeUserCenter();

			SOService.instance.init();
//			LionMC.instance.show();
			_moduleIndex=-1;
			TopBar.hide();
			TailBar.hide();
			main.touchable=true;
			main.restart();
		}

		public function preModule():void
		{
			if (moduleIndex > 0)
				moduleIndex--;
		}

		private function initLayers():void
		{
			contentLayer=new Sprite();
			centerLayer=new Sprite();
			mapLayer=new Sprite();
			topBarLayer=new Sprite();

			main.addChild(contentLayer);
			main.addChild(centerLayer);
			main.addChild(mapLayer);
			main.addChild(topBarLayer);

			UserCenterManager.userCenterContainer=centerLayer;
			Map.parent=mapLayer;
			TopBar.parent=topBarLayer;
			TailBar._parent=topBarLayer;
		}

		public function set contentEnable(value:Boolean):void
		{
			contentLayer.touchable=value;
		}

		public function switchLayer(isMap:Boolean):void
		{
			var index1:int=main.getChildIndex(centerLayer);
			var index2:int=main.getChildIndex(mapLayer);
			var i1:int=Math.min(index1, index2);
			var i2:int=Math.max(index1, index2);
			if (isMap)
			{
				main.setChildIndex(centerLayer, i1);
				main.setChildIndex(mapLayer, i2);
			}
			else
			{
				main.setChildIndex(mapLayer, i1);
				main.setChildIndex(centerLayer, i2);
				UserCenterManager.enable();
			}
		}

		public function switchWOTB():void
		{
			var index1:int=main.getChildIndex(centerLayer);
			var index2:int=main.getChildIndex(mapLayer);
			var i1:int=Math.min(index1, index2);
			var i2:int=Math.max(index1, index2);
			main.setChildIndex(centerLayer, i1);
			main.setChildIndex(mapLayer, i2);
		}
	}
}
