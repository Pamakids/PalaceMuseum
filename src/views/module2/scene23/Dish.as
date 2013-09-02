package views.module2.scene23
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Sprite;

	public class Dish extends Sprite
	{
		public var index:int;
		public var tested:Boolean;
		public var isFlying:Boolean;
		public var isPoison:Boolean;
		private var _pt:Point;
		public var speedX:Number;
		public var speedY:Number;

		public function get pt():Point
		{
			return _pt;
		}

		public function set pt(value:Point):void
		{
			_pt=value;
			this.x=value.x;
			this.y=value.y;
		}

		public function tweenMove(callback:Function=null):void
		{
			TweenLite.to(this, .3, {x: pt.x, y: pt.y, onComplete: callback});
		}

		public function Dish()
		{
		}
	}
}
