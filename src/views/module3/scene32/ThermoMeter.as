package views.module3.scene32
{
	import com.greensock.TweenLite;

	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class ThermoMeter extends PalaceGame
	{
		private var closeBtn:ElasticButton;

		private var mecury:Sprite;

		private var lightArr:Array=[];

		public function ThermoMeter(am:AssetManager=null)
		{
			super(am);

			addChild(getImage("gamebg"));

			var thermo:Image=getImage("thermo");
			thermo.x=152;
			thermo.y=19;
			addChild(thermo);

			mecury=new Sprite();
			mecury.addChild(getImage("thermo-mercury"));
			mecury.x=172;
			mecury.y=169;
			mecury.clipRect=new Rectangle(0, 454, 6, 454);
			addChild(mecury);

			for (var i:int=0; i < 4; i++)
			{

			}


			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.BEGAN);
			if (tc)
				temp+=10;
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			dispatchEvent(new Event("gameOver"));
		}

		private var _temp:Number=0;

		public function get temp():Number
		{
			return _temp;
		}

		public function set temp(value:Number):void
		{
			value=Math.max(-30, Math.min(120, value));
			_temp=value;

			if (!mecury)
				return;
			TweenLite.killTweensOf(mecury);
			var dy:Number=(120 - value) / 150 * 454;
			TweenLite.to(mecury.clipRect, .5, {y: dy});
		}

	}
}
