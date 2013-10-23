package views.module2
{
	import flash.geom.Point;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module2.scene22.Telescope;
	import views.module2.scene22.ThermoMeter;
	import views.module2.scene22.TriangularPrism;

	/**
	 * 早读模块
	 * 科学实验场景(三个小游戏)
	 * @author Administrator
	 */
	public class Scene22 extends PalaceScene
	{

		private var teleGame:Telescope;

		private var prismGame:TriangularPrism;

		private var prism:Image;
		private var thermo:Image;
		private var tele:Image;
		private var thermoGame:ThermoMeter;

		private var hint0:String="纸中之王是从唐朝开始生产的宣纸，它不褪色，少虫蛀，寿命长。我国流传至今的古籍珍本、名家书画，大都用宣纸保存，依然如初。";
		private var hint1:String="清朝皇帝多喜爱松花石砚，石头产自满族家乡松花江畔的长白山，颜色也和山中开放的黄绿色松花相似。";
		private var hint2:String="毛笔的冠军是浙江产的湖笔。湖笔与徽墨、宣纸、端砚并称为“文房四宝”，分别是笔墨纸砚中的极品。";
		private var hint3:String="古时书桌上用来盛装磨墨用的水的器具，有嘴的叫“水注”，无嘴的叫“水丞”。";
		private var hint4:String="这个金星玻璃冰裂纹笔筒，结合了金属与玻璃两种工艺，是乾隆时期是清宫造办处玻璃厂的作品。";

		private var itemNameArr:Array=["paper", "inkstone", "writingbrush", "waterpot", "brushpot"];
		private var posArr:Array=[new Point(13, 208), new Point(134, 158),
			new Point(330, 140), new Point(668, 177), new Point(577, 87)];

		private var hintArr:Array;
		private var itemArr:Array=[];

		public function Scene22(am:AssetManager=null)
		{
			super(am);
			hintArr=[hint0, hint1, hint2, hint3, hint4]
			crtKnowledgeIndex=6;
			addBG("bg32");
//			addChild(getImage("bg32"));

			for (var i:int=0; i < itemNameArr.length; i++)
			{
				var item:Image=getImage(itemNameArr[i]);
				item.x=posArr[i].x;
				item.y=posArr[i].y;
				item.addEventListener(TouchEvent.TOUCH, onItemTouch);
				addChild(item);
				itemArr.push(item);
			}

			LionMC.instance.say("皇上的洋人老师，带来几个新鲜玩意儿，试试吧", 0, 200, 500, addTouchs, 20, false);

			thermo=getImage("thermometer32");
			thermo.x=45;
			thermo.y=246;
			addChild(thermo);

			tele=getImage("tele32");
			tele.x=474;
			tele.y=453;
			addChild(tele);

			prism=getImage("prism32");
			prism.x=834;
			prism.y=380;
			addChild(prism);

			addCraw(new Point(174, 578));
			addCraw(new Point(590, 632));
			addCraw(new Point(908, 461));
		}

		private function addTouchs():void
		{
			thermo.addEventListener(TouchEvent.TOUCH, onThermoTouch);
			tele.addEventListener(TouchEvent.TOUCH, onTeleTouch);
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
			check(index);
		}

		private function check(index:int):void
		{
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			showAchievement(10);
		}

		private var p:Prompt;
		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(5);

		private function showHint(_x:Number, _y:Number, content:String):void
		{
			if (p)
				p.playHide();
			p=Prompt.showTXT(_x, _y, content, 18, null, this, 1, true);
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
			teleGame=new Telescope(assetManager)
			addChild(teleGame);
			teleGame.addEventListener(PalaceGame.GAME_OVER, onTelePlayed)
		}

		private function onTelePlayed(e:Event):void
		{
			if (teleGame.finished)
				showAchievement(13);
			teleGame.removeEventListener(PalaceGame.GAME_OVER, onTelePlayed)
			teleGame.removeChildren();
			removeChild(teleGame);
			teleGame=null;
		}

		private function initPrism():void
		{
			prismGame=new TriangularPrism(assetManager);
			addChild(prismGame);
			prismGame.addEventListener(PalaceGame.GAME_OVER, onPrismPlayed)
			prismGame.addEventListener("addCard", onPrismAddCard)
		}

		private function onPrismAddCard(e:Event):void
		{
			showCard("5", function():void {
				showAchievement(12)
			});
		}

		private function onPrismPlayed(e:Event):void
		{
			prismGame.removeEventListener(PalaceGame.GAME_OVER, onPrismPlayed)
			prismGame.removeEventListener("addCard", onPrismAddCard)
			prismGame.removeChildren();
			removeChild(prismGame);
			prismGame=null;
		}

		private function initThermo():void
		{
			thermoGame=new ThermoMeter(assetManager);
			addChild(thermoGame);
			thermoGame.addEventListener(PalaceGame.GAME_OVER, onThermoPlayed)
		}

		private function onThermoPlayed(e:Event):void
		{
			showAchievement(11);
			thermoGame.removeEventListener(PalaceGame.GAME_OVER, onThermoPlayed)
			thermoGame.removeChildren();
			removeChild(thermoGame);
			thermoGame=null;
			sceneOver();
		}
	}
}
