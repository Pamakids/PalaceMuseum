package
{
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	* 测试多点触摸
	* @author shaorui
	*
	*/
	public class MultiDemo extends Sprite
	{
		[Embed(source="assets/bg.jpg")]
		private var bg:Class;

		private var logo:Image;

		public function MultiDemo()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,initGame);
		}
		/**开始*/
		private function initGame(event:Event):void
		{
			var mStarling:Starling = Starling.current;
			//开启触碰模拟器，便于PC测试
			mStarling.simulateMultitouch = true;

//			addChild(Image.fromBitmap(new bg()));
			//添加一个Image用于测试
//			var logoBmp:Bitmap = new logoClazz() as Bitmap;
			logo = Image.fromBitmap(new bg());
			addChild(logo);
			//侦听Touch事件
			addEventListener(TouchEvent.TOUCH, onTouch);
			//如果要侦听Flash原生手势，可以这样
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			Starling.current.nativeStage.addEventListener(TransformGestureEvent.GESTURE_SWIPE,gestureSwipeHandler);
		}
		/**滑屏事件*/
		private function gestureSwipeHandler(event:TransformGestureEvent):void
		{
			trace(event);
		}
		/**处理Touch事件捕获后的进一步操作*/
		private function onTouch(event:TouchEvent):void
		{
			//得到触碰并且正在移动的点（1个或多个）
			var touches:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
			trace(touches.length)
			//如果只有一个点在移动，是单点触碰
			if (touches.length == 1)
			{
				var delta:Point = touches[0].getMovement(stage);
				this.x += delta.x;
				this.y += delta.y;
			}
			//如果有两个点，可以认为是旋转和缩放
			else if (touches.length == 2)
			{
				//得到两个点的引用
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				//A点的当前和上一个坐标
				var currentPosA:Point  = touchA.getLocation(stage);
				var previousPosA:Point = touchA.getPreviousLocation(stage);
				//B点的当前和上一个坐标
				var currentPosB:Point  = touchB.getLocation(stage);
				var previousPosB:Point = touchB.getPreviousLocation(stage);
				//计算两个点之间的距离
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				//计算上一个弧度和当前触碰点弧度，算出弧度差值
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				//将旋转的中心点设置为两个触碰点的中心点
				var previousLocalA:Point  = touchA.getPreviousLocation(logo);
				var previousLocalB:Point  = touchB.getPreviousLocation(logo);
				this.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
				this.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				//将LOGO坐标设置为两个触碰点的中心点
				this.x = (currentPosA.x + currentPosB.x) * 0.5;
				this.y = (currentPosA.y + currentPosB.y) * 0.5;
				//旋转
				this.rotation += deltaAngle;
				//缩放
				var sizeDiff:Number = currentVector.length / previousVector.length;
				this.scaleX *= sizeDiff;
				this.scaleY *= sizeDiff;
			}
		}
	}
}

