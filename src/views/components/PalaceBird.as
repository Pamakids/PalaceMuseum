package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

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
			TweenMax.pauseAll();
			SOService.instance.setSO("birdCatched" + crtIndex, true);

			PopUpManager.addPopUp(this, true, false);
			TweenLite.to(bird, 1, {x: 470, y: 28, rotation: 0, onComplete: function():void {
				bird.stop();
			}});

			var holder:Sprite=new Sprite();
			holder.addChild(bg);
			holder.addChild(img);

			holder.pivotX=img.width >> 1;
			holder.pivotY=img.height >> 1;
			holder.x=512;
			holder.y=430;
			holder.scaleX=holder.scaleY=.2;
			addChildAt(holder, 0);

			TweenLite.to(holder, 1, {scaleX: .9, scaleY: .9});

			close.x=950;
			close.y=140;
			addChild(close);
			close.addEventListener(ElasticButton.CLICK, onClose);
		}

		private function onClose(e:Event):void
		{
			TweenMax.resumeAll();
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

		public var bg:Image;
	}
}
