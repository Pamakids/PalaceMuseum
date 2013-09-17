package views.module3
{
	import flash.geom.Point;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
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

		private var hint0:String="纸中之王是从唐朝开始生产的宣纸，它不褪色，少虫蛀，寿命长。我国流传至今的古籍珍本、名家书画，大都用宣纸保存，依然如初。";
		private var hint1:String="清朝皇帝多喜爱松花石砚，石头产自满族家乡松花江畔的长白山，颜色也和山中开放的黄绿色松花相似。";
		private var hint2:String="毛笔的冠军是浙江产的湖笔。湖笔与徽墨、宣纸、端砚并称为“文房四宝”，分别是笔墨纸砚中的极品。";
		private var hint3:String="古时书桌上用来盛装磨墨用的水的器具，有嘴的叫“水注”，无嘴的叫“水丞”。";
		private var hint4:String="这个金星玻璃冰裂纹笔筒，结合了金属与玻璃两种工艺，是乾隆时期是清宫造办处玻璃厂的作品。";

		private var itemNameArr:Array=["paper", "inkstone", "writingbrush", "waterpot", "brushpot"];
		private var posArr:Array=[new Point(263, 287), new Point(168, 151),
			new Point(421, 79), new Point(651, 181), new Point(583, 105)];

		private var hintArr:Array=[hint0, hint1, hint2, hint3, hint4];
		private var itemArr:Array=[];

		public function Scene32(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=6;
			addChild(getImage("bg32"));

			for (var i:int=0; i < itemNameArr.length; i++)
			{
				var item:Image=getImage(itemNameArr[i]);
				item.x=posArr[i].x;
				item.y=posArr[i].y;
				item.addEventListener(TouchEvent.TOUCH, onItemTouch);
				addChild(item);
				itemArr.push(item);
			}

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

		private function onItemTouch(e:TouchEvent):void
		{
			var item:Image=e.currentTarget as Image;
			if (!item)
				return;
			var tc:Touch=e.getTouch(item, TouchPhase.ENDED);
			if (!tc)
				return;
			var index:int=itemArr.indexOf(item);
			var _x:Number=item.x + item.width / 2;
			var _y:Number=item.y + item.height / 2;
			showHint(_x, _y, hintArr[index]);
		}

		private var p:Prompt;

		private function showHint(_x:Number, _y:Number, content:String):void
		{
			if (p)
				p.playHide();
			p=Prompt.showTXT(_x, _y, content, 18, null, this);
//			p=Prompt.show(_x, _y, "hint-bg-big", content, 1, 5, null, this, false, 18);
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
