package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import starling.display.Image;
	import starling.display.Sprite;

	public class Craw extends Sprite
	{
		private var delay:Number;
		private var tw:TweenLite;
		private var img0:Image;
		private var img1:Image;

		public function Craw(_img0:Image, _img1:Image, pr:Sprite)
		{
			pr.addChild(this);
			img0=_img0;
			img1=_img1;
			addChild(img0);
			addChild(img1);
			img1.visible=false;
			active();
		}

		public function active():void
		{
			delay=Math.random() * 1.5 + 3; //
			shake();
		}

		private function shake():void
		{
			img1.visible=true;
			TweenMax.to(this, 3, {shake: {rotation: Math.PI / 12, numShakes: 6}, onComplete: function():void
			{
				img1.visible=false;
				tw=TweenLite.delayedCall(delay, shake);
			}});
		}

		private var _da:Number=1.0;
		public var index:int;

		public function get da():Number
		{
			return _da;
		}

		public function set da(value:Number):void
		{
			_da=value;
			alpha=da;
		}

		public function deActive():void
		{
			this.alpha=1;
			img1.visible=false;
			TweenLite.killTweensOf(this);
			if (tw)
				TweenLite.killDelayedCallsTo(tw);
		}

		override public function dispose():void
		{
			deActive();
			super.dispose();
		}
	}
}
