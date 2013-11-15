package views.global.userCenter.userInfo
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import controllers.MC;
	
	import models.SOService;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.Interlude;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 场景选择组件
	 * @author Administrator
	 */	
	public class ModuleList extends Sprite
	{
		public function ModuleList()
		{
			init();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var start:int;
		private var started:Boolean = false;
		private function onEnterFrame():void
		{
			if(started)
			{
				if(getTimer() - start >= 500)
				{
					activeIcon.texture = SKIN_ICON_SUN;
					started = false;
				}
			}
		}
		
		private const viewWidth:uint = 968;
		private const viewHeight:uint = 464;
		
		private var vecImage:Vector.<Image>;
		private const btnCount:uint = 8;
		private const center:Point = new Point(viewWidth/2, viewHeight+400);
		private const radius:uint = 800;
		private const d:Number = 0.14;
		private const minR:Number = -Math.PI/2 - 3.5*d;
		private const maxR:Number = minR + 7*d;
		private var activeIcon:Image;
		
		private var SKIN_VIDEO_UP:	Texture = UserCenterManager.getTexture("module_video_up");
		private var SKIN_VIDEO_DOWN:	Texture = UserCenterManager.getTexture("module_video_down");
		private var SKIN_MODULE_UP:	Texture = UserCenterManager.getTexture("module_start_up");
		private var SKIN_MODULE_DOWN:	Texture = UserCenterManager.getTexture("module_start_down");
		private var SKIN_ICON_SUN:	Texture = UserCenterManager.getTexture("drag_sun");
		
		
		private function init():void
		{
			initBackGround();
			initBtns();
			initActiveIcon();
		}		
		
		
		private function initActiveIcon():void
		{
			activeIcon = new Image(SKIN_VIDEO_UP);
			activeIcon.pivotX = activeIcon.width >> 1;
			activeIcon.pivotY = activeIcon.height >> 1;
			var str:String = SOService.instance.getSO("lastScene") as String;
			var i:int = 0;
			if( str && str != "end" )
			{
				i = str.charAt(0) as int;
				if(i != 0)
					activeIcon.texture = SKIN_MODULE_UP;
			}
			crtR = minR + i*d;
			this.addChild( activeIcon );
			activeIcon.addEventListener(TouchEvent.TOUCH, onTriggered);
		}
		
		private function onTriggered(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(activeIcon);
			var point:Point;
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						activeIcon.texture = (activeIcon.texture == SKIN_VIDEO_UP)?SKIN_VIDEO_DOWN:SKIN_MODULE_DOWN;
						started = true;
						start = getTimer();
						break;
					case TouchPhase.MOVED:
						point = touch.getLocation(activeIcon);
						if(!activeIcon.hitTest(point))
							started = false;
						if(activeIcon.texture == SKIN_ICON_SUN)
						{
							point = touch.getLocation(this);
							crtR = Math.min(maxR, Math.max(minR, Math.atan2(point.y-center.y, point.x-center.x)));
						}
						break;
					case TouchPhase.ENDED:
						started = false;
						var targetR:Number;
						if(activeIcon.texture == SKIN_ICON_SUN)
						{
							selectI = Math.floor( (crtR - minR)/d );
							if( crtR - (minR+selectI*d) >= crtR - (minR+(selectI+1)*d) )
								selectI += 1;
							for(var i:int = selectI;i>=0;i--)
							{
								if(isComplete(i))
								{
									selectI = i;
									break;
								}
							}
							targetR = minR + selectI*d;
							animationStart(targetR);
						}
						else
						{
							point = touch.getLocation(activeIcon);
							activeIcon.texture = (mapping[selectI].charAt(0) == "m")?SKIN_MODULE_UP:SKIN_VIDEO_UP;
							if(activeIcon.hitTest(point))
							{
								clickHandler();
							}
						}
						break;
				}
			}
		}
		
		private function clickHandler():void
		{
			if(selectI == 5)	return;
			var string:String = mapping[selectI];
			if(string.charAt(0) == "m")		//进入模块
				MC.instance.gotoModule(int(string.charAt(2)));
			else
				Starling.current.nativeStage.addChild(new Interlude(string));
		}
		
		private var selectI:int = 0;
		
		private function initBtns():void
		{
			var r:Number;
			var image:Image
			vecImage = new Vector.<Image>(btnCount);
			for(var i:int = 0;i<btnCount;i++)
			{
				r = minR+i*d;
				image = new Image( isComplete(i)?UserCenterManager.getTexture("button_"+i):UserCenterManager.getTexture("button_unFinish") );
				image.pivotX = image.pivotY = image.width >> 1;
				setPositionByRadian(image, r);
				this.addChild( image );
				vecImage[i] = image;
				image.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
		private const mapping:Array = [
			"assets/video/intro.mp4",
			"m_1",
			"m_2",
			"m_3",
			"m_4",
			"assets/video/garden.mp4",
			"m_5",
			"assets/video/end.mp4"
		];
		
		private function isComplete(i:int):Boolean
		{
			if(i==0)	return true;
			var str:String = mapping[i];
			var k:int = int( str.charAt(2) );
			if(str.charAt(0) == "m")		//模块
			{
				return SOService.instance.isModuleCompleted( k );
			}else
			{
				return isComplete(i-1);
			}
			return false;
		}
		
		private var _crtR:Number;
		public function set crtR(r:Number):void
		{
			if(_crtR == r)	return;
			_crtR = r;
			setPositionByRadian(activeIcon, _crtR);
		}
		public function get crtR():Number
		{
			return _crtR;
		}
		
		private function setPositionByRadian(obj:DisplayObject, r:Number):void
		{
			obj.x = center.x + radius * Math.cos( r );
			obj.y = center.y + radius * Math.sin( r );
		}
		
		private function initBackGround():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("userCenter_bg"));
			image.x = 185;
			image.y = 93;
			this.addChild( image );
			image.touchable = false;
		}
		
		private var startObj:Object;
		private function onTouch(e:TouchEvent):void
		{
			var i:int;
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				i = vecImage.indexOf( e.target as Image );
				if(!isComplete(i))
					return;
				selectI = i;
				var targetR:Number = minR + selectI*d;
				activeIcon.texture = SKIN_ICON_SUN;
				animationStart(targetR);
			}
		}
		
		private function animationStart(targetR:Number):void
		{
			TweenLite.to(this, 1, {crtR: targetR, ease: Cubic.easeOut, onComplete: function():void{
				activeIcon.texture = (mapping[selectI].charAt(0) == "m")?SKIN_MODULE_UP:SKIN_VIDEO_UP;
			}});
		}
		
		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for each(var image:Image in vecImage)
			{
				image.removeEventListener(TouchEvent.TOUCH, onTouch);
				image.removeFromParent(true);
			}
			if(activeIcon)
			{
				activeIcon.removeEventListener(TouchEvent.TOUCH, onTriggered);
				activeIcon.removeFromParent(true);
			}
			SKIN_ICON_SUN = SKIN_MODULE_DOWN = SKIN_MODULE_UP = SKIN_VIDEO_DOWN = SKIN_VIDEO_UP = null;
			super.dispose();
		}
	}
}