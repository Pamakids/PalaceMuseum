package views.module1.scene12
{
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
			_offset=value;
			hat.y=hatY + value * 100;
			hat.rotation=value * Math.PI / 12;
		}

		private var hatY:Number=0;
		private var clothY:Number=0;
		private var lightY:Number=0;

		public var index:int;
		public var type:int;

		public function initCloth():void
		{
			hat.pivotX=hat.width >> 1;
			hat.pivotY=hat.height >> 1;
			cloth.pivotX=cloth.width >> 1;
			cloth.pivotY=cloth.height >> 1;

			addChild(hat);
			hat.y=hatY;
			addChild(cloth);
			cloth.y=clothY;

			light.pivotX=light.width >> 1;
			light.pivotY=light.height >> 1;

			addChild(light);
			light.y=lightY;
		}
	}
}
