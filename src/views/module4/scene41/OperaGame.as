package views.module4.scene41
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import events.OperaSwitchEvent;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;
	import views.module4.Scene41;

	public class OperaGame extends PalaceGame
	{
		public function OperaGame(am:AssetManager=null)
		{
			super(am);
			addChild(getImage("gamebg"));
			initStart();
		}

		private var startHolder:Sprite;
		private var gameHolder:Sprite;
		private var endHolder:Sprite;

		private var operaIndex:int=0; //0-西游,1-水浒

		private var crtOperaName:String;
		private var operaArr:Array=["xiyou", "san"];

		private var crtB_HPosArr:Array; //头,身子 相对位置
		private var xiyouB_PosArr:Array=[new Point(33, 107), new Point(26, 109),
			new Point(-3, 98), new Point(-7, 88), new Point(21, 123), new Point(-3, 87)];
		private var sanB_PosArr:Array=[new Point(), new Point(),
			new Point(), new Point(), new Point(), new Point()];

		private var crtMaskPosArr:Array; //脸谱,相对位置
		private var xiyouMaskPosArr:Array=[new Point(30, 44), new Point(13, 55),
			new Point(30, 37), new Point(7, 23), new Point(28, 69), new Point(16, 43)];

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
			var startBtn:ElasticButton=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down");
			startBtn.addEventListener(ElasticButton.CLICK, onStartClick);
			startHolder.addChild(startBtn);
			startBtn.x=512;
			startBtn.y=650;

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
			closeBtn.visible=closeBtn.touchable=false;

			TweenLite.delayedCall(.5, function():void {
				var e:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.OPEN);
				scene.onOperaSwitch(e);
			});
//			dispatchEvent(e);
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			closeGame();
		}

		private function onStartClick(e:Event):void
		{
			var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE_OPEN, shureStart, initGame);
			scene.onOperaSwitch(e1);
		}

		private function initGame():void
		{
			removeChild(startHolder);
			startHolder.dispose();
			startHolder=null;

			crtOperaName=operaArr[operaIndex];
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

		private function onEnterFrame(e:Event):void
		{
			ropeSP.graphics.clear();
			ropeSP.graphics.lineStyle(2, 0x99ccff);
			for each (var body:OperaBody in bodyArr)
			{
				if (body)
				{
					body.shake();

					ropeSP.graphics.moveTo(body.stagePt.x, -200);
					ropeSP.graphics.lineTo(body.x, body.y);
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
		private var closeBtn:ElasticButton;

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
				body.reset();
				body.playEnter();
				bodyArr[index]=body;
				var sp:Sprite=spArr[int(index / 2)];
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
					if (body.getBounds(this).containsPoint(pt) && mask.type == body.type && !body.isMatched && body.ready)
					{
						body.addMask(mask);
						mask.removeEventListener(TouchEvent.TOUCH, onMaskTouch);
						TweenLite.delayedCall(1, function():void {
							removeOneBody(body);
						});
						addOneMask(mask.index, false);
						return;
					}
			}
			mask.reset();
		}

		private static const gameResult:String="operagameresult";
		private var gameOver:Boolean;

		private var _score:int;
		public var scene:Scene41;

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
			addChild(endHolder);
			endHolder.x=-1024;
			//			score=10000;
			//			life=3;
			var isRecord:Boolean=false;
			if (life > 0 && score > 0)
			{
				var win:Image=getImage("win-panel");
				endHolder.addChild(win);
				win.x=222;
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

				var dishgameresult:int=SOService.instance.getSO(gameResult) as int;

				var scoreTXT:TextField=new TextField(300, 80, "");
				scoreTXT.fontSize=48;
				scoreTXT.color=0xb83d00;
				scoreTXT.x=420;
				scoreTXT.y=280;
				endHolder.addChild(scoreTXT);

				var recordTXT:TextField=new TextField(100, 40, "");
				recordTXT.fontSize=24;
				recordTXT.color=0xb83d00;
				recordTXT.x=520;
				recordTXT.y=370;
				endHolder.addChild(recordTXT);

				if (!dishgameresult || dishgameresult < score)
				{
					scoreTXT.text=recordTXT.text=score.toString();
					isRecord=true;
					SOService.instance.setSO(gameResult, score);
				}
				else
				{
					scoreTXT.text=score.toString();
					recordTXT.text=dishgameresult.toString();
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

			TweenLite.to(gameHolder, .5, {x: 1024});

			TweenLite.to(endHolder, .5, {x: 0, onComplete: function():void {
				rsBtn.addEventListener(ElasticButton.CLICK, restartGame);
				closeBtn.visible=closeBtn.touchable=true;
				if (isRecord)
					showRecord();
			}});
		}

		private function restartGame(e:Event=null):void
		{
			var e1:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.CLOSE_OPEN, null, function():void {
				dispatchEvent(new Event("gameRestart"));
			});
			scene.onOperaSwitch(e1);
		}

		private function closeGame():void
		{
			dispatchEvent(new Event("gameOver"));
		}

		private function showRecord():void
		{
			var recordIcon:Image=getImage("record");
			endHolder.addChild(recordIcon);
			recordIcon.x=636;
			recordIcon.y=327;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut});
		}
	}
}
