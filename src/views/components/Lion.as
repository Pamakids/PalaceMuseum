package views.components
{
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class Lion extends Sprite
	{
		public function Lion()
		{
			super();
		}

		private var _src:DisplayObject;

		public function get src():DisplayObject
		{
			return _src;
		}

		public function set src(value:DisplayObject):void
		{
			if (value)
			{
				enableMovie=(value is MovieClip);
				if (!_src)
				{
					_src=value;
					addChild(_src);
				}
				else if (_src != value)
				{
					removeChild(_src);
					_src.dispose();
					_src=value;
					addChild(_src)
				}
			}
			else
			{
				enableMovie=false;
				removeChild(_src);
				_src.dispose();
				_src=null;
			}
		}

		public function say(content:String, bg:String="hint-bg", callback:Function=null):void
		{
			Prompt.show(hintX, hintY, "", content, 1, 3, callback, this);
		}

		private static var hintX:Number=0;
		private static var hintY:Number=0;

		private var _state:int;
		private var enableMovie:Boolean;

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state=value;
		}

	}
}
