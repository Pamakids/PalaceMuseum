package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import controllers.MC;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class CollectionCard extends Sprite
	{
		private var callback:Function;

		public function CollectionCard(_callback:Function=null)
		{
			callback=_callback;
		}

		public function show():void
		{
			eff=new MovieClip(MC.assetManager.getTextures("cardEff"), 24);
			Starling.juggler.add(eff);
			eff.play();
			eff.loop=true;
			eff.pivotX=eff.width >> 1;
			eff.pivotY=eff.height >> 1;
			eff.x=width >> 1;
			eff.y=height >> 1;
			addChild(eff);
			this.scaleX=this.scaleY=.1;
			TweenLite.to(this, .5, {scaleX: 1, scaleY: 1,
							 onComplete: function():void {
								 TweenLite.delayedCall(2, hide);
							 }});
		}

		private var eff:MovieClip;

		public function hide():void
		{
			TweenLite.to(this, .5, {scaleX: .1, scaleY: .1, x: -470, y: -320, alpha: .3, onComplete: callback, ease: Quad.easeIn});
		}

		override public function dispose():void
		{
			if (eff)
			{
				eff.stop();
				Starling.juggler.remove(eff);
				eff.removeFromParent(true);
				eff=null;
			}
			super.dispose();
		}
	}
}

