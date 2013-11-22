package views.module2.scene22
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class ThermoMeter extends PalaceGame
	{
		private var mecury:Sprite;

		private var itemArr:Array=[];

		private var lineX:Number=231;
		private var lineYArr:Array=[225, 316, 415, 528, 592];
		private var lineLengthArr:Array=[94, 219, 56, 198, 78];

		private var circlePosArr:Array=[new Point(320, 130), new Point(445, 233),
										new Point(281, 339), new Point(421, 430), new Point(300, 536)];

		private var lightArr:Array=[];

		private var itemsPosArr:Array=[new Point(835, 160), new Point(673, 661),
									   new Point(691, 298), new Point(715, 0), new Point(804, 435)];
		private var itemsStrArr:Array=["snowman", "ice", "body", "tea", "boiling"];

		private var itemsArr:Array=[];

		private var tempArr:Array=[-20, 0, 37, 70, 100];
		private var hotAreaArr:Array=[new Rectangle(329, 139, 135, 130), new Rectangle(471, 268, 145, 134),
									  new Rectangle(287, 346, 151, 125), new Rectangle(454, 439, 135, 136), new Rectangle(308, 569, 143, 135)];

		private var offsetsArr:Array=[new Point(22, -12), new Point(20, -16),
									  new Point(40, 14), new Point(-13, 53), new Point(31, -12)];

		public function ThermoMeter(am:AssetManager=null)
		{
			super(am);

			itemsPosArr.reverse();
			itemsStrArr.reverse();
			tempArr.reverse();

			addBG();

			contentHolder=new Sprite();
			addChild(contentHolder);

			addLines();
			addLights();
			addCircles();

			addThermo();
			addItems();

			addClose();
		}

		private function addItems():void
		{
			itemHolder=new Sprite();
			contentHolder.addChild(itemHolder);
			for (var i:int=0; i < itemsStrArr.length; i++)
			{
				var item:Sprite=new Sprite();
				item.addChild(getImage("thermo-" + itemsStrArr[i]));
				var shadow:Image=getImage("thermo-" + itemsStrArr[i] + "-shadow");
				shadow.x=item.x=itemsPosArr[i].x;
				shadow.y=item.y=itemsPosArr[i].y;
				itemHolder.addChild(shadow);
				itemHolder.addChild(item);
				item.addEventListener(TouchEvent.TOUCH, onItemTouch);
				itemArr.push(item);
			}
		}

		private function onItemTouch(e:TouchEvent):void
		{
			var item:Sprite=e.currentTarget as Sprite;
			if (!item)
				return;
			var tc:Touch=e.getTouch(item);
			if (!tc)
				return;

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					TweenLite.killTweensOf(item);
					itemHolder.setChildIndex(item, itemHolder.numChildren - 1);
					break;
				}

				case TouchPhase.MOVED:
				{
					var move:Point=tc.getMovement(this);
					item.x+=move.x;
					item.y+=move.y;
					break;
				}

				case TouchPhase.ENDED:
				{
					var pt:Point=tc.getLocation(this);
					check(pt, item);
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function check(pt:Point, item:Sprite):void
		{
			var match:Boolean=false;
			for (var i:int=0; i < hotAreaArr.length; i++)
			{
				var rect:Rectangle=hotAreaArr[i];
				var index:int=itemArr.indexOf(item);
				if (rect.containsPoint(pt) && index == i)
				{
					item.removeEventListener(TouchEvent.TOUCH, onItemTouch);
					TweenLite.to(item, .5, {x: rect.x + offsetsArr[index].x, y: rect.y + offsetsArr[index].y, scaleX: .7, scaleY: .7});
					var light:Sprite=lightArr[index];
					TweenLite.to(light.clipRect, .5, {x: 0, onComplete: function():void {
						temp=tempArr[index];
						count++;
					}});
					return;
				}
			}
			TweenLite.to(item, .5, {x: itemsPosArr[index].x, y: itemsPosArr[index].y});
		}

		private function addThermo():void
		{
			var thermo:Image=getImage("thermo");
			thermo.x=152;
			thermo.y=19;
			contentHolder.addChild(thermo);

			mecury=new Sprite();
			mecury.addChild(getImage("thermo-mercury"));
			mecury.x=172;
			mecury.y=169;
			mecury.clipRect=new Rectangle(0, 454, 6, 454);
			contentHolder.addChild(mecury);
		}

		private function addLines():void
		{
			for (var i:int=0; i < lineYArr.length; i++)
			{
				var line:Sprite=new Sprite();
				line.addChild(getImage("thermo-line"));
				line.clipRect=new Rectangle(0, 0, lineLengthArr[i] + 7, 15);
				line.x=lineX;
				line.y=lineYArr[i];
				contentHolder.addChild(line);
			}
		}

		private function addLights():void
		{
			for (var i:int=0; i < lineYArr.length; i++)
			{
				var x1:Number=lineX;
				var y1:Number=lineYArr[i];
				var x2:Number=circlePosArr[i].x;
				var y2:Number=circlePosArr[i].y;
				var light:Sprite=new Sprite();

				var linelight:Sprite=new Sprite();
				linelight.addChild(getImage("thermo-light"));
				linelight.clipRect=new Rectangle(0, 0, lineLengthArr[i] + 2, 15);
				linelight.x=0;
				linelight.y=y1 - y2;
				light.addChild(linelight);

				var circlelight:Image=getImage("thermo-halo");
				circlelight.x=x2 - x1;
				circlelight.y=0;
				light.addChild(circlelight);

				light.x=x1;
				light.y=y2;
				light.clipRect=new Rectangle(light.width, 0, light.width, light.height);
				contentHolder.addChild(light);
				lightArr.push(light);
			}
		}

		private function addCircles():void
		{
			for (var i:int=0; i < circlePosArr.length; i++)
			{
				var circle:Image=getImage("thermo-pan");
				circle.x=circlePosArr[i].x;
				circle.y=circlePosArr[i].y;
				contentHolder.addChild(circle);
			}
		}

		private var _temp:Number=0;

		private var itemHolder:Sprite;
		private var _count:int=0;

		private var contentHolder:Sprite;

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count=value;
			if (_count == tempArr.length)
			{
				TweenLite.to(contentHolder, .5, {alpha: 0, onComplete: function():void {
					contentHolder.removeChildren(0, -1, true);
					var info:Image=getImage("thermo-intro");
					info.x=75;
					info.y=71;
					contentHolder.addChild(info);
					TweenLite.to(contentHolder, .5, {alpha: 1});
					isWin=true;
				}});
			}
		}

		public function get temp():Number
		{
			return _temp;
		}

		public function set temp(value:Number):void
		{
			value=Math.max(-30, Math.min(120, value));
			_temp=value;

			if (!mecury)
				return;
			TweenLite.killTweensOf(mecury);
			var dy:Number=(120 - value) / 150 * 454;
			TweenLite.to(mecury.clipRect, 1, {y: dy});
		}

	}
}
