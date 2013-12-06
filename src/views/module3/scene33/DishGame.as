package views.module3.scene33
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.base.PalaceGame;

	public class DishGame extends PalaceGame
	{
		private var dishNum:int=6;

		private var posArr:Vector.<Point>=new Vector.<Point>(dishNum);
		private var areaArr:Vector.<Rectangle>=new Vector.<Rectangle>(dishNum);

		private var kingArea:Rectangle;
		private var jarArea:Rectangle;
		private var stageArea:Rectangle=new Rectangle(0, 0, 1024, 768);

		private var dishW:Number=166;
		private var dishH:Number=138;

		private var dataArr:Array=["1", "2", "3", "4", "5", "6", "7", "8"];
		private var crtdataArr:Vector.<String>=new Vector.<String>(dishNum);
		private var dishArr:Vector.<Dish>=new Vector.<Dish>(dishNum);
		private var dishHolder:Sprite;

		private var pin:Sprite;
		private var pinMove:Boolean;
		private var pinNormal:Image;
		private var pinPoison:Image;
		private var _poisonTest:Boolean;
		private var crtDish:Dish;
		private var speedX:Number;
		private var speedY:Number;
		private var upHand:Sprite;
		private var downHand:Sprite;

		public function get poisonTest():Boolean
		{
			return _poisonTest;
		}

		public function set poisonTest(value:Boolean):void
		{
			_poisonTest=value;
			pinNormal.visible=!value;
			pinPoison.visible=value;
		}

		private var startSP:Sprite=new Sprite();
		private var gameSP:Sprite=new Sprite();
		private var endSP:Sprite=new Sprite();

		public function DishGame(am:AssetManager=null)
		{
			super(am);
			addBG();

			initStart();

			addClose();
		}

		private function initStart():void
		{
			addChild(startSP);
			var hint:Image=getImage("dish-hint")
			hint.x=206;
			hint.y=45;
			startSP.addChild(hint);

			startBtn=new ElasticButton(getImage("sbtn"), getImage("sbtn-down"));
			startSP.addChild(startBtn);
			startBtn.x=837;
			startBtn.y=552;
			startBtn.addEventListener(ElasticButton.CLICK, onStart);
			shakeNext();

			var sbHolder:Sprite=new Sprite();
			sBtn=getImage("menu-simple");
			sBtnD=getImage("menu-simple-down");
			sbHolder.x=311;
			sbHolder.y=477;
			sbHolder.addChild(sBtn);
			sbHolder.addChild(sBtnD);
			startSP.addChild(sbHolder);
			sbHolder.addEventListener(TouchEvent.TOUCH, onSBTouch);

			var hbHolder:Sprite=new Sprite();
			hBtn=getImage("menu-hard");
			hBtnD=getImage("menu-hard-down");
			hbHolder.x=308;
			hbHolder.y=562;
			hbHolder.addChild(hBtn);
			hbHolder.addChild(hBtnD);
			startSP.addChild(hbHolder);
			hbHolder.addEventListener(TouchEvent.TOUCH, onHBTouch);

			gamelevel=0;
		}

		private function onHBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED)
			if (tc)
				gamelevel=1;
		}

		private function onSBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED)
			if (tc)
				gamelevel=0;
		}

		public function get gamelevel():int
		{
			return _gamelevel;
		}

		public function set gamelevel(value:int):void
		{
			_gamelevel=value;
			if (!sBtn)
				return;
			switch (value)
			{
				case 0:
				{
					sBtn.visible=hBtnD.visible=false;
					sBtnD.visible=hBtn.visible=true;
					break;
				}

				case 1:
				{
					sBtn.visible=hBtnD.visible=true;
					sBtnD.visible=hBtn.visible=false;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function shakeNext():void
		{
			if (startBtn)
				TweenMax.to(startBtn, 1, {shake: {x: 5, numShakes: 4}, onComplete: function():void
				{
					TweenLite.delayedCall(5, shakeNext);
				}});
		}

		private function onStart(e:Event):void
		{
			closeBtn.visible=closeBtn.touchable=false;
			startBtn.touchable=false;
			startGame();
		}

		public function startGame():void
		{
			startBtn.removeEventListener(ElasticButton.CLICK, onStart);
			removeChild(startSP);
			addChild(gameSP);
			initBG();

			addMask(.7, false);
			intro=getImage("dish-info");
			intro.x=175;
			intro.y=124;
			addChild(intro);
			addEventListener(TouchEvent.TOUCH, onSkipIntro);
		}

		private function onSkipIntro(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			intro.removeFromParent(true);
			removeEventListener(TouchEvent.TOUCH, onSkipIntro);
			removeMask();

			initAreas();
			initDishes();
			initPin();
			initInfo();

			playKing(Math.random() > .5 ? 0 : 2);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function initInfo():void
		{
			infoHolder=new Sprite();
			gameSP.addChild(infoHolder);
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

		private var maxtime:int=30;
		private var hz:int=30;
		private var totalTime:int=maxtime * hz;

		private var lifeIconArr:Array=[];

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
			scoreTF.vAlign="top";
			infoHolder.addChild(scoreTF);
			scoreTF.x=885;
			scoreTF.y=20;
			life=3;
			score=0;
		}

		private function initTime():void
		{
			timer=new Timer(1000 / hz);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
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

		private function initPin():void
		{
			pin=new Sprite();
			pinNormal=getImage("dish-pin");
			pinPoison=getImage("dish-pin-poison");

			pin.addChild(pinNormal);
			pin.addChild(pinPoison);

			poisonTest=false;

			pin.pivotX=pinNormal.width >> 1;
			pin.pivotY=pinNormal.height >> 1;
			gameSP.addChild(pin);
			pin.x=40;
			pin.y=200;
			pin.addEventListener(TouchEvent.TOUCH, onPinTouch);
		}

		private function initDishes():void
		{
			for (var j:int=0; j < dishNum; j++)
			{
				setOneData(j);
			}

			flyVec=assetManager.getTextures("flyMC");

			SoundAssets.playSFX("dishon");
			for (var i:int=0; i < dishNum; i++)
			{
				addOneDish(i, true);
			}
		}

		private function setOneData(j:int):void
		{
			var length:int=dataArr.length
			var index:int=Math.random() * length;
			var data:String=dataArr.splice(index, 1)[0];
			crtdataArr[j]=data;
		}

		private function addOneDish(i:int, isHand=false):void
		{
			var dish:Dish=new Dish();
			var img:Image=getImage("dish" + crtdataArr[i]);
			dish.index=i;
			dish.addContent(img);
			dish.pt=posArr[i];
			dish.isPoison=getPoison();
			if (gamelevel == 1)
			{
				dish.scoreCut=scoreCut;
				dish.countBG=getImage("body-countdown");
				dish.fly=new MovieClip(flyVec, 18);
			}
			dishHolder.addChild(dish);

			if (isHand)
			{
				dish.y=dish.y + (i >= 3 ? 384 : -384);
				playHand(i);

				dish.tweenMove(function():void {
					SoundAssets.playSFX("dishon", true);
					if (gamelevel == 1)
						dish.addCount();
					dishArr[i]=dish;
					dish.addEventListener(TouchEvent.TOUCH, onDishTouch);
				})
			}
			else
			{
				if (gamelevel == 1)
					dish.addCount();
				dish.addEventListener(TouchEvent.TOUCH, onDishTouch);
				dishArr[i]=dish;
			}
		}

		private function scoreCut():void
		{
			score-=100;
		}

		private var flyVec:Vector.<Texture>;

		private function playHand(index:int):void
		{
			var rect:Rectangle=areaArr[index];
			var dx:Number;
			if (index < 3)
			{
				dx=rect.x + rect.width;
				TweenLite.killTweensOf(upHand);
				upHand.x=dx;
				upHand.y=upY;

				TweenLite.to(upHand, .3, {y: upDY, onComplete: function():void {
					TweenLite.to(upHand, .3, {y: upY});
				}});
			}
			else
			{
				dx=rect.x + rect.width;
				TweenLite.killTweensOf(downHand);
				downHand.x=dx;
				downHand.y=downY;

				TweenLite.to(downHand, .3, {y: downDY, onComplete: function():void {
					TweenLite.to(downHand, .3, {y: downY});
				}});
			}


		}

		private function getPoison():Boolean
		{
			return Math.random() > .8;
		}

		private function onDishTouch(e:TouchEvent):void
		{
			if (gameOver)
				return;
			var dish:Dish=e.currentTarget as Dish;

			if (!dish)
				return;

			var tc:Touch=e.getTouch(dish);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					if (!dish.isFlying)
					{
						TweenLite.killTweensOf(dish);
						dishHolder.setChildIndex(dish, dishHolder.numChildren - 1);
						crtDish=dish;
					}
					break;
				}

				case TouchPhase.MOVED:
				{
					if (crtDish)
					{
						var move:Point=tc.getMovement(crtDish);
						speedX=move.x;
						speedY=move.y;
						crtDish.x=pt.x;
						crtDish.y=pt.y;
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					if (crtDish)
					{
						if (checkArea(crtDish))
						{
							crtDish.removeEventListener(TouchEvent.TOUCH, onDishTouch);
						}
						else
						{
							var speed:Number=Math.sqrt(speedX * speedX + speedY * speedY);
							if (speed > 10)
							{
								crtDish.isFlying=true;
								var angle:Number=Math.atan2(speedY, speedX);
								if (speed > 30)
									speed=30;
								crtDish.speedX=Math.cos(angle) * speed;
								crtDish.speedY=Math.sin(angle) * speed;
								crtDish.removeEventListener(TouchEvent.TOUCH, onDishTouch);
							}
							else
							{
								crtDish.tweenMove();
							}
						}
					}

					//reset
					speedX=0;
					speedY=0;
					crtDish=null;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function onEnterFrame(e:Event):void
		{
			if (gameOver)
				return;
			var crtIndex:int=-1;
			if (pinMove)
			{
				for (var i:int=0; i < areaArr.length; i++)
				{
					var rect:Rectangle=areaArr[i];
					if (rect.contains(pin.x, pin.y))
					{
						var dish:Dish=dishArr[i];
						if (dish)
						{
							crtIndex=dish.index;
							dish.tested=true;
							poisonTest=dish.isPoison;
						}
						break;
					}
				}
				if (crtIndex < 0)
					poisonTest=false;
			}

			for each (var _dish:Dish in dishArr)
			{
				if (_dish)
				{
					if (_dish.isFlying)
					{
						_dish.x+=_dish.speedX;
						_dish.y+=_dish.speedY;
						checkArea(_dish);
					}
					else if (gamelevel == 1)
						_dish.countDown();
				}
			}
		}

		private function onPinTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(pin);
			if (!tc || gameOver)
				return;
			e.stopImmediatePropagation();
			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					TweenLite.killTweensOf(pin);
					pin.rotation=-Math.PI / 6;
					pinMove=true;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (pinMove)
					{
						pin.x=pt.x;
						pin.y=pt.y;
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					if (pinMove)
					{
						TweenLite.to(pin, .3, {x: 40, y: 200, rotation: 0});
					}
					pinMove=false;
					poisonTest=false;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private var _life:int;

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
					gameOver=true;

				TweenMax.to(img, 1, {shake: {rotation: .2, numShakes: 4}});
				TweenLite.delayedCall(.21, function():void {
					infoHolder.removeChild(img);
					lifeIconArr[value]=newImg;
					infoHolder.addChild(newImg);
				})
			}
		}

		private var gameOver:Boolean;

		private function gameOverHandler():void
		{
			gameOver=true;
			timer.stop();

			LionMC.instance.play((life > 0 && score > 0) ? 1 : 4, 0, 0, initResult, 2);

//			TweenLite.delayedCall(.5, initResult);
		}

		private function initResult():void
		{
			addChild(endSP);
			endSP.x=-1024;
//			score=5000;
//			life=3;
			var isRecord:Boolean=false;
			if (life > 0 && score > 0)
			{
				isWin=true;
				var win:Image=getImage("win-panel");
				endSP.addChild(win);
				win.x=1024 - win.width >> 1;
				win.y=30;

				for (var i:int=0; i < life; i++)
				{
					var star1:Image=getImage("star-red");
					star1.x=412 + i * 76;
					star1.y=214;
					endSP.addChild(star1);
				}

				for (var j:int=life; j < 3; j++)
				{
					var star2:Image=getImage("star-grey");
					star2.x=412 + j * 76;
					star2.y=214;
					endSP.addChild(star2);
				}

				var gameResultlvl:String=gameResult + gamelevel.toString();
				var dishgameresult:int=SOService.instance.getSO(gameResultlvl) as int;

				var t1:TextField=new TextField(200, 100, "得分：", FontVo.PALACE_FONT, 48, 0xb83d00);
				t1.vAlign="top";
				t1.hAlign="left";
				t1.x=332;
				t1.y=277;
				endSP.addChild(t1);
				var t2:TextField=new TextField(200, 40, "最高：", FontVo.PALACE_FONT, 26, 0xb83d00);
				t2.vAlign="top";
				t2.hAlign="left";
				t2.x=362;
				t2.y=370;
				endSP.addChild(t2);

				var scoreTXT:TextField=new TextField(200, 100, "");
				scoreTXT.fontSize=48;
				scoreTXT.color=0xb83d00;
				scoreTXT.x=490;
				scoreTXT.y=280;
				scoreTXT.vAlign="top"
				scoreTXT.hAlign="right";
				endSP.addChild(scoreTXT);

				var recordTXT:TextField=new TextField(100, 40, "");
				recordTXT.fontSize=24;
				recordTXT.color=0xb83d00;
				recordTXT.x=520;
				recordTXT.y=370;
				recordTXT.vAlign="top"
				recordTXT.hAlign="right";
				endSP.addChild(recordTXT);

				if (!dishgameresult || dishgameresult < score)
				{
					scoreTXT.text=recordTXT.text=score.toString();
					isRecord=true;
					SOService.instance.setSO(gameResultlvl, score);
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
				endSP.addChild(lose);
				lose.x=(1024 - lose.width) / 2;
				lose.y=0;
			}

			rsBtn=new ElasticButton(getImage("restart"));
			rsBtn.shadow=getImage("restart-light");
			rsBtn.x=512;
			rsBtn.y=512;
			endSP.addChild(rsBtn);

			TweenLite.to(gameSP, .5, {x: 1024});

			TweenLite.to(endSP, .5, {x: 0, onComplete: function():void {
				rsBtn.addEventListener(ElasticButton.CLICK, restartGame);
				closeBtn.visible=closeBtn.touchable=true;
				if (isRecord)
					showRecord();
			}});
		}

		private function showRecord():void
		{
			var recordIcon:Image=getImage("record");
			endSP.addChild(recordIcon);
			recordIcon.x=636;
			recordIcon.y=327;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut, onComplete: function():void {
				SoundAssets.playSFX("gamerecord");
			}});
		}

		private function restartGame(e:Event=null):void
		{
			dispatchEvent(new Event(PalaceGame.GAME_RESTART));
		}

		private var _score:int;

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score=value;
			scoreTF.text=_score.toString();
		}

		private function checkArea(_dish:Dish):Boolean
		{
			//king,jar,out
			var index:int=_dish.index;
			var pt:Point=new Point(_dish.x, _dish.y);
			var isClassed:Boolean=false;
			var isOut:Boolean=false;
			var dx:Number;
			var dy:Number;
			if (kingArea.containsPoint(pt))
			{
				dx=kingArea.x + kingArea.width / 2 + 10;
				dy=kingArea.y + kingArea.height / 2 + 50;
				isClassed=true;

				if (!_dish.tested || _dish.isPoison || _dish.isBad)
				{
					SoundAssets.playSFX("kingpoison", true);
					life--;
					playKing(4);
				}
				else
				{
					SoundAssets.playSFX("kingeat", true);
					score+=100;
					playKing(3);
				}
			}
			else if (jarArea.containsPoint(pt))
			{
				dx=jarArea.x + jarArea.width / 2;
				dy=jarArea.y + jarArea.height / 2;
				isClassed=true;

				if (_dish.isBad)
				{
					score+=50;
					playKing(0);
				}
				else
				{
					if (_dish.tested && _dish.isPoison)
					{
						score+=100;
						playKing(0);
					}
					else
					{
						life--;
						playKing(Math.random() > .5 ? 1 : 2);
					}
				}
			}
			else if (!stageArea.containsPoint(pt))
			{
				SoundAssets.playSFX("dishout", true);
				isOut=true;
				life--;
				playKing(Math.random() > .5 ? 1 : 2);
			}

			if (isClassed)
			{
				_dish.isFlying=false;
				dishArr[index]=null;
				TweenLite.to(_dish, .3, {x: dx, y: dy, scaleX: .2, scaleY: .2, onComplete: function():void {
					if (gameOver) {
						dishHolder.removeChild(_dish);
						_dish.dispose();
						_dish=null;
						gameOverHandler();
						return;
					}
					dataArr.push(crtdataArr[index]);
					setOneData(index);
					addOneDish(index, true);
					dishHolder.removeChild(_dish);
					_dish.dispose();
					_dish=null;
				}});
				return true;
			}
			else if (isOut)
			{
				_dish.isFlying=false;
				dishArr[index]=null;
				TweenLite.to(_dish, .3, {scaleX: .2, scaleY: .2, onComplete: function():void {
					if (gameOver) {
						dishHolder.removeChild(_dish);
						_dish.dispose();
						_dish=null;
						gameOverHandler();
						return;
					}
					dataArr.push(crtdataArr[index]);
					setOneData(index);
					addOneDish(index, true);
					dishHolder.removeChild(_dish);
					_dish.dispose();
					_dish=null;
				}});
				return true;
			}
			else
				return false;
		}

		private function initBG():void
		{
			var table:Image=getImage("dish-table");
			table.y=132;
			gameSP.addChild(table);

			kingHolder=new Sprite();
			var kingBG:Image=getImage("dish-king-bg");
			kingBG.x=1024 - kingBG.width;
			kingBG.y=62;
			gameSP.addChild(kingHolder);
			kingHolder.addChild(kingBG);
			kingArea=new Rectangle(kingBG.x, kingBG.y, kingBG.width, kingBG.height);

			playKing(Math.random() > .5 ? 0 : 2);

			var jar:Image=getImage("dish-jar");
			jar.x=1024 - jar.width;
			jar.y=768 - jar.height;
			gameSP.addChild(jar);

			jarArea=new Rectangle(jar.x, jar.y, jar.width, jar.height);

			upHand=new Sprite();
			upHand.addChild(getImage("dish-hand"));
			upHand.y=upY;
			gameSP.addChild(upHand);
			upHand.rotation=Math.PI;
			upHand.touchable=false;

			downHand=new Sprite();
			downHand.addChild(getImage("dish-hand"));
			downHand.y=downY;
			gameSP.addChild(downHand);
			downHand.touchable=false;

			dishHolder=new Sprite();
			gameSP.addChild(dishHolder);
		}

		private var expArr:Array=["高兴", "无聊", "平时", "吃饭", "中毒"];

		/**
		 * @param 0:高兴,1:无聊,2:平时,3:吃饭,4:中毒
		 * */
		private function playKing(index:int):void
		{
			if (king)
			{
				Starling.juggler.remove(king);
				king.stop();
				king.removeFromParent(true);
				king=null;
			}
			king=new MovieClip(assetManager.getTextures(expArr[index]), 18);
			king.x=kingArea.x + 50;
			king.y=kingArea.y + 30;
			kingHolder.addChild(king);
			Starling.juggler.add(king);
			king.loop=0;
			king.play();
		}

		private var upY:Number=0;
		private var upDY:Number=211;

		private var downY:Number=768;
		private var downDY:Number=557;

		private var scoreTF:TextField;

		private var startBtn:ElasticButton;

		private var infoHolder:Sprite;

		private var timeprogress:Sprite;

		private var timer:Timer;
		private var rsBtn:ElasticButton;

		private var king:MovieClip;

		private var kingHolder:Sprite;
		private var sBtn:Image;
		private var sBtnD:Image;
		private var hBtn:Image;
		private var hBtnD:Image;
		private var _gamelevel:int;

		private var intro:Image;

		private function initAreas():void
		{
			for (var i:int=0; i < dishNum; i++)
			{
				var pt:Point=new Point(140 + 243 * (i % 3), 280 + 260 * int(i / 3));
				posArr[i]=pt;
				areaArr[i]=new Rectangle(pt.x - dishW / 2 - 50, pt.y - dishH / 2 - 100, dishW + 50, dishH + 100);
			}
		}
	}
}
