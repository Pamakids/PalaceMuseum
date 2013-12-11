package views.components
{
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import controllers.MC;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.Container;

	/**
	 *
	 * @author Administrator
	 */
	public class PalaceGuide extends Container
	{
		/**
		 *
		 * @default
		 */
		public static var assetManager:AssetManager;

		private static var dataG:Object;
		private var data:Object;
		private var callBack:Function;
		private var index:int;

		private var arrow:Image;
		private var hand:Image;
		private var handPos:Point;
		private var type:int;
		private var arrowR:Number;
		private var area:Rectangle;

		/**
		 * 检查MC.needGuide / 流程结束后设为true
		 * @param _index 引导索引
		 * @param cb 回调
		 */
		public function PalaceGuide(_index:int, cb:Function)
		{
			index=_index;
			callBack=cb;

			data=dataG[index - 1];

			type=data.action;
			arrowR=getRotationFromDegree(data.arrowAngle);

			initBG();
			initArrow();
			initHand();
			initArea();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, type == 0 ? touchHandler1 : touchHandler2);

			MC.instance.main.touchable=true;
		}

		private var dpt:Point;

		private function touchHandler1(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					if (area.containsPoint(pt))
						dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if (area.containsPoint(pt) && dpt)
						exceed();
					dpt=null;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function exceed():void
		{
			callBack();
			this.removeFromParent(true);
			MC.instance.main.touchable=false;
		}

		private function touchHandler2(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					if (area.containsPoint(pt))
						dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if (dpt && (dpt.x - pt.x > 10))
						exceed();
					dpt=null;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function initBG():void
		{
			var bg:Image=getImage("mask" + index);
			addChild(bg);
		}

		private function initArrow():void
		{
			var sp:Sprite=new Sprite();
			arrow=getImage("arrow");
			arrow.pivotX=arrow.width >> 1;
			arrow.pivotY=arrow.height >> 1;
			var pos:Point=getPointFromArray(data.arrowPos);
			trace(pos)
			sp.x=pos.x;
			sp.y=pos.y;
			sp.rotation=arrowR;

			addChild(sp);
			sp.addChild(arrow);
		}

		private function initHand():void
		{
			if (data.hand == "T")
			{
				hand=getImage("hand");
				addChild(hand);
				handPos=getPointFromArray(data.handPos);
				hand.x=handPos.x;
				hand.y=handPos.y;
				hand.touchable=false;
			}
		}

		private function initArea():void
		{
			area=getRectFromArray(data.area);
			trace(area)
		}

		/**
		 *
		 * @param d
		 * @return
		 */
		public static function getRotationFromDegree(d:Number):Number
		{
			return d / 180 * Math.PI
		}

		/**
		 *
		 * @param arr
		 * @return
		 */
		public static function getPointFromArray(arr:Array):Point
		{
			return new Point(arr[0], arr[1]);
		}

		/**
		 *
		 * @param arr
		 * @return
		 */
		public static function getRectFromArray(arr:Array):Rectangle
		{
			return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
		}

		private function onEnterFrame(e:Event):void
		{
			if (arrow.x > 30)
			{
				arrow.x=30
				arrow.scaleX=arrow.scaleY=1;
			}
			else if (arrow.x < 0)
			{
				arrow.x=0
				arrow.scaleX=arrow.scaleY=.99;
			}
			arrow.x+=arrow.scaleX == 1 ? -1 : 1;

			if (hand && handPos)
			{
				if (hand.x == handPos.x - 120)
					hand.scaleX=hand.scaleY=1;
				else if (hand.x == handPos.x)
					hand.scaleX=hand.scaleY=.8;
				hand.x+=hand.scaleX == 1 ? 5 : -5;
			}
		}

		/**
		 *
		 */
		public static function init(cb:Function=null):void
		{
			var am:AssetManager=new AssetManager();
			var f:File=File.applicationDirectory.resolvePath("assets/guide");
			am.enqueue(f);
			am.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0) {
					assetManager=am;
					dataG=assetManager.getObject("guide").guide;
					if (cb)
						cb();
				}
			});
		}

		/**
		 *
		 */
		public static function disposeAll():void
		{
			if (assetManager)
				assetManager.purge();
			dataG=null;
			assetManager=null;
			MC.instance.main.touchable=true;
			MC.needGuide=false;
		}

		/**
		 *
		 * @param src
		 * @return
		 */
		public static function getImage(src:String):Image
		{
			return new Image(assetManager.getTexture(src));
		}

	}
}
