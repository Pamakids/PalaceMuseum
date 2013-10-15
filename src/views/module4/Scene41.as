package views.module4
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	/**
	 * 上朝模块
	 * 上朝场景
	 * @author Administrator
	 */
	public class Scene41 extends PalaceScene
	{
		private var dx:Number=0;
		private var bgHolder:Sprite;
		private var bgW:Number;
		private var leftHit:Boolean;
		private var rightHit:Boolean;
		private var acc:Accelerometer;

		public function Scene41(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=10;
			bgHolder=new Sprite();
			var bg1:Image=getImage("bg51l");
			var bg2:Image=getImage("bg51r");
			bg2.x=bg1.width - 1;
			bgHolder.addChild(bg1);
			bgHolder.addChild(bg2);
			bgW=bgHolder.width;
			bgHolder.x=(1024 - bgW) / 2;
			addChild(bgHolder);

			trace(bgHolder.width);

			acc=new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);

			if (SOService.instance.checkHintCount(shakeHintCount))
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		override public function dispose():void
		{
			super.dispose();
			acc.removeEventListener(AccelerometerEvent.UPDATE, onUpdate);
		}

		private var shakeHintCount:String="shakeHintCount";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;

		private function onEnterFrame(e:Event):void
		{
			if (isMoved || (leftHit || rightHit))
			{
				if (hintShow)
				{
					hintShow.removeChildren();
					hintShow.removeFromParent(true);
				}
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			if (count < 30 * 8)
				count++;
			else
			{
				shakeCount++;
				if (shakeCount >= 30 * 5)
				{
					isMoved=true;
					return;
				}
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintFinger=getImage("shakehint");
					hintFinger.pivotX=hintFinger.width >> 1;
					hintFinger.pivotY=hintFinger.height;
					hintFinger.x=512;
					hintFinger.y=650;
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.rotation >= degress2 * 15)
						shakeReverse=true;
					else if (hintFinger.rotation <= -degress2 * 15)
						shakeReverse=false;
					hintFinger.rotation+=shakeReverse ? -degress2 : degress2;
				}
			}
		}

		private var shakeCount:int=0;
		private var shakeReverse:Boolean;
		private var degress2:Number=Math.PI / 180;

		protected function onUpdate(event:AccelerometerEvent):void
		{
			trace(event.accelerationX);
			dx=event.accelerationX * 1024;

			bgHolder.x-=dx;
			if (bgHolder.x > 0)
			{
				leftHit=true;
				bgHolder.x=0;
			}
			else if (bgHolder.x < 1024 - bgW)
			{
				bgHolder.x=1024 - bgW;
				rightHit=true;
			}
			if (leftHit && rightHit)
			{
				showAchievement(21);
				sceneOver();
			}
		}
	}
}
