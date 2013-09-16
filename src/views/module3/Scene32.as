package views.module3
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module3.scene32.Telescope;
	import views.module3.scene32.ThermoMeter;
	import views.module3.scene32.TriangularPrism;

	public class Scene32 extends PalaceScene
	{

		private var teleGame:Telescope;

		private var prismGame:TriangularPrism;
		private var telePlayed:Boolean;
		private var prismPlayed:Boolean;

		private var prism:Image;
		private var thermo:Image;
		private var tele:Image;
		private var thermoGame:ThermoMeter;
		private var thermoPlayed:Boolean;

		public function Scene32(am:AssetManager=null)
		{
			super(am);


			addChild(getImage("bg32"));

			thermo=getImage("thermometer32");
			thermo.x=45;
			thermo.y=246;
			addChild(thermo);
			thermo.addEventListener(TouchEvent.TOUCH, onThermoTouch);

			tele=getImage("tele32");
			tele.x=474;
			tele.y=453;
			addChild(tele);
			tele.addEventListener(TouchEvent.TOUCH, onTeleTouch);

			prism=getImage("prism32");
			prism.x=834;
			prism.y=380;
			addChild(prism);
			prism.addEventListener(TouchEvent.TOUCH, onPrismTouch);
		}

		private function onTeleTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(tele, TouchPhase.ENDED);
			if (tc)
				initTelescope();
		}

		private function onThermoTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(thermo, TouchPhase.ENDED);
			if (tc)
				initThermo();
		}

		private function onPrismTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(prism, TouchPhase.ENDED);
			if (tc)
				initPrism();
		}

		private function initTelescope():void
		{
			teleGame=new Telescope(assets)
			addChild(teleGame);
			teleGame.addEventListener("gameOver", onTelePlayed)
		}

		private function onTelePlayed(e:Event):void
		{
			teleGame.removeEventListener("gameOver", onTelePlayed)
			teleGame.removeChildren();
			removeChild(teleGame);
			teleGame=null;

			telePlayed=true;

			checkProcess();
		}

		private function checkProcess():void
		{
			if (telePlayed && prismPlayed && thermoPlayed)
				dispatchEvent(new Event("gotoNext", true));
		}

		private function initPrism():void
		{
			prismGame=new TriangularPrism(assets);
			addChild(prismGame);
			prismGame.addEventListener("gameOver", onPrismPlayed)
		}

		private function onPrismPlayed(e:Event):void
		{
			prismGame.removeEventListener("gameOver", onPrismPlayed)
			prismGame.removeChildren();
			removeChild(prismGame);
			prismGame=null;

			prismPlayed=true;
		}

		private function initThermo():void
		{
			thermoGame=new ThermoMeter(assets);
			addChild(thermoGame);
			thermoGame.addEventListener("gameOver", onThermoPlayed)
		}

		private function onThermoPlayed(e:Event):void
		{
			thermoGame.removeEventListener("gameOver", onPrismPlayed)
			thermoGame.removeChildren();
			removeChild(thermoGame);
			thermoGame=null;

			thermoPlayed=true;
		}
	}
}
