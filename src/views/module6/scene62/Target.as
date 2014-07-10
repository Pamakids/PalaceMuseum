package views.module6.scene62
{
	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import views.components.PalaceStars;

	public class Target extends Sprite
	{
		public function Target(base:Image,target:Image,scale:Number=1)
		{
			addChild(base);
			addChild(target);
			target.y=25;
			this.pivotX=base.width>>1;
			this.pivotY=base.height;

			this.scaleX=this.scaleY=scale;
		}

		private var centerPT:Point;
		public var hitted:Boolean;

		public var missed:Boolean;

		public var score:Number;

		public function checkArrow(arrow:Arrow):Boolean
		{
			var dx:Number=Math.abs(arrow.x-x)/scaleX;

			if(dx<23)
			{
				score=10;
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}else if(dx<49)
			{
				score=9;
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}else if(dx<70)
			{
				score=8;
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}

			return false;
		}

		public function playStar():void
		{
			new PalaceStars(0,0,this);
		}
	}
}

