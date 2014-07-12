package views.module6.scene62
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import feathers.controls.Label;

	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	import views.components.PalaceStars;

	public class Target extends Sprite
	{
		public function Target(base:Image,target:Image,scale:Number=1)
		{
			addChild(base);
			base.pivotX=base.width>>1;
			base.pivotY=101;

			addChild(target);
			target.pivotX=target.width>>1;
			target.pivotY=target.height>>1;

			this.scaleX=this.scaleY=scale;
		}

		private var centerPT:Point;

		public var missed:Boolean;

		public var score:Number=0;

		private function playStars():void
		{
			new PalaceStars(0,-100,this);
		}

		private function playScore():void
		{
			var lbl:TextField=new TextField(250,100,'+'+score,FontVo.PALACE_FONT, 100, 0x0cff3c, true);
			addChild(lbl);
			lbl.x=-100;
			TweenLite.to(lbl,.5,{y:-200,alpha:.7,onComplete:function():void{
				lbl.removeFromParent(true);
			}});
		}

		public function checkArrow(arrow:Arrow):Boolean
		{
			if(missed)
				return false;

			var dx:Number=Math.abs(arrow.x-x)/scaleX;

			if(dx<23)
			{
				playStars();
				score=10;
				playScore();
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}else if(dx<49)
			{
				score=9;
				playScore();
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}else if(dx<70)
			{
				score=8;
				playScore();
				dispatchEvent(new Event('targetHitted',true));
				return true;
			}

			return false;
		}

		public function playStar():void
		{
			new PalaceStars(0,0,this);
		}

		public function miss(img:Image):void
		{
			missed=true;
			addChild(img);
			img.pivotX=img.width>>1;
			img.pivotY=img.height>>1;
		}
	}
}

