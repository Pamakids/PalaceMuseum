package views.module5
{
	import com.greensock.TweenLite;

	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	public class Scene52 extends PalaceScene
	{
		public function Scene52(am:AssetManager=null)
		{
			super(am);
			addChild(getImage("bg52"));

			hand=getImage("memorial-hand");
			addChild(hand);
			handPosX=posX + memorialW - (hand.width >> 1);
			handOutPosY=outPosY + memorialH - (hand.height >> 1);
			handPosY=posY + memorialH - (hand.height >> 1);
			hand.x=handPosX;
			hand.y=handOutPosY;

			addOneMemorial();
		}

		private var handPosX:Number; //手 位置
		private var handPosY:Number;
		private var handOutPosY:Number;
		private var posX:Number=526; //奏折位置
		private var posY:Number=384;
		private var outPosY:Number=1024; // 初始位置
		private var memorialW:Number=183;
		private var memorialH:Number=379;

		private var hand:Image;
		private var crtMemorial:Image;
		private var crtIndex:int;
		private var indexArr:Array=[0, 1, 2, 3];

		private function addOneMemorial():void
		{
			var index:int=Math.random() * indexArr.length;
			crtIndex=indexArr[index];
			indexArr.splice(index, 1);
			var memorial:Image=getImage("memorial" + (crtIndex + 1).toString());
			memorial.x=posX;
			memorial.y=outPosY;
			crtMemorial=memorial;
			addChild(crtMemorial);
			TweenLite.to(hand, .5, {y: handPosY});
			TweenLite.to(crtMemorial, .5, {y: posY, onComplete: function():void {
				TweenLite.to(hand, .5, {y: handOutPosY})
				crtMemorial.addEventListener(TouchEvent.TOUCH, onMemorialTouch);
			}});
		}

		private function onMemorialTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(crtMemorial, TouchPhase.ENDED);
			if (tc)
			{
				crtMemorial.removeEventListener(TouchEvent.TOUCH, onMemorialTouch);
				initDraw();
			}
		}

		private function initDraw():void
		{
			removeMemorial();
//			callBack=removeMemorial;
		}

		private function removeMemorial():void
		{
			TweenLite.to(hand, .5, {y: handPosY, onComplete: function():void {

				TweenLite.to(hand, .5, {y: handOutPosY});

				TweenLite.to(crtMemorial, .5, {y: outPosY, onComplete: function():void {
					crtMemorial.removeFromParent(true);
					crtMemorial=null;
					trace(indexArr.length)
					if (indexArr.length == 2)
						sceneOver();
					else
						addOneMemorial();
				}});
			}});

		}
	}
}
