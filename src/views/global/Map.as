package views.global
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.geom.Point;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.FlipAnimation;
	import views.components.base.PalaceModule;

	public class Map extends PalaceModule
	{
		private var flipAnimation:FlipAnimation;

		public function Map(width:Number, height:Number)
		{
			super(new AssetManager(), width, height);
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
		}

		private function bgLoadedHandler(b:Bitmap):void
		{
			flipAnimation=new FlipAnimation(b, 4, 3);
			flipAnimation.addEventListener('completed', flipedHandler);
			flipAnimation.width=width;
			flipAnimation.height=height;
			addChild(flipAnimation);
		}

		override public function dispose():void
		{
			if(stage)
				stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			super.dispose();
			trace('disposed');
		}

		private function flipedHandler(e:Event):void
		{
			stage.addEventListener(TouchEvent.TOUCH, touchHandler);
			TweenLite.to(flipAnimation, 18, {y: 0});
		}

		private var downPoint:Point;
		private var downY:Number;

		private function touchHandler(e:TouchEvent):void
		{
			var t:Touch=e.getTouch(stage);
			if (!t)
				return;
			var p:Point=new Point(t.globalX, t.globalY);
			var toy:Number;
			switch (t.phase)
			{
				case TouchPhase.BEGAN:
					TweenLite.killTweensOf(flipAnimation);
					downPoint=new Point(t.globalX, t.globalY);
					downY=flipAnimation.y;
					break;
				case TouchPhase.MOVED:
					toy=p.y - downPoint.y;
					flipAnimation.y=downY + toy / scale;
					break;
				case TouchPhase.ENDED:
					if (flipAnimation.y > 0)
					{
						toy=0;
						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
					}
					else if (flipAnimation.y < height - flipAnimation.height)
					{
						toy=height - flipAnimation.height;
						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
					}
					break;
			}
		}
	}
}
