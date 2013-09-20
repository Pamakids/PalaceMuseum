package views.components
{
	import com.greensock.TweenLite;

	import starling.display.Sprite;

	public class CollectionCard extends Sprite
	{
		public function CollectionCard()
		{
		}

		public function show():void
		{
			this.scaleX=this.scaleY=.1;
			TweenLite.to(this, .5, {scaleX: 1, scaleY: 1,
					onComplete: function():void {
						TweenLite.delayedCall(2, hide);
					}});
		}

		public function hide():void
		{
			TweenLite.to(this, .5, {scaleX: .1, scaleY: .1, x: -462, y: -334, alpha: .3});
		}
	}
}

