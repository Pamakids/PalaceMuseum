package controllers
{
	import com.greensock.TweenMax;
	import com.pamakids.utils.Singleton;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.EndScene;
	import views.Interlude;
	import views.Module1;
	import views.Module2;
	import views.Module3;
	import views.Module4;
	import views.Module5;
	import views.Module6;
	import views.components.LionMC;
	import views.components.PalaceGuide;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.TailBar;
	import views.global.TopBar;
	import views.global.books.BooksManager;
	import views.global.map.Map;
	import views.global.other.Menu;

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
		}

		/**
		 * 是否需要新手引导
		 * */
		public static var needGuide:Boolean=false;

		public static var isIOS:Boolean;

		private var _moduleIndex:int=-1;
		private var contentLayer:starling.display.Sprite;
		public var currentModule:PalaceModule;

		public var main:Container;
		private var modules:Array=[Module1,Module6, Module2, Module3, Module4, Module5];

		public var stage:PalaceMuseum;
		public var topBarLayer:starling.display.Sprite;
		private var bookLayer:starling.display.Sprite;
		private var mapLayer:starling.display.Sprite;

		public function init(main:Container):void
		{
			this.main=main;
			Prompt.parent=main;
			PopUpManager.root=main;
			PopUpManager.overlayFactory=function defaultOverlayFactory():starling.display.DisplayObject
			{
				const quad:Quad=new Quad(1024, 768, 0);
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
			mcLayer.addChild(mc);
//			mc.visible=(BooksManager.getCrtUserCenter() == null);
		}

		public function removeMC(mc:MovieClip):void
		{
			if (mcLayer.contains(mc))
				mcLayer.removeChild(mc);
		}

		public var mcLayer:flash.display.Sprite;

		public function hideMC():void
		{
			mcLayer.visible=false;
//			for (var i:int=0; i < mcLayer.numChildren; i++)
//			{
//				var obj:flash.display.DisplayObject=mcLayer.getChildAt(i);
//				if (obj is MovieClip)
//					obj.visible=false;
//			}
		}

		public function showMC():void
		{
			mcLayer.visible=true;
//			for (var i:int=0; i < mcLayer.numChildren; i++)
//			{
//				var obj:flash.display.DisplayObject=stage.getChildAt(i);
//				if (obj is MovieClip)
//					obj.visible=true;
//			}
		}

		public function get moduleIndex():int
		{
			return _moduleIndex;
		}

		public function set moduleIndex(value:int):void
		{
			if (currentModule){
//				var capture:Texture=currentModule.getCapture();
				currentModule.visible=false;
//				clearCrtModule();
			}
			if (value != _moduleIndex)
			{
				DC.instance.completeModule();
				Map.loadMapAssets(function():void{
					Map.show(_moduleIndex, value);
				},true);
//				Map.show(null, _moduleIndex, value);
			}
			else
			{
				_moduleIndex=value;
				showModule();
			}
		}

		public function gotoModule(index:int, sceneIndex:int=-1):void
		{
			MC.instance.hideMenu();
			BooksManager.closeCtrBook();
			if (Map.map)
				Map.map.clear(0);
			TopBar.hide();
			TailBar.hide();
			_moduleIndex=index;
			showModule(sceneIndex);
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
				if(MC.isIOS){
					var end:Interlude=new Interlude(1, true, null, onEnd);
					stage.addChild(end);
				}
				else
					onEnd();
//				Starling.current.nativeStage.addChild(end);
				SoundManager.instance.stopAll();
			}
		}

		private function removeAllMC():void
		{
			mcLayer.removeChildren();
//			for (var i:int=stage.numChildren - 1; i >= 0; i--)
//			{
//				var d:flash.display.DisplayObject=stage.getChildAt(i);
//				if (d is MovieClip)
//					stage.removeChild(d);
//			}
		}

		private function onEnd():void
		{
			main.touchable=false;
			removeAllMC();
			if (Map.map)
				Map.map.clear(1);
			clearCrtModule();
			BooksManager.closeCtrBook();
			_moduleIndex=-1;
			TopBar.hide();
			TailBar.hide();
			main.touchable=true;

			var fin:EndScene=new EndScene(restart);
			main.addChild(fin);
		}

		public static var assetManager:AssetManager;

		public function restart():void
		{
			hideMenu();
			main.touchable=false;
			removeAllMC();
			if (Map.map)
				Map.map.clear(1);
			clearCrtModule();
			BooksManager.closeCtrBook();
			SOService.instance.init();
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
			contentLayer=new starling.display.Sprite();
			bookLayer=new starling.display.Sprite();
			mapLayer=new starling.display.Sprite();
			topBarLayer=new starling.display.Sprite();

			main.addChild(contentLayer);
			main.addChild(bookLayer);
			main.addChild(mapLayer);
			main.addChild(topBarLayer);

			BooksManager.userCenterContainer=bookLayer;
			Map.parent=mapLayer;
			TopBar.parent=topBarLayer;
			TailBar._parent=topBarLayer;

			contentLayer.addEventListener(TouchEvent.TOUCH, onHideTopBar);
			mapLayer.addEventListener(TouchEvent.TOUCH, onHideTopBar);
			bookLayer.addEventListener(TouchEvent.TOUCH, onHideTopBar);
		}

		private function onHideTopBar(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(e.currentTarget as starling.display.DisplayObject, TouchPhase.ENDED);
			if (!tc)
				return;
			TopBar.instance.hideBookAndAvatar();
		}

		public function set contentEnable(value:Boolean):void
		{
			contentLayer.touchable=value;
		}

		public function switchLayer(isMap:Boolean):void
		{
			var index1:int=main.getChildIndex(bookLayer);
			var index2:int=main.getChildIndex(mapLayer);
			var i1:int=Math.min(index1, index2);
			var i2:int=Math.max(index1, index2);
			if (isMap)
			{
				main.setChildIndex(bookLayer, i1);
				main.setChildIndex(mapLayer, i2);
			}
			else
			{
				main.setChildIndex(mapLayer, i1);
				main.setChildIndex(bookLayer, i2);
				BooksManager.enable();
			}
		}

		public function switchWOTB():void
		{
			var index1:int=main.getChildIndex(bookLayer);
			var index2:int=main.getChildIndex(mapLayer);
			var i1:int=Math.min(index1, index2);
			var i2:int=Math.max(index1, index2);
			main.setChildIndex(bookLayer, i1);
			main.setChildIndex(mapLayer, i2);
		}

		/**
		 * 检查MC.needGuide / 流程结束后设为true
		 * @param index 引导索引
		 * @param cb 回调
		 */
		public function addGuide(index:int, cb:Function):void
		{
			var guide:PalaceGuide=new PalaceGuide(index, cb);
			main.addChild(guide);
		}

		public function showMenu():void
		{
			if(!menu)
				menu = new Menu();
			main.addChildAt( menu,main.getChildIndex(topBarLayer)-1 );
		}
		private var menu:Menu;
		public function hideMenu():void
		{
			if(menu)
			{
				menu.removeFromParent(true);
				menu = null
			}
		}

		public static function isFinished():Boolean
		{
			return SOService.instance.getSO("finished");
		}
	}
}


