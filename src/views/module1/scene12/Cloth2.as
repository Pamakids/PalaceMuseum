package views.module1.scene12
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;

	public class Cloth2 extends Sprite
	{
		public function Cloth2()
		{
			super();
		}

		public var hat:Image;
		public var cloth:Image;

		private var _offset:Number;

		public function get offset():Number
		{
			return _offset;
		}

		public function set offset(value:Number):void
		{
			//value 0-1;
			_offset=1 - Math.max(0, Math.min(1, (value * 10 - 4) / 6));
			hat.y=hatY + _offset * 100;
			hat.scaleX=hat.scaleY=Math.max(.5, Math.min(1, (value * 10 - 4) / 6));
//			if (this.scaleX > .9)
//			{
//				hat.scaleX=scaleX * 1.05
//			}
		}

		private var hatY:Number=-404;
		private var clothY:Number=-350;

		public var index:int;
		public var type:String;

		public function initCloth():void
		{
			hat.pivotX=hat.width >> 1;
			hat.pivotY=hat.height;

			cloth.pivotX=cloth.width >> 1;

			addChild(hat);
			hat.y=hatY;
			addChild(cloth);
			cloth.y=clothY;
		}

		public function playEnter(pos:Point):void
		{
			var midX:Number=(x + pos.x) / 2;
			var midY:Number=(y + pos.y) / 2 - 300;
			TweenMax.to(this, 1, {bezierThrough: [{x: midX, y: midY}, {x: pos.x, y: pos.y}], ease: Circ.easeOut});
//			TweenLite.to(this, .5, {x: pos.x, y: pos.y});
		}
	}
}
