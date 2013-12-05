package views.global.books.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import controllers.MC;
	
	import models.SOService;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.Interlude;
	import views.components.ElasticButton;
	import views.global.books.BooksManager;
	import views.global.map.Map;

	/**
	 * 场景选择组件
	 * @author Administrator
	 */
	public class ModuleList extends Sprite
	{
		public function ModuleList()
		{
			init();
		}

		private var moving:Boolean=false;

		private const viewWidth:uint=968;
		private const viewHeight:uint=464;

		private var vecImage:Vector.<Image>;
		private const btnCount:uint=8;
		private const center:Point=new Point(viewWidth / 2, viewHeight + 400);
		private const radius:uint=800;
		private const d:Number=0.14;
		private const minR:Number=-Math.PI / 2 - 3.5 * d;
		private const maxR:Number=minR + 7 * d;
		private var activeIcon:Image;

		private var SKIN_ICON_SUN:Texture=BooksManager.getTexture("drag_sun");

		private function init():void
		{
			initBackGround();
			initLines();
			initWords();
			initBtns();
			initActiveIcon();
			initPlayBtn();
		}

		private var play:ElasticButton;

		private function initPlayBtn():void
		{
			play=new ElasticButton(BooksManager.getImage("btn_play"));
			addChild(play);
			play.x=centerS.x + 4;
			play.y=centerS.y + 3;
			play.addEventListener(ElasticButton.CLICK, onPlay);
		}

		private function onPlay():void
		{
			clickHandler();
		}

		private var crtScene:int;
		private var crtModule:int;
		private var fromMap:Boolean;

		private function initActiveIcon():void
		{
			activeIcon=new Image(SKIN_ICON_SUN);
			activeIcon.pivotX=activeIcon.width >> 1;
			activeIcon.pivotY=activeIcon.height >> 1;
			var str:String=SOService.instance.getSO("lastScene") as String;
			crtScene=int(str.charAt(1));
			crtModule=int(str.charAt(0));
			fromMap=str.indexOf("map") >= 0;
			var i:int=0;
			if (str && str != "end")
			{
				i=crtModule;
			}
			if (i >= 4) //御花园之后
			{
				if (i == 4)
				{
					if (crtScene >= 3) //御花园	
						i+=1;
				}
				else
				{
					i+=1;
				}
			}
			this.addChild(activeIcon);
			crtR=minR + i * d;
			selectI=i;
			activeIcon.addEventListener(TouchEvent.TOUCH, onTriggered);
		}

		private function onTriggered(e:TouchEvent):void
		{
			if (moving)
				return;
			var touch:Touch=e.getTouch(activeIcon);
			var point:Point;
			if (touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						play.visible=false;
						break;
					case TouchPhase.MOVED:
						point=touch.getLocation(this);
						crtR=Math.min(maxR, Math.max(minR, Math.atan2(point.y - center.y, point.x - center.x)));
						break;
					case TouchPhase.ENDED:
						var targetR:Number;
						selectI=Math.round((crtR - minR) / d);
						for (var i:int=selectI; i >= 0; i--)
						{
							if (isComplete(i))
							{
								selectI=i;
								break;
							}
						}
						targetR=minR + selectI * d;
						animationStart(targetR);
						break;
				}
			}
		}

		private function gotoModule(module:int, screen:int):void
		{
			if (MC.instance.currentModule && MC.instance.currentModule.crtScene)
			{
				var ms:String=MC.instance.currentModule.crtScene.sceneName;
				var m:int=int(ms.charAt(5));
				var s:int=int(ms.charAt(6));
				trace(m, s)
				if (m - 1 == module)
				{
					BooksManager.closeCtrBook();
				}
				else
				{
					MC.instance.gotoModule(module, screen);
				}
			}
			else
			{

			}
		}

		private function clickHandler():void
		{
			var string:String=mapping[selectI];
			if (string.charAt(0) == "m") //进入模块
			{
				var module:int=int(string.charAt(2));
				var screen:int=int(string.charAt(4)) - 1;
				if (crtModule - 1 == module) //目标模块与当前模块相同
				{
					if (fromMap)
					{
						if (!Map.map)
							Map.show(null, module - 1, module);
						BooksManager.closeCtrBook();
						return;
					}
					if (module == 3)
					{
						if (screen <= 0) //去模块4
						{
							if (crtScene - 1 >= 3)
							{
								MC.instance.gotoModule(module, Math.max(crtScene - 1, screen));
							}
							else
							{
								if (MC.instance.currentModule)
								{
									BooksManager.closeCtrBook();
								}
								else
								{
									MC.instance.gotoModule(module, Math.max(crtScene - 1, screen));
								}
							}
						}
						else //去御花园
						{
							if (crtScene - 1 < 3) //当前处在非御花园区域
							{
								MC.instance.gotoModule(module, Math.max(crtScene - 1, screen));
							}
							else
							{
								if (MC.instance.currentModule)
								{
									BooksManager.closeCtrBook();
								}
								else
								{
									MC.instance.gotoModule(module, Math.max(crtScene - 1, screen));
								}
							}
						}
					}
					else
					{
						if (MC.instance.currentModule)
							BooksManager.closeCtrBook();
						else
							MC.instance.gotoModule(module, Math.max(crtScene - 1, screen));
					}
				}
				else
				{
					MC.instance.gotoModule(module, screen);
				}
			}
			else
			{
				Starling.current.nativeStage.addChild(new Interlude(string));
			}
			//			if (string.charAt(0) == "m") //进入模块
			//			{
			//				if(module == 3)		//御花园
			//				{
			//					if(screen == 3)
			//					{
			//						if( module == MC.instance.moduleIndex && MC.instance.currentModule && int(MC.instance.currentModule.crtScene.sceneName.charAt(-1))>=3 )
			//						{
			//							BooksManager.closeCtrBook();
			//							return;
			//						}
			//						MC.instance.gotoModule(module, screen);
			//					}else
			//					{
			//						if( module == MC.instance.moduleIndex && MC.instance.currentModule && int(MC.instance.currentModule.crtScene.sceneName.charAt(-1))<3 )
			//						{
			//							BooksManager.closeCtrBook();
			//							return;
			//						}
			//						Map.show(null, module-1, module, true, true);
			//					}
			//					return;
			//				}
			//				if(module == MC.instance.moduleIndex && MC.instance.currentModule)
			//					BooksManager.closeCtrBook();
			//				else
			//					MC.instance.gotoModule(module, screen);
			//			}
			//			else
			//				Starling.current.nativeStage.addChild(new Interlude(string));
		}


		private var selectI:int=0;

		private function initBtns():void
		{
			var r:Number;
			var image:Image
			vecImage=new Vector.<Image>(btnCount);
			for (var i:int=0; i < btnCount; i++)
			{
				r=minR + i * d;
				image=isComplete(i) ? BooksManager.getImage("button_" + i) : BooksManager.getImage("button_unFinish");
				image.pivotX=image.pivotY=image.width >> 1;
				setPositionByRadian(image, r);
				this.addChild(image);
				vecImage[i]=image;
				image.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}

		private const mapping:Array=[
			"assets/video/intro.mp4",
			"m_0_0",
			"m_1_0",
			"m_2_0",
			"m_3_0",
			"m_3_3",
			"m_4_0",
			"assets/video/end.mp4"
			];

		private function isComplete(i:int):Boolean
		{
//						return true;
			if (i == 0)
				return true;
			var str:String=mapping[i];
			var k:int=int(str.charAt(2));
			if (str.charAt(0) == "m") //模块
			{
				return SOService.instance.isModuleCompleted(k);
			}
			else
			{
				return isComplete(i - 1);
			}
			return false;
		}

		private var _crtR:Number;

		public function set crtR(r:Number):void
		{
			if (_crtR == r)
				return;
			_crtR=r;
			setPositionByRadian(activeIcon, _crtR);
		}

		public function get crtR():Number
		{
			return _crtR;
		}

		private function setPositionByRadian(obj:DisplayObject, r:Number):void
		{
			obj.x=center.x + radius * Math.cos(r);
			obj.y=center.y + radius * Math.sin(r);
		}

		private function initBackGround():void
		{
			var image:Image=BooksManager.getImage("userCenter_bg");
			image.x=185;
			image.y=93;
			this.addChild(image);
			image.touchable=false;

			image=BooksManager.getImage("bg_sundial");
			image.x=386;
			image.y=246;
			this.addChild(image);
			image.touchable=false;

			pointer=new Quad(66, 4, 0x0);
			pointer.alpha=.4;
			pointer.pivotY=pointer.height >> 1;
			pointer.x=centerS.x;
			pointer.y=centerS.y;
			this.addChild(pointer);
			pointer.touchable=false;
			pointer.rotation=arrR[selectI];

			image=BooksManager.getImage("focus_0");
			image.x=445;
			image.y=238;
			this.addChild(image);
			image.touchable=false;
		}

		private var centerS:Point=new Point(482, 332);
		private const arrR:Array=[
			-Math.PI / 2,
			-10 * Math.PI / 180,
			1 * Math.PI / 180,
			20 * Math.PI / 180,
			50 * Math.PI / 180,
			140 * Math.PI / 180,
			158 * Math.PI / 180,
			-Math.PI / 2 + 2 * Math.PI
			];
		private var pointer:Quad;

		private const wordPosition:Array=[
			new Point(135, 199),
			new Point(222, 160),
			new Point(321, 128),
			new Point(419, 112),
			new Point(512, 113),
			new Point(596, 128),
			new Point(695, 157),
			new Point(768, 196)
			];
		private const linePosition:Array=[
			new Point(141, 123),
			new Point(238, 82),
			new Point(356, 59),
			new Point(452, 57),
			new Point(568, 60),
			new Point(688, 82),
			new Point(791, 128)
			];

		private function initLines():void
		{
			var image:Image;
			var point:Point;
			for (var i:int=0; i < linePosition.length; i++)
			{
				point=linePosition[i];
				image=BooksManager.getImage(isComplete(i + 1) ? "line_complete_" + i : "line_uncomplete_" + i);
				image.touchable=false;
				image.x=point.x;
				image.y=point.y;
				this.addChild(image);
			}
		}

		private function initWords():void
		{
			var image:Image;
			var point:Point;
			for (var i:int=0; i < wordPosition.length; i++)
			{
				point=wordPosition[i];
				image=BooksManager.getImage(isComplete(i) ? "word_complete_" + i : "word_uncomplete_" + i);
				image.touchable=false;
				image.x=point.x;
				image.y=point.y;
				this.addChild(image);
			}
		}

		private var startObj:Object;

		private function onTouch(e:TouchEvent):void
		{
			var i:int;
			var touch:Touch=e.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				i=vecImage.indexOf(e.target as Image);
				if (!isComplete(i))
					return;
				play.visible = false;
				selectI=i;
				var targetR:Number=minR + selectI * d;
				activeIcon.texture=SKIN_ICON_SUN;
				animationStart(targetR);
			}
		}

		private function animationStart(targetR:Number):void
		{
			moving=true;
			TweenLite.to(this, 1, {crtR: targetR, ease: Cubic.easeOut, onComplete: function():void {
				moving=false;
				play.visible=true;
			}});
			var tarR:Number=arrR[selectI];
			TweenLite.to(pointer, 1, {rotation: tarR, ease: Cubic.easeOut});
		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			if(play)
				play.removeFromParent(true);
			
			for each (var image:Image in vecImage)
			{
				image.removeEventListener(TouchEvent.TOUCH, onTouch);
				image.removeFromParent(true);
			}
			if (activeIcon)
			{
				activeIcon.removeEventListener(TouchEvent.TOUCH, onTriggered);
				activeIcon.removeFromParent(true);
			}
			SKIN_ICON_SUN=null;
			super.dispose();
		}
	}
}
