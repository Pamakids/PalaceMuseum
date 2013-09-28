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
					addChildAt(_src, 0);
				}
				else if (_src != value)
				{
					removeChild(_src);
					_src.dispose();
					_src=value;
					addChildAt(_src, 0);
				}
			}
			else
			{
				enableMovie=false;
				if (_src)
				{
					removeChild(_src);
					_src.dispose();
					_src=null;
				}
			}
		}

		public function say(content:String, callback:Function=null):void
		{
			var hintX:Number=_src.width - 40;
			var hintY:Number=40;

			if (prompt)
			{
				prompt.playHide();
			}
			prompt=Prompt.showTXT(hintX, hintY, content, 20, callback, this);
//			prompt=new Prompt(bg, content, 1);
//			addChild(prompt);
//			prompt.x=hintX;
//			prompt.y=hintY;
//			prompt.callback=callback;
//			prompt.playShow(3);
		}

		private var _state:int;
		private var enableMovie:Boolean;
		private var prompt:Prompt;

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
