package views.module6.scene61
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class PicPiece extends Sprite
	{
		public var index:int;
		public var checked:Boolean;
		private var halo:Image;
		public function PicPiece(img:Image,imgc:Image,_halo:Image,_index:int)
		{
			addChild(img);
			addChild(imgc);
			halo=_halo;
			addChild(halo);
			halo.x=img.width-halo.width>>1;
			halo.y=img.height-halo.height>>1;
			halo.visible=false;
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

		public function showHalo():void
		{
			halo.visible=true;
		}

		public function hideHalo():void
		{
			halo.visible=false;
		}
	}
}

