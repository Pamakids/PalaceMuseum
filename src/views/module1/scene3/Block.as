package views.module1.scene3
{
	import com.greensock.TweenLite;

	import starling.display.Sprite;

	public class Block extends Sprite
	{
		public static const GAP:uint=158;
		private var _index:uint;
		public var text:String;
		public var size:int;
		private var _matched:Boolean;
		private var ready:Boolean;

		public function get matched():Boolean
		{
			return _matched;
		}

		public function set matched(value:Boolean):void
		{
			_matched = value;
		}

		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			var _x:int=value%size*GAP;
			var _y:int=int(value/size)*GAP;

			if(!ready){
				_index = value;
				ready=true;
				x=_x;
				y=_y;
			}else if(_index != value){
				_index = value;
				TweenLite.to(this,.5,{x:_x,y:_y});
			}

		}

		public function Block()
		{
			pivotX=pivotY=GAP/2;
		}
	}
}

