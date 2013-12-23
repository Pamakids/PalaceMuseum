package views.module2
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.ItemIntro;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.global.TailBar;
	import views.global.books.BooksManager;
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

		private var hint0:String="造纸家弟子的传世之作－宣纸\n\n宣纸因产自唐代宣州\n（今安徽泾县）而得名，\n它易书写，不褪色，\n少虫蛀，寿命长。";
		private var hint1:String="仙鹤带来的制砚灵感－端砚\n\n端砚产自广东省端州\n（今肇庆）， 端砚石质优良，\n雕刻精美，研出的墨汁细滑。";
		private var hint2:String="秦始皇的大将创制的笔－湖笔\n\n毛笔的冠军是浙江湖州地区\n产的湖笔，笔尖锋利，\n笔头饱满，易写耐用。";
		private var hint3:String="能吃还能当药用的墨－徽墨\n\n徽墨因产于古徽州府\n(今安徽歙县)而得名，\n配方讲究，造型美观，\n耐磨耐用。";

		private var posArr:Array=[new Point(13, 208), new Point(134, 158),
								  new Point(330, 140), new Point(668, 177), new Point(577, 87)];

		private var hotAreaArr:Array=[new Rectangle(85, 372, 351, 167), new Rectangle(602, 151, 111, 147),
									  new Rectangle(354, 164, 135, 204), new Rectangle(712, 193, 127, 82), new Rectangle(123, 139, 198, 175)];

		private var hintArr:Array;

		public function Scene22(am:AssetManager=null)
		{
			super(am);
			hintArr=[hint0, hint1, hint2, hint3]
			crtKnowledgeIndex=6;
			addBG("bg32");

			thermo=getImage("thermometer32");
			thermo.x=45;
			thermo.y=246;
			addChild(thermo);
			if (checkClicked(0))
				addLabel(0);

			addEventListener("lionFound", onLionFound);
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

			addMask(.6);
			king=new Sprite();
			var kingImg:Image=getImage("kingHead")
			king.addChild(kingImg);
			SPUtils.registSPCenter(king, 2);
			addChild(king);
			king.x=512 - 125;
			king.y=768;
			kingImg.addEventListener(TouchEvent.TOUCH, onKingTouch);

			var lion:Image=getImage("lionHead");
			lion.x=king.width;
			lion.y=king.height - lion.height;
			king.addChild(lion);
			lion.addEventListener(TouchEvent.TOUCH, onLionTouch);

			kingChat1();
		}

		private function onLionFound(e:Event):void
		{
			showAchievement(13);
		}

		private function onKingTouch(e:TouchEvent):void
		{
			var img:Image=e.currentTarget as Image;
			if (!img)
				return;
			var tc:Touch=e.getTouch(img, TouchPhase.ENDED);
			if (!tc)
				return;
			//			var pt:Point=tc.getLocation(this);
			//			if (dpt && Point.distance(dpt, pt) < 15)
			if (chatP)
				chatP.playHide();
		}

		private function onLionTouch(e:TouchEvent):void
		{
			var img:Image=e.currentTarget as Image;
			if (!img)
				return;
			var tc:Touch=e.getTouch(img, TouchPhase.ENDED);
			if (!tc)
				return;
			if (chatP)
				chatP.playHide();
		}

		private function kingChat1():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(50, 50, chat1, 20, lionChat1, king, 3)
		}

		private function lionChat1():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(420, 140, chat2, 20, lionChat2, king)
		}

		private function lionChat2():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(420, 140, chat3, 20, chatOver, king, 1, false, 3, true)
			LionMC.instance.setLastData(chat3, 0, 0, 0, .6, true);
		}

		private function chatOver():void
		{
			birdIndex=3
			removeMask();
			king.touchable=false;
			TweenLite.to(king, 1, {y: 768 + 311, onComplete: addTouchs});
		}

		private var chatP:Prompt;

		private var chat1:String="这些新鲜玩意儿是什么？";
		private var chat2:String="都是洋人老师带来的西洋仪器。"
		private var chat3:String="西方传教士东来，皇帝也要与时俱进啊，这些仪器你至少要学会一样！"

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
			king.removeFromParent(true);
			TailBar.show();
			bg.addEventListener(TouchEvent.TOUCH, onItemTouch);
			thermo.addEventListener(TouchEvent.TOUCH, onThermoTouch);
			tele.addEventListener(TouchEvent.TOUCH, onTeleTouch);
			prism.addEventListener(TouchEvent.TOUCH, onPrismTouch);
		}

		private function onItemTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg, TouchPhase.ENDED);
			if (!tc)
				return;
			var index:int=checkIndex(tc.getLocation(bg));
			if (index < 0)
				return;
			if (index == 4)
			{
				book=new ItemIntro(2, new Rectangle(82, 452, 260, 90));
				close=new ElasticButton(getImage("button_close"), getImage("button_close_down"));
				book.addIntro(getImage("intro-bg"), getImage("intro-waterpot"), close);
				book.addEventListener(ItemIntro.CLOSE, onClose);
				book.addEventListener(ItemIntro.OPEN, onOpenItemIntro);
			}
			else
			{
				var rect:Rectangle=hotAreaArr[index];
				var _x:Number=rect.x + rect.width / 2;
				var _y:Number=rect.y + rect.height / 2;
				showHint(_x, _y, hintArr[index], index == 3 ? 3 : 1);
				check(index);
			}
		}

		private function onOpenItemIntro(e:Event):void
		{
			var index:int=book.index;
			PopUpManager.removePopUp(book, true);
			book=null;
			showCard("12", function():void {
				check(4, function():void {
					BooksManager.showBooks(1, 1, index);
				});
			});
		}

		private function onClose(e:Event):void
		{
			PopUpManager.removePopUp(book, true);
			book=null;
			showCard("12", function():void {
				check(4);
			});
		}

		private function checkIndex(pt:Point):int
		{
			for (var i:int=0; i < hotAreaArr.length; i++)
			{
				var rect:Rectangle=hotAreaArr[i];
				if (rect.containsPoint(pt))
					return i;
			}
			return -1;
		}

		private function check(index:int, cb:Function=null):void
		{
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
				{
					if (cb != null)
						cb();
					return;
				}
			}
			showAchievement(10, cb);
		}

		private var p:Prompt;
		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(5);
//		private var book:Sprite;
		private var book:ItemIntro;
		private var close:ElasticButton;
		private var king:Sprite;

		private function showHint(_x:Number, _y:Number, content:String, align:int=1):void
		{
			if (p)
				p.playHide();
			p=Prompt.showTXT(_x, _y, content, 20, null, this, align, true);
		}

		private function onTeleTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(tele, TouchPhase.ENDED);
			if (tc)
				initTelescope();
		}

		private function onThermoTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(thermo, TouchPhase.ENDED);
			if (tc)
				initThermo();
		}

		private function onPrismTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
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
//			if (teleGame.isWin)
//				showAchievement(13);
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
