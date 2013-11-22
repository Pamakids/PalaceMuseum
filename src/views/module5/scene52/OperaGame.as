package views.module5.scene52
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.pamakids.manager.SoundManager;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import events.OperaSwitchEvent;

	import models.FontVo;
	import models.SOService;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class OperaGame extends PalaceGame
	{
		public function OperaGame(am:AssetManager=null)
		{
			SoundManager.instance.stop("main");
			super(am);
			addBG();
			initStart();
		}

		public var gamelevel:int=0; //0-西游,1-三国

		private var startHolder:Sprite;
		private var gameHolder:Sprite;
		private var endHolder:Sprite;

		private var crtOperaName:String;
		private var operaArr:Array=["xiyou", "sanguo"];

		private var crtB_HPosArr:Array; //头,身子 相对位置
		private var xiyouB_PosArr:Array=[new Point(33, 107), new Point(-31, 86),
										 new Point(-3, 98), new Point(-7, 88), new Point(21, 123), new Point(-3, 87)];
		private var sanguoB_PosArr:Array=[new Point(6, 114), new Point(21, 115),
										  new Point(22, 111), new Point(-16, 68), new Point(-6, 117), new Point(-32, 58)];

		private var crtMaskPosArr:Array; //脸谱,相对位置
		private var xiyouMaskPosArr:Array=[new Point(30, 44), new Point(32, 50),
										   new Point(30, 37), new Point(7, 23), new Point(28, 69), new Point(16, 43)];
		private var sanguoMaskPosArr:Array=[new Point(18, 41), new Point(15, 64),
											new Point(22, 50), new Point(25, 41), new Point(22, 54), new Point(6, 46)];

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
			var title:Image=getImage("operagame-hint");
			startHolder.addChild(title);

			xiyouBtn=new Sprite();
			var sBtn:Image=getImage("xiyou");
			var sBtnD:Image=getImage("xiyou-light");
			sBtn.visible=false;
			xiyouBtn.x=235;
			xiyouBtn.y=572;
			xiyouBtn.addChild(sBtn);
			xiyouBtn.addChild(sBtnD);
			startHolder.addChild(xiyouBtn);
			xiyouBtn.addEventListener(TouchEvent.TOUCH, onLevelSelect);

			sanguoBtn=new Sprite();
			var hBtn:Image=getImage("sanguo");
			var hBtnD:Image=getImage("sanguo-light");
			sanguoBtn.x=545;
			sanguoBtn.y=568;
			hBtnD.visible=false;
			sanguoBtn.addChild(hBtn);
			sanguoBtn.addChild(hBtnD);
			startHolder.addChild(sanguoBtn);
			sanguoBtn.addEventListener(TouchEvent.TOUCH, onLevelSelect);

			startBtn=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down");
			startBtn.addEventListener(ElasticButton.CLICK, onStartClick);
			startHolder.addChild(startBtn);
			startBtn.x=920;
			startBtn.y=666;
			shakeNext();

			addClose();

			TweenLite.delayedCall(.5, function():void {
				if (!fromCenter) {
					var e:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.OPEN);
					onOperaSwitch(e);}
			});
		}

		public var onOperaSwitch:Function;

		private function shakeNext():void
		{
			if (startBtn)
				TweenMax.to(startBtn, 1, {shake: {x: 5, numShakes: 4}, onComplete: function():void
				{
					TweenLite.delayedCall(5, shakeNext);
				}});
		}

		private function onLevelSelect(e:TouchEvent):void
		{
			var sp:Sprite=e.currentTarget as Sprite;
			if (!sp)
				return;
			var tc:Touch=e.getTouch(sp, TouchPhase.ENDED);
			if (!tc)
				return;
			var isXiyou:Boolean=(sp == xiyouBtn);
			if (isXiyou == (gamelevel == 0))
				return;
			xiyouBtn.getChildAt(0).visible=!isXiyou;
			xiyouBtn.getChildAt(1).visible=isXiyou;
			sanguoBtn.getChildAt(0).visible=isXiyou;
			sanguoBtn.getChildAt(1).visible=!isXiyou;
			gamelevel=isXiyou ? 0 : 1;
			trace(gamelevel);
		}

		override protected function onCloseClick(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseClick);
			if (fromCenter)
			{
				dispatchEvent(new Event(PalaceGame.GAME_OVER));
			}
			else
			{
				var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE, null, function():void {
					dispatchEvent(new Event(PalaceGame.GAME_OVER));
				});
				onOperaSwitch(e1);
			}
		}

		private function onStartClick(e:Event):void
		{
			if (!fromCenter)
			{
				if (onOperaSwitch != null)
				{
					var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE_OPEN, shureStart, initGame);
					onOperaSwitch(e1, true);
				}
			}
			else
			{
				initGame();
				shureStart();
			}
		}

		private function initGame():void
		{
			removeChild(startHolder);
			startHolder.dispose();
			startHolder=null;

			crtOperaName=operaArr[gamelevel];
			crtB_HPosArr=this[crtOperaName + "B_PosArr"];
			crtMaskPosArr=this[crtOperaName + "MaskPosArr"];

			gameHolder=new Sprite();
			addChild(gameHolder);
			gameHolder.addChild(getImage("bg-opera"));

			ropeSP=new Shape();
			gameHolder.addChild(ropeSP);

			for (var i:int=0; i < 3; i++)
			{
				var sp:Sprite=new Sprite();
				gameHolder.addChild(sp);
				spArr.push(sp);

				var rail:Image=getImage("railing" + (i + 1).toString());
				gameHolder.addChild(rail);
				rail.y=railYArr[i];
				rail.touchable=false;
			}

			addMasks();
			initInfo();

		}

		private function shureStart():void
		{
			SoundManager.instance.play("gamebg52");
			addBodys();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.start();
		}

		private var maxtime:int=30;
		private var hz:int=30;
		private var totalTime:int=maxtime * hz;

		private var lifeIconArr:Array=[];

		private function initInfo():void
		{
			infoHolder=new Sprite();
			gameHolder.addChild(infoHolder);
			infoHolder.touchable=false;

			infoHolder.addChild(getImage("scorebg"));
			infoHolder.addChild(getImage("lifeboard"));
			var scoreboard:Image=getImage("scoreboard");
			scoreboard.x=1024 - scoreboard.width;
			infoHolder.addChild(scoreboard);

			var timebg:Image=getImage("progressbg");
			timeprogress=new Sprite();
			timeprogress.addChild(getImage("progress"));
			timebg.x=timeprogress.x=246;
			timebg.y=timeprogress.y=9;
			infoHolder.addChild(timebg);
			infoHolder.addChild(timeprogress);
			timeprogress.clipRect=new Rectangle(30, 0, 470, 51);

			initScore();
			initTime();
		}

		private function initTime():void
		{
			timer=new Timer(1000 / hz);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		protected function onTimer(event:TimerEvent):void
		{
			totalTime--;
			if (totalTime > 0)
				timeprogress.clipRect.width=totalTime / (maxtime * hz) * 470;
			else
			{
				gameOverHandler();
			}
		}

		private function gameOverHandler():void
		{
			SoundManager.instance.stop("gamebg52");
			gameOver=true;
			timer.stop();

			TweenLite.delayedCall(2, initResult);
		}

		private function initScore():void
		{
			for (var i:int=0; i < 3; i++)
			{
				var lifeIcon:Image=getImage("lifeicon");
				lifeIcon.x=24 + 54 * i;
				lifeIcon.y=11;
				lifeIconArr.push(lifeIcon);
				infoHolder.addChild(lifeIcon);
			}

			scoreTF=new TextField(100, 40, "");
			scoreTF.fontSize=24;
			scoreTF.color=0xb83d00;
			infoHolder.addChild(scoreTF);
			scoreTF.x=885;
			scoreTF.y=20;
			life=3;
			score=0;
		}

		private var ropeTexture:Texture;

		private function onEnterFrame(e:Event):void
		{
//			ropeSP.graphics.clear();
//			ropeSP.graphics.lineStyle(3, 0x99ccff);
			for each (var body:OperaBody in bodyArr)
			{
				if (body)
				{
					body.shake();
					var rope:Shape=body.rope;

					if (rope)
					{
						rope.graphics.clear();
//						rope.graphics.lineTexture(3, ropeTexture);
						rope.graphics.lineStyle(3, 0x99ccff);
						rope.graphics.moveTo(body.stagePt.x, -200);
						rope.graphics.lineTo(body.x, body.y);
					}
					if (!gameOver)
						body.countDown();
					if (body.timeCount == 0 && body.ready)
						removeOneBody(body);
				}
			}
		}

		private var length:int=6;
		private var railYArr:Array=[257, 494, 720];
		private var spArr:Array=[];
		private var bodyArr:Vector.<OperaBody>=new Vector.<OperaBody>(length);
		private var typeArr:Array=["1", "2", "3", "4", "5", "6"];

		private var bodyPosArr:Array=[new Point(100, 230), new Point(500, 230),
									  new Point(300, 465), new Point(700, 465), new Point(200, 708), new Point(600, 708)]; //人偶位置

		private var ropeSP:Shape;
		private var infoHolder:Sprite;
		private var timeprogress:Sprite;
		private var timer:Timer;
		private var scoreTF:TextField;
		private var _life:int;
		private var rsBtn:ElasticButton;

		private var hardNess:int=3;

		private function addBodys():void
		{
			for (var i:int=0; i < hardNess; i++)
			{
				addRandomBody();
			}
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life=value;
			if (value < lifeIconArr.length)
			{
				var img:Image=lifeIconArr[value] as Image;

				var newImg:Image=getImage("lifeicon-lost");
				newImg.x=img.x;
				newImg.y=img.y;

				if (value == 0)
				{
//					gameOver=true;
					gameOverHandler();
				}

				TweenMax.to(img, 1, {shake: {rotation: .2, numShakes: 4}});
				TweenLite.delayedCall(.21, function():void {
					infoHolder.removeChild(img);
					lifeIconArr[value]=newImg;
					infoHolder.addChild(newImg);
				})
			}
		}

		private function addRandomBody():void
		{
			addOneBody(int(Math.random() * length))
		}

		private function addOneBody(index:int):void
		{
			if (gameOver)
				return;
			if (bodyArr[index])
				addRandomBody();
			else
			{
				var body:OperaBody=new OperaBody();
				var typeIndex:int=Math.random() * typeArr.length; //随机类型
				body.index=index;
				var type:String=typeArr[typeIndex];
				trace(type)
				body.type=type;
				body.body=getImage(crtOperaName + "body" + type);
				body.head=getImage(crtOperaName + "head" + type);
				body.countBG=getImage("body-countdown");
				body.stagePt=bodyPosArr[index] //位置 by index
				body.offsetsXY=crtB_HPosArr[typeIndex];
				body.maskPos=crtMaskPosArr[typeIndex]; //相对位置 by type
				if (typeIndex == 5 && gamelevel == 1)
					body.fixY=38;
				body.reset();
				body.playEnter();
				var rope:Shape=new Shape();
				body.rope=rope;
				bodyArr[index]=body;
				var sp:Sprite=spArr[int(index / 2)];
				sp.addChild(rope);
				sp.addChild(body);
			}
		}

		private function removeOneBody(body:OperaBody):void
		{
			if (gameOver)
				return;
			if (body.isMatched)
				score+=1000;
			else
				life--;
			body.playExit(function():void {
				body.rope.removeFromParent(true);
				body.removeFromParent(true);
				bodyArr[body.index]=null;
				addRandomBody();
			});
		}

		private function addMasks():void
		{
			var bar:Image=getImage("head-bg");
			bar.touchable=false;
			bar.x=918;
			bar.y=122;
			gameHolder.addChild(bar);
			for (var i:int=0; i < length; i++)
			{
				addOneMask(i);
			}
		}

		private function addOneMask(index:int, isInit:Boolean=true):void
		{
			if (gameOver)
				return;
			var mask:OperaMask=new OperaMask();
			var type:String=typeArr[index];
			mask.index=index;
			mask.type=type;
			var img:Image=getImage(crtOperaName + "mask" + type);
			mask.addChild(img);
			mask.pivotX=img.width >> 1;
			mask.pivotY=img.height >> 1;
			gameHolder.addChild(mask);
			mask.addEventListener(TouchEvent.TOUCH, onMaskTouch);

			if (index == 0)
				mask.scaleX=mask.scaleY=.8;
			else if (gamelevel == 1)
				mask.scaleX=mask.scaleY=.9;

			if (!isInit)
			{
				var dx:Number=mask.x;
				mask.x=1100;
				TweenLite.to(mask, .5, {x: dx});
			}
		}

		private function onMaskTouch(e:TouchEvent):void
		{
			var mask:OperaMask=e.currentTarget as OperaMask;
			if (!mask || gameOver)
				return;
			var tc:Touch=e.getTouch(mask);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					mask.parent.setChildIndex(mask, mask.parent.numChildren - 1);
					TweenLite.killTweensOf(mask);
					break;
				}

				case TouchPhase.MOVED:
				{
					var move:Point=tc.getMovement(this);
					mask.x+=move.x;
					mask.y+=move.y;
					break;
				}

				case TouchPhase.ENDED:
				{
					checkMask(pt, mask)
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkMask(pt:Point, mask:OperaMask):void
		{
			for each (var body:OperaBody in bodyArr)
			{
				if (body)
					if (body.getBounds(this).containsPoint(pt))
						if (mask.type == body.type && !body.isMatched && body.ready)
						{
							SoundManager.instance.play("maskok");
							body.addMask(mask);
							mask.removeEventListener(TouchEvent.TOUCH, onMaskTouch);
							TweenLite.delayedCall(1, function():void {
								removeOneBody(body);
							});
							addOneMask(mask.index, false);
							return;
						}
						else
							SoundManager.instance.play("maskwrong");
			}
			mask.reset();
		}

		private var gameOver:Boolean;

		private var _score:int;

		private var xiyouBtn:Sprite;

		private var sanguoBtn:Sprite;

		private var startBtn:ElasticButton;

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score=value;
			scoreTF.text=_score.toString();
		}

		private function initResult():void
		{
			endHolder=new Sprite();
			var isRecord:Boolean=false;
			if (life > 0 && score > 0)
			{
				isWin=true;
				var win:Image=getImage("win-panel");
				endHolder.addChild(win);
				win.x=1024 - win.width >> 1;
				win.y=30;

				for (var i:int=0; i < life; i++)
				{
					var star1:Image=getImage("star-red");
					star1.x=412 + i * 76;
					star1.y=214;
					endHolder.addChild(star1);
				}

				for (var j:int=life; j < 3; j++)
				{
					var star2:Image=getImage("star-grey");
					star2.x=412 + j * 76;
					star2.y=214;
					endHolder.addChild(star2);
				}

				var operagameresult:int=SOService.instance.getSO(gameResult + gamelevel.toString()) as int;

				var t1:TextField=new TextField(200, 100, "得分：", FontVo.PALACE_FONT, 48, 0xb83d00);
				t1.vAlign="top";
				t1.hAlign="left";
				t1.x=332;
				t1.y=283;
				endHolder.addChild(t1);
				var t2:TextField=new TextField(200, 40, "最高：", FontVo.PALACE_FONT, 26, 0xb83d00);
				t2.vAlign="top";
				t2.hAlign="left";
				t2.x=362;
				t2.y=370;
				endHolder.addChild(t2);

				var scoreTXT:TextField=new TextField(220, 100, "");
				scoreTXT.fontSize=48;
				scoreTXT.color=0xb83d00;
				scoreTXT.x=470;
				scoreTXT.y=285;
				scoreTXT.vAlign="top";
				scoreTXT.hAlign="right";
				endHolder.addChild(scoreTXT);

				var recordTXT:TextField=new TextField(100, 40, "");
				recordTXT.fontSize=24;
				recordTXT.color=0xb83d00;
				recordTXT.x=520;
				recordTXT.y=370;
				endHolder.addChild(recordTXT);

				if (!operagameresult || operagameresult < score)
				{
					scoreTXT.text=recordTXT.text=score.toString();
					isRecord=true;
					SOService.instance.setSO(gameResult, score);
				}
				else
				{
					scoreTXT.text=score.toString();
					recordTXT.text=operagameresult.toString();
				}
			}
			else
			{
				var lose:Image=getImage("lose-panel");
				endHolder.addChild(lose);
				lose.x=(1024 - lose.width) / 2;
				lose.y=0;
			}

			rsBtn=new ElasticButton(getImage("restart"));
			rsBtn.shadow=getImage("restart-light");
			rsBtn.x=512;
			rsBtn.y=512;
			endHolder.addChild(rsBtn);

			if (fromCenter)
			{
				closeBtn.touchable=closeBtn.visible=true;
				setChildIndex(closeBtn, numChildren - 1);
			}
			else
			{
				closeBtn.touchable=closeBtn.visible=false;
				var nextShowBtn:ElasticButton=new ElasticButton(getImage("startShow"));
				nextShowBtn.shadow=getImage("startShow-light");
				nextShowBtn.x=1024 - 200;
				nextShowBtn.y=768 - 100;
				endHolder.addChild(nextShowBtn);
				nextShowBtn.addEventListener(ElasticButton.CLICK, onNextShow);
			}

			function closeCallBack():void {
				removeChild(gameHolder);
				addChild(endHolder);
			}

			function openCallback():void {
				rsBtn.addEventListener(ElasticButton.CLICK, restartGame);
				if (isRecord)
					showRecord();
			}
			if (fromCenter)
			{
				closeCallBack();
				openCallback();
			}
			else
			{
				var e:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE_OPEN, openCallback, closeCallBack);
				onOperaSwitch(e);
			}
		}

		private function onNextShow(e:Event):void
		{
			var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE, null, nextGame);
			onOperaSwitch(e1);
		}

		private function restartGame(e:Event=null):void
		{
			if (fromCenter)
			{
				dispatchEvent(new Event(PalaceGame.GAME_RESTART));
			}
			else
			{
				var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE_OPEN, null, function():void {
					dispatchEvent(new Event(PalaceGame.GAME_RESTART));
				});
				onOperaSwitch(e1);
			}
		}

		private function nextGame():void
		{
			dispatchEvent(new Event("nextGame"));
		}

		private function showRecord():void
		{
			var recordIcon:Image=getImage("record");
			endHolder.addChild(recordIcon);
			recordIcon.x=636;
			recordIcon.y=327;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut, onComplete: function():void {
				SoundManager.instance.play("gamerecord");
			}});
		}

		override public function dispose():void
		{
			SoundManager.instance.stop("gamebg52");
			SoundManager.instance.play("main");
			super.dispose();
		}
	}
}
