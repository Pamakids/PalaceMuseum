package views.logo
{
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class GG_Logo extends Sprite
	{
		[Embed(source="logo.png")]
		private static var logo:Class

		[Embed(source="logoBG.jpg")]
		private static var bg:Class

		[Embed(source="pot.png")]
		private static var pot:Class

		private var w:Number=1024;
		private var h:Number=768;

		private var logo2:MovieClip;

		private var stars:Sprite;

		private var cb:Function;

		private var starArr:Array=[];

		private static var starNum:int=400;

		public function GG_Logo(_cb:Function)
		{
			cb=_cb;
			var bp:Bitmap=new bg();
			graphics.beginBitmapFill(bp.bitmapData);
			graphics.drawRect(0,0,1024,768);
			graphics.endFill();

			msk=new Shape();
			addChild(msk);
			msk.graphics.beginFill(0,.7);
			msk.graphics.drawRect(0,0,1024,768);
			msk.graphics.endFill();

			stars=new Sprite();
			stars.x=w/2;
			stars.y=h/2;
			addChild(stars);

			for (var i:int = 0; i < starNum; i++) 
			{
				var star:Star=new Star(new pot());
				stars.addChild(star);

//				star.scaleX=star.scaleY=Math.random()*.5+.5;
				star.x=-w/2+Math.random()*w;
				star.y=-h/2+Math.random()*h;
				starArr.push(star);
			}

			logo2=new LogoGG();
			addChild(logo2);
			logo2.x=1024/2;
			logo2.y=768/2;
			logo2.play();
			logo2.addEventListener(Event.FRAME_CONSTRUCTED,function(e:Event):void{
				if(logo2.currentFrame==logo2.totalFrames)
					logo2.stop();
			});

			logo2.scaleX=logo2.scaleY=.6;

//			logo2=new Sprite();
//			var logoImg:Bitmap=new logo();
//			logoImg.smoothing=true;
//			addChild(logo2);
//			logo2.addChild(logoImg);
//			logoImg.x=-logoImg.width>>1;
//			logoImg.y=-logoImg.height>>1;
//
//			logo2.x=w>>1;
//			logo2.y=h>>1;
//			logo2.scaleX=logo2.scaleY=.8;

			addEventListener(Event.ENTER_FRAME,onEnterFrame);

			TweenLite.to(msk,1.5,{alpha:0,onComplete:end});
//			TweenLite.to(logo2,2,{});
//			TweenLite.to(logo2,totaltime,{scaleX:1,scaleY:1,});
		}

		private static var totaltime:Number=2.5;

		private var SpeedR:Number=.15;

		private var msk:Shape;

		protected function onEnterFrame(event:Event):void
		{
			stars.rotation+=SpeedR;

			stars.scaleX+=.002;
			stars.scaleY+=.002;

			for each (var star:Star in starArr) 
			{
				if(blinking)
					star.blink();
			}

		}

		private function end():void
		{
			blinking=false;
			TweenLite.to(stars,.7,{alpha:0,onComplete:doExit});
		}

		public function doExit():void
		{
			TweenLite.to(this,1,{alpha:0,onComplete:cb});
		}

		private var blinking:Boolean=true;

		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			graphics.clear();
			stars.removeChildren();
			starArr=[];
			cb=null;
		}
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;

class Star extends Sprite
{
	public var reverse:Boolean=false;

	public function Star(bp:Bitmap)
	{
		addChild(bp);
		bp.x=-bp.width>>1;
		bp.y=-bp.height>>1;
		alpha=Math.random();
		brightness=Math.random()*.2;
		speedA=Math.random()*.02+.01;

		reverse=Math.random()>.5;
		blinking=Math.random()>.5;
		scaleX=scaleY=.1+Math.random()*.1;
	}

	private var blinking:Boolean;

	private var speedA:Number;

	private var brightness:Number;

	public function blink():void
	{
		if(blinking)
			return;
		if(alpha>=1)
			reverse=true;
		else if(alpha<=brightness)
			reverse=false;
		if(reverse)
		{
			alpha-=speedA;
		}
		else
			alpha+=speedA;
//		scaleX=scaleY=1+alpha;
	}
}

