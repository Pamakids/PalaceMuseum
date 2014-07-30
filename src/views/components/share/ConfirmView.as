package views.components.share
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class ConfirmView extends Sprite
	{
		public function ConfirmView()
		{
			super();
		}

		private var direction:int;
		private var dirImg:Bitmap;

		public function init():void
		{
			bgSP=new Sprite();
			addChild(bgSP);

			var bg:Bitmap=new ShareAssets.gesture_bg();
			bgSP.addChild(bg);
			bgSP.x=1024-bg.width>>1;
			bgSP.y=768-bg.height>>1;

			//			var word:Bitmap=new RecomendAssets.GESWORD();
			//			word.x=94;
			//			word.y=100;
			//			bgSP.addChild(word);
		}

		private var active:Boolean=false;

		public function getCurrentDir():String
		{
			return dirArr[direction];
		}

		private var dirArr:Array=["up", "down", "left", "right"];

		private var bgSP:Sprite;

		public function getRandomGesture():void
		{
			if (dirImg && bgSP.contains(dirImg))
				bgSP.removeChild(dirImg);
			dirImg=null;
			direction=Math.random() * 4;
			var cls:Class;
			cls=ShareAssets["gesture_" + dirArr[direction]];
			dirImg=new cls();
			bgSP.addChild(dirImg);
			dirImg.x=281-37;
			dirImg.y=266-30;
		}
	}
}

