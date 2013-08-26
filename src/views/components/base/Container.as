package views.components.base
{
	import starling.display.Sprite;

	public class Container extends Sprite
	{
		public function Container(width:Number=0, height:Number=0)
		{
			super();
			this.width=width;
			this.height=height;
		}

		private var _width:Number;

		override public function get height():Number
		{
			return _height ? _height : super.height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
		}

		override public function get width():Number
		{
			return _width ? _width : super.width;
		}

		override public function set width(value:Number):void
		{
			_width=value;
		}

		private var _height:Number;

	}
}
