package views.module5
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;

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
	public class Scene51 extends PalaceScene
	{
		private var dx:Number=0;
		private var bgHolder:Sprite;
		private var bgW:Number;
		private var leftHit:Boolean;
		private var rightHit:Boolean;
		private var acc:Accelerometer;

		public function Scene51(am:AssetManager=null)
		{
			super(am);

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

//			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		override public function dispose():void
		{
			super.dispose();
			acc.removeEventListener(AccelerometerEvent.UPDATE, onUpdate);
//			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{

		}

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
