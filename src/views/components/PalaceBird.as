package views.components
{
	import com.greensock.TweenLite;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PalaceBird extends Sprite
	{
		public function PalaceBird()
		{
		}

		public var img:Image;
		public var bird:MovieClip;
		public var bg:Image;
		public var close:ElasticButton;
		private var speedX:Number;
		private var speedY:Number;
		private var count:Number;
		private var birdY:Number;
		private var sp:Shape;

		public function fly():void
		{
			addChild(bird);
			Starling.juggler.add(bird);
			bird.loop=true;
			bird.play();
			bird.x=1024;
			birdY=Math.random() * 500 + 100;
			speedX=-10;
			count=0;

			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var degree1:Number=Math.PI / 360

		private function onEnterFrame(e:Event):void
		{
			count+=degree1 * 30;
			bird.x+=speedX;
			bird.y=Math.cos(count) * 50 + birdY;
			if (bird.y < -200)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.removeFromParent(true);
			}
		}

		private function onTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(bird, TouchPhase.BEGAN);
			if (tc)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.removeFromParent(false);
				open();
			}
		}

		public var crtIndex:int;

		private function open():void
		{
			SOService.instance.setSO("birdCatched" + crtIndex, true);
//			var num:Object=SOService.instance.getSO("bird_count");
//			if (!num)
//				num=1;
//			else
//				num=int(num) + 1;
//			SOService.instance.setSO("bird_count", num);

			PopUpManager.addPopUp(this, true, false);
			TweenLite.to(bird, 1, {x: 440, y: 39, rotation: 0});

			bg.pivotX=bg.width >> 1;
			bg.pivotY=bg.height >> 1;
			bg.x=512;
			bg.y=444;
			bg.scaleX=bg.scaleY=.2;
			addChild(bg);

			img.pivotX=img.width >> 1;
			img.pivotY=img.height >> 1;
			img.x=512;
			img.y=444;
			img.scaleX=img.scaleY=.2;
			addChild(img);

			TweenLite.to(img, 1, {scaleX: 1, scaleY: 1});
			TweenLite.to(bg, 1, {scaleX: 1, scaleY: 1});

			close.x=950;
			close.y=50;
			addChild(close);
			close.addEventListener(ElasticButton.CLICK, onClose);
		}

		private function onClose(e:Event):void
		{
			close.removeEventListener(ElasticButton.CLICK, onClose);
			PopUpManager.removePopUp(this);
			this.dispose();
		}

		override public function dispose():void
		{
			if (bird)
			{
				Starling.juggler.remove(bird);
				bird.stop();
				bird.removeFromParent(true);
				bird=null;
			}
			super.dispose();
		}
	}
}
