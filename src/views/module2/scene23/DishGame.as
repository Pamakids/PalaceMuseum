package views.module2.scene23
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;
	import views.global.TopBar;

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
			addChild(getImage("gamebg"))

			addChild(startSP);
			var hint:Image=getImage("dish-hint")
			hint.x=46;
			hint.y=51;
			startSP.addChild(hint);

			startBtn=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down")
			startSP.addChild(startBtn);
			startBtn.x=856;
			startBtn.y=665;
			startBtn.addEventListener(ElasticButton.CLICK, onStart);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
			closeBtn.visible=closeBtn.touchable=false;
		}

		private function onStart(e:Event):void
		{
			startBtn.touchable=false;
			startGame();
		}

		public function startGame():void
		{
			startBtn.removeEventListener(ElasticButton.CLICK, onStart);
			removeChild(startSP);
			addChild(gameSP);
			initBG();
			initAreas();
			initDishes();
			initPin();
			initInfo();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
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

			for (var i:int=0; i < dishNum; i++)
			{
				addOneDish(i);
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
			dish.addChild(img);
			dish.pivotX=img.width >> 1;
			dish.pivotY=img.height >> 1;
			dish.pt=posArr[i];
			dish.isPoison=getPoison();

			dishHolder.addChild(dish);

			if (isHand)
			{
				dish.y=dish.y + (i >= 3 ? 384 : -384);
				playHand(i);

				dish.tweenMove(function():void {
					dishArr[i]=dish;
					dish.addEventListener(TouchEvent.TOUCH, onDishTouch);
				})
			}
			else
			{
				dish.addEventListener(TouchEvent.TOUCH, onDishTouch);
				dishArr[i]=dish;
			}
		}

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

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;
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
				if (_dish && _dish.isFlying)
				{
					_dish.x+=_dish.speedX;
					_dish.y+=_dish.speedY;
					checkArea(_dish);
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

			TweenLite.delayedCall(.5, initResult);
		}

		private static const gameResult:String="dishgameresult";

		public function isWin():Boolean
		{
			return life > 0 && score > 0;
		}

		private function initResult():void
		{
			addChild(endSP);
			endSP.x=-1024;
//			score=10000;
//			life=3;
			var isRecord:Boolean=false;
			if (life > 0 && score > 0)
			{
				var win:Image=getImage("win-panel");
				endSP.addChild(win);
				win.x=222;
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

				var dishgameresult:int=SOService.instance.getSO(gameResult) as int;

				var scoreTXT:TextField=new TextField(300, 80, "");
				scoreTXT.fontSize=48;
				scoreTXT.color=0xb83d00;
				scoreTXT.x=420;
				scoreTXT.y=280;
				endSP.addChild(scoreTXT);

				var recordTXT:TextField=new TextField(100, 40, "");
				recordTXT.fontSize=24;
				recordTXT.color=0xb83d00;
				recordTXT.x=520;
				recordTXT.y=370;
				endSP.addChild(recordTXT);

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
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut});
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			closeGame();
		}

		private function closeGame():void
		{
			dispatchEvent(new Event("gameOver"));
		}

		private function restartGame(e:Event=null):void
		{
			dispatchEvent(new Event("gameRestart"));
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
				dx=kingArea.x + kingArea.width / 2 - 10;
				dy=kingArea.y + kingArea.height / 2 + 60;
				isClassed=true;

				if (_dish.tested && !_dish.isPoison)
					score+=100;
				else
					life--;
			}
			else if (jarArea.containsPoint(pt))
			{
				dx=jarArea.x + jarArea.width / 2;
				dy=jarArea.y + jarArea.height / 2;
				isClassed=true;

				if (_dish.tested && _dish.isPoison)
					score+=100;
				else
					life--;
			}
			else if (!stageArea.containsPoint(pt))
			{
				isOut=true;
				life--;
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

			var king:Image=getImage("dish-king");
			king.x=1024 - king.width;
			king.y=62;
			gameSP.addChild(king);

			kingArea=new Rectangle(king.x, king.y, king.width, king.height);

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

			downHand=new Sprite();
			downHand.addChild(getImage("dish-hand"));
			downHand.y=downY;
			gameSP.addChild(downHand);

			dishHolder=new Sprite();
			gameSP.addChild(dishHolder);
		}

		private var upY:Number=0;
		private var upDY:Number=211;

		private var downY:Number=768;
		private var downDY:Number=557;

		private var scoreTF:TextField;

		private var startBtn:ElasticButton;

		private var closeBtn:ElasticButton;

		private var infoHolder:Sprite;

		private var timeprogress:Sprite;

		private var timer:Timer;
		private var rsBtn:ElasticButton;

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
