package views.module2
{
	import flash.geom.Point;

	import models.SOService;

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
	import views.global.TailBar;
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

		private var hint0:String="造纸家弟子的传世之作－宣纸\n宣纸因产自唐代宣州（今安徽泾县）而得名，它易书写，不退色，少虫蛀，寿命长。";
		private var hint1:String="仙鹤带来的制砚灵感－端砚\n端砚产自广东省端州（今肇庆）， 端砚石质优良，雕刻精美，研出的墨汁细滑。";
		private var hint2:String="秦始皇的大将创制的笔－湖笔\n毛笔的冠军是浙江湖州产的湖笔，笔尖锋利，笔头饱满，易写耐用。";

		private var hint3:String="能吃还能当药用的墨－徽墨\n因产于古徽州府(今安徽歙县)而得名，配方讲究，造型美观，耐磨耐用。";

		private var itemNameArr:Array=["paper", "inkstone", "writingbrush", "waterpot", "brushpot"];
		private var posArr:Array=[new Point(13, 208), new Point(134, 158),
			new Point(330, 140), new Point(668, 177), new Point(577, 87)];

		private var hintArr:Array;
		private var itemArr:Array=[];

		public function Scene22(am:AssetManager=null)
		{
			super(am);
			hintArr=[hint0, hint1, hint2]
			crtKnowledgeIndex=6;
			addBG("bg32");

			for (var i:int=0; i < itemNameArr.length; i++)
			{
				var item:Image=getImage(itemNameArr[i]);
				item.x=posArr[i].x;
				item.y=posArr[i].y;
				item.addEventListener(TouchEvent.TOUCH, onItemTouch);
				addChild(item);
				itemArr.push(item);
			}

			LionMC.instance.say("皇帝是个热爱科学的孩子，这些洋人老师带来的新鲜玩意你快来试试！", 0, 0, 0, addTouchs, 20);

			thermo=getImage("thermometer32");
			thermo.x=45;
			thermo.y=246;
			addChild(thermo);
			if (checkClicked(0))
				addLabel(0);

			tele=getImage("tele32");
			tele.x=474;
			tele.y=453;
			addChild(tele);
			if (checkClicked(1))
				addLabel(1);

			prism=getImage("prism32");
			prism.x=834;
			prism.y=380;
			addChild(prism);
			if (checkClicked(2))
				addLabel(2);

			addCraw(new Point(174, 578));
			addCraw(new Point(590, 632));
			addCraw(new Point(908, 461));
		}

		private var nameArr:Array=["thermo", "tele", "prism"];
		private var labelPosArr:Array=[new Point(198, 552),
			new Point(563, 696), new Point(912, 595)];

		private function checkClicked(index:int):Boolean
		{
			return SOService.instance.getSO(nameArr[index] + "clicked");
		}

		private function setClicked(index:int):void
		{
			SOService.instance.setSO(nameArr[index] + "clicked", true);
		}

		private function addLabel(index:int):void
		{
			var label:Image=getImage("label-" + nameArr[index]);
			label.x=labelPosArr[index].x;
			label.y=labelPosArr[index].y;
			var _index:int=getChildIndex(thermo) + 1;
			addChildAt(label, _index);
			label.touchable=false;
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
			if (index < 3)
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
			if (!checkClicked(1))
			{
				addLabel(1);
				setClicked(1);
			}
			if (teleGame.isWin)
				showAchievement(13);
			teleGame.removeFromParent(true);
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
				showAchievement(12, function():void {
					prismGame.addDragonWall();
				})
			});
		}

		private function onPrismPlayed(e:Event):void
		{
			if (!checkClicked(2))
			{
				addLabel(2);
				setClicked(2);
			}
			prismGame.removeFromParent(true);
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
			if (!checkClicked(0))
			{
				addLabel(0);
				setClicked(0);
			}
			if (thermoGame.isWin)
			{
				TailBar.hide();
				showAchievement(11, sceneOver);
			}
			else
				sceneOver();
			thermoGame.removeFromParent(true);
			thermoGame=null;

		}
	}
}
