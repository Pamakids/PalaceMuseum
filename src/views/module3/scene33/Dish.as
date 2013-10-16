package views.module3.scene33
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Image;
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
		private var _isBad:Boolean;

		public function get isBad():Boolean
		{
			return _isBad;
		}

		public function set isBad(value:Boolean):void
		{
			_isBad=value;
			if (value)
				addFly();
		}

		/**
		 *
		 * 菜品变质动画
		 * */
		private function addFly():void
		{
			// TODO Auto Generated method stub

		}

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

		public function addContent(img:Image):void
		{
			addChild(img);
			img.pivotX=img.width >> 1;
			img.pivotY=img.height >> 1;
		}

		public function countDown():void
		{
			if (count > 0)
				count--;
			else
				isBad=true;
		}

		public function addCount():void
		{

		}

		private var count:int=300;
	}
}
