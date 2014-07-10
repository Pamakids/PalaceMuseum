package views.module6.scene61
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class PicPiece extends Sprite
	{
		public var index:int;
		public var checked:Boolean;
		public function PicPiece(img:Image,imgc:Image,_index:int)
		{
			addChild(img);
			addChild(imgc);
			imgc.visible=false;
			index=_index;
		}

		public function setColor():void
		{
			checked=true;
			getChildAt(0).visible=false;
			getChildAt(1).visible=true;
			touchable=false;
		}
	}
}

