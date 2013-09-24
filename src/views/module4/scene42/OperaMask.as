package views.module4.scene42
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Sprite;

	public class OperaMask extends Sprite
	{
		private var _index:int;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index=value;
			originPt=new Point(971, 190 + _index * 90);
			x=originPt.x;
			y=originPt.y;
		}

		public var type:String;
		private var originPt:Point;

		public function OperaMask()
		{
			super();
		}

		public function reset():void
		{
			TweenLite.to(this, .5, {x: originPt.x, y: originPt.y});
		}
	}
}
