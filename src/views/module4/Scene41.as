package views.module4
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.pamakids.palace.utils.SPUtils;

	import flash.events.AccelerometerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;
	import flash.utils.getTimer;

	import controllers.UserBehaviorAnalysis;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Craw;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.global.TailBar;

	/**
	 * 上朝模块
	 * 上朝场景
	 * @author Administrator
	 */
	public class Scene41 extends PalaceScene
	{
		private var speedX:Number=0;
		private var bgHolder:Sprite;
		private var bgW:Number;
		private var leftHit:Boolean;
		private var rightHit:Boolean;
		private var acc:Accelerometer;

		private var cardArr:Array=[new Point(571, 146), new Point(1890, 151),
								   new Point(122, 113), new Point(2333, 114), new Point(1500, 40)];

		private var cardTxtArr:Array=["崇楼","后左门","保和殿","后右门","崇楼"];
		private var cardAreaArr:Array=[new Rectangle(157,129,208,147),new Rectangle(390,137,197,116),
									   new Rectangle(1040,67,458,160),new Rectangle(1950,167,214,86),
									   new Rectangle(2160,124,236,174)]  

		public function Scene41(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=8;
			bgHolder=new Sprite();
			var bg1:Image=getImage("bg41l");
			var bg2:Image=getImage("bg41r");
			bg2.x=bg1.width - 1;
			bgHolder.addChild(bg1);
			bgHolder.addChild(bg2);
			bgW=bgHolder.width;
			bgHolder.x=-300;
			addChild(bgHolder);

//			for (var i:int=0; i < cardArr.length; i++)
//			{
//				var card:Image=getImage((i + 1).toString());
//				card.x=cardArr[i].x;
//				card.y=cardArr[i].y;
//				card.scaleX=card.scaleY=(i == 4 ? 130 : 78) / card.width;
//				bgHolder.addChild(card);
//			}

			peopleHolder=new Sprite();
			bgHolder.addChild(peopleHolder);

			var pillar:Image=getImage("pillar");
			bgHolder.addChild(pillar);
			pillar.x=519;
			pillar.y=511;
			pillar.touchable=false;

			king=new Sprite();
			var kingImg:Image=getImage("kingHead")
			king.addChild(kingImg);
			SPUtils.registSPCenter(king, 2);
			addChild(king);
			king.x=512 - 125;
			king.y=768;

			var lion:Image=getImage("lionHead");
			lion.x=king.width;
			lion.y=king.height - lion.height;
			king.addChild(lion);

			var dx:Number=1024 - bgW >> 1

			TweenLite.to(bgHolder, 3, {x: dx, ease: Quad.easeInOut, onComplete: function():void {
				kingImg.addEventListener(TouchEvent.TOUCH, onKingTouch);
				lion.addEventListener(TouchEvent.TOUCH, onLionTouch);
				lionChat1();
			}});
		}

		override protected function init():void
		{
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(sceneName);
			SoundAssets.playBGM("s41bgm");
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

		private function lionChat1():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(420, 140, chat1, 20, kingChat1, king)
		}

		private function kingChat1():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(50, 50, chat2, 20, lionChat2, king, 3)
		}

		private function lionChat2():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(420, 140, chat3, 20, lionChat3, king)
		}

		private function lionChat3():void
		{
			if (chatP)
				chatP.playHide();
			chatP=Prompt.showTXT(420, 140, chat4, 20, chatOver, king, 1, false, 3, true)
			LionMC.instance.setLastData(chat4, 0, 0, 0, .6, true);
		}

		private function chatOver():void
		{
			birdIndex=7;
			removeMask();
			king.touchable=false;
			TweenLite.to(king, 1, {y: 768 + 311, onComplete: getReady});
		}

		private var chatP:Prompt;
		private var chat1:String="御门听政也叫“上早朝”，就在这儿\n举行。";
		private var chat2:String="皇帝为什么在室外办公呢？"
		private var chat3:String="这是皇帝在向天地彰显他的公正和勤勉！"
		private var chat4:String="对于皇帝来说御门听政是很严肃的工作，你要熟悉整个过程，绝对不能马虎。" //task

		private function getReady():void
		{
			addCraws();

			bgHolder.addEventListener(TouchEvent.TOUCH, onTouch);

//			acc=new Accelerometer();
//			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);
//
//			if (SOService.instance.checkHintCount(shakeHintCount))
//				needHint=true;
//			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			TailBar.show();
		}

		private var dragging:Boolean;

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(bgHolder);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dragging=true;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (dragging)
					{
						speedX=tc.getMovement(this).x;

						bgHolder.x+=speedX / 2;
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
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					dragging=false;
					checkArea(pt);
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkArea(pt:Point):void
		{
			for (var i:int = 0; i < cardAreaArr.length; i++) 
			{
				var rect:Rectangle=cardAreaArr[i];
				if(rect.containsPoint(pt)){
					var _x:Number;
					var _y:Number;
					var align:int;
					switch(i)
					{
						case 0:
						{
							_x=rect.x+rect.width/2;  
							_y=rect.y+50;
							align=3;
							break;
						}

						case 1:
						{
							_x=rect.x+rect.width-35;  
							_y=rect.y+35;
							align=1;
							break;
						}

						case 2:
						{
							_x=rect.x+rect.width-20;  
							_y=rect.y+60;
							align=1;
							break;
						}

						case 3:
						{
							_x=rect.x+29;  
							_y=rect.y+23;
							align=3;
							break;
						}

						case 4:
						{
							_x=rect.x+rect.width-72;  
							_y=rect.y+30;
							align=1;
							break;
						}

						default:
						{
							break;
						}
					}
					showHint(_x,_y,cardTxtArr[i],align);
					return;
				}
			}

		}

		private var crawPosArr:Array=[new Point(1278, 708), new Point(1064, 490), new Point(1488, 490)];
		private var peoplePosArr:Array=[new Point(1241, 641), new Point(911, 416), new Point(1421, 416)];

		private var hintArr:Array=["大臣们奏事时，依次来到皇帝的龙案前跪下，汇报工作，接受指令",
								   "御门听政相当于国家最高级别的办公会议，只有各部门的重要领导才有资格参加", "大臣如果迟到或早退，不仅要被皇帝骂，有时还会被扣工资"];

		private function addCraws():void
		{
			for (var i:int=0; i < crawPosArr.length; i++)
			{
				addCraw(crawPosArr[i], onCrowTouch, bgHolder, i);
			}
		}

		private function onCrowTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var craw:Craw=e.currentTarget as Craw;
			if (!craw)
				return;
			var tc:Touch=e.getTouch(craw, TouchPhase.ENDED);
			if (!tc)
				return;
			showChancellor(craw);

		}

		private function showChancellor(craw:Craw):void
		{
			var index:int=craw.index;
			craw.removeEventListener(TouchEvent.TOUCH, onCrowTouch);
			craw.deActive();
			craw.touchable=false;
			checkArr[index]=true;
			var dx:Number;
			var show:Boolean;
			switch (index)
			{
				case 0:
				{
					if (!chancellor)
					{
						show=true;
						chancellor=getImage("chancellor");
						chancellor.x=peoplePosArr[index].x;
						chancellor.y=peoplePosArr[index].y;

						peopleHolder.addChild(chancellor);

						dx=craw.x + 50;
						TweenLite.to(craw, 1, {x: dx, onComplete: function():void {
							chancellor.addEventListener(TouchEvent.TOUCH, onChancellorTouch);
							showHint(chancellor.x + 50, chancellor.y, hintArr[index]);
						}});
					}
					break;
				}

				case 1:
				{
					if (!wen)
					{
						show=true
						wen=getImage("wen");
						wen.x=peoplePosArr[index].x;
						wen.y=peoplePosArr[index].y;
						peopleHolder.addChild(wen);

						var wenchen:Image=getImage("wenguan");
						wenchen.x=832;
						wenchen.y=417;
						peopleHolder.addChild(wenchen);
						wenchen.touchable=false;

						dx=craw.x - 134;
						TweenLite.to(craw, 1, {x: dx, onComplete: function():void {
							wen.addEventListener(TouchEvent.TOUCH, onWenTouch);
							showHint(wen.x + 200, wen.y + 20, hintArr[index]);
						}});
					}
					break;
				}

				case 2:
				{
					if (!wu)
					{
						show=true;
						wu=getImage("wu");
						wu.x=peoplePosArr[index].x;
						wu.y=peoplePosArr[index].y;

						peopleHolder.addChild(wu);

						var wuchen:Image=getImage("wuguan");
						wuchen.x=1629;
						wuchen.y=423;
						peopleHolder.addChild(wuchen);
						wuchen.touchable=false;

						dx=craw.x + 130;
						TweenLite.to(craw, 1, {x: dx, onComplete: function():void {
							wu.addEventListener(TouchEvent.TOUCH, onWuTouch);
							showHint(wu.x + 50, wu.y + 20, hintArr[index]);
						}});

					}
					break;
				}

				default:
				{
					break;
				}
			}

			if (show)
				SoundAssets.playSFX("popup");

			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			showAchievement(21, sceneOver);
		}

		private function onChancellorTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation()
			var tc:Touch=e.getTouch(chancellor, TouchPhase.ENDED);
			if (tc)
				showHint(chancellor.x + 50, chancellor.y, hintArr[0]);
		}

		private function onWenTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation()
			var tc:Touch=e.getTouch(wen, TouchPhase.ENDED);
			if (tc)
				showHint(wen.x + 200, wen.y + 20, hintArr[1]);
		}

		private function onWuTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation()
			var tc:Touch=e.getTouch(wu, TouchPhase.ENDED);
			if (tc)
				showHint(wu.x + 50, wu.y + 20, hintArr[2]);
		}

		private function showHint(_x:Number, _y:Number, content:String, align:int=1):void
		{
			Prompt.showTXT(_x, _y, content, 20, null, bgHolder, align, true);
		}

		private var chancellor:Image;
		private var wen:Image;
		private var wu:Image;
		private var peopleHolder:Sprite;

		override public function dispose():void
		{
			super.dispose();
			if (acc)
				acc.removeEventListener(AccelerometerEvent.UPDATE, onUpdate);
		}

		private var shakeHintCount:String="shakeHintCount";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(3);

		private function onEnterFrame(e:Event):void
		{
			bgHolder.x-=speedX;
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

			if (!needHint)
				return;
			if (isMoved || (leftHit || rightHit))
			{
				if (hintShow)
				{
					hintShow.removeChildren();
					hintShow.removeFromParent(true);
				}
				needHint=false;
				//				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
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
		private var needHint:Boolean;
		private var king:Sprite;

		protected function onUpdate(event:AccelerometerEvent):void
		{
			speedX=event.accelerationX * 50;
		}
	}
}


