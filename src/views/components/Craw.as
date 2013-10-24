package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import starling.display.Image;
	import starling.textures.Texture;

	public class Craw extends Image
	{
		private var delay:Number;
		private var tw:TweenLite;

		public function Craw(texture:Texture)
		{
			super(texture);
			active();
		}

		public function active():void
		{
			delay=Math.random() * 1.5 + 3; //
			shake();
		}

		private function shake():void
		{
			TweenMax.to(this, 3, {shake: {rotation: Math.PI / 36, numShakes: 6}, onComplete: function():void
			{
				tw=TweenLite.delayedCall(delay, shake);
			}});
		}

		private var _da:Number=1.0;

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
