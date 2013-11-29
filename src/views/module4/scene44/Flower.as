package views.module4.scene44
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.manager.SoundManager;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Flower extends Sprite
	{
		private var img1:Image;
		private var img2:Image;
		private var _isOpen:Boolean;

		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		public function set isOpen(value:Boolean):void
		{
			if (_isOpen == value)
				return;
			_isOpen=value;
			img1.visible=!value;
			img2.visible=value;
			if (img2.visible)
			{
				SoundAssets.playSFX("buttonclick", true);
				TweenLite.killTweensOf(img2);
				TweenMax.to(img2, .3, {shake: {scaleX: .1, scaleY: .1, numShakes: 1}});
			}
		}

		public function Flower()
		{

		}

		public function initFlower(_img1:Image, _img2:Image):void
		{
			img1=_img1;
			addChild(img1);
			img2=_img2;
			addChild(img2);
			img2.visible=false;
		}
	}
}
