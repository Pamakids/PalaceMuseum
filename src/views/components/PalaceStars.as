package views.components
{
	import flash.events.Event;

	import controllers.MC;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class PalaceStars extends Sprite
	{
		public function PalaceStars(_x:Number, _y:Number, pr:Sprite=null, callback:Function=null)
		{
			this.touchable=false;
			cb=callback;
			x=_x;
			y=_y;
			pr=pr ? MC.instance.main : pr;
			pr.addChild(this);

			playStar();
		}

		private var star:MovieClip;

		private var cb:Function;

		public function playStar():void
		{
			star=new MovieClip(MC.assetManager.getTextures("stars"), 20);
			addChild(star);
			SoundAssets.playSFX("starsound", true);
			star.loop=false;
			Starling.juggler.add(star);
			star.pivotX=star.width >> 1;
			star.pivotY=star.height;
			star.addEventListener(Event.COMPLETE, playComplete);
			star.play();
		}

		private function playComplete():void
		{
			if (cb)
				cb();
			cb=null;
			star.stop();
			Starling.juggler.remove(star);
			star.removeFromParent(true);
			star=null;
			this.removeFromParent(true);
		}
	}
}
