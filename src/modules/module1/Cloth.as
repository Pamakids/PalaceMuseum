package modules.module1
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Cloth extends Sprite
	{
		private var type:String;
		public function Cloth(_type:String)
		{
			type=_type;
		}

		private var _img:Image;

		public function get img():Image
		{
			return _img;
		}

		public function set img(value:Image):void
		{
			_img = value;
			addChild(_img);
//			pivotX=_img.width>>1;
//			pivotY=_img.height>>1;
		}

	}
}

