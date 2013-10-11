package views.module1.scene12
{
	import com.greensock.TweenLite;

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
		public var light:Image;

		private var _offset:Number;

		public function get offset():Number
		{
			return _offset;
		}

		public function set offset(value:Number):void
		{
			_offset=1 - value;
			hat.y=hatY + _offset * 100;
			hat.rotation=_offset * Math.PI / 12;
			cloth.rotation=-_offset * Math.PI / 20;
		}

		private var hatY:Number=-474;
		private var clothY:Number=-422;
		private var lightY:Number=15;

		public var index:int;
		public var type:int;

		public function initCloth():void
		{
			hat.pivotX=hat.width >> 1;
			hat.pivotY=hat.height;

			cloth.pivotX=cloth.width >> 1;

			addChild(hat);
			hat.y=hatY;
			addChild(cloth);
			cloth.y=clothY;

			light.pivotX=light.width >> 1;
			light.pivotY=light.height;
			addChild(light);
			light.y=lightY;
		}

		public function playEnter(pos:Point):void
		{
			TweenLite.to(this, .5, {x: pos.x, y: pos.y});
		}
	}
}
