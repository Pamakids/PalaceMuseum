package views.module2.scene23
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.utils.SPUtils;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	public class DishGame extends PalaceScene
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

			startGame();
		}

		private function startGame():void
		{
			addChild(gameSP);
			initBG();
			initAreas();
			initDishes();
			initPin();
			initScore();
			initTime();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function initScore():void
		{
			lifeTF=new TextField(100, 50, "3");
			lifeTF.fontSize=24;
			lifeTF.color=0xffff00;
			gameSP.addChild(lifeTF);
			lifeTF.touchable=false;
			lifeTF.x=900;
			lifeTF.y=300;

			scoreTF=new TextField(100, 50, "0");
			scoreTF.fontSize=24;
			scoreTF.color=0xffff00;
			gameSP.addChild(scoreTF);
			scoreTF.x=900;
			scoreTF.y=370;
			lifeTF.touchable=false;
			life=3;
			score=0;
		}

		private function initTime():void
		{
			var time:Timer=new Timer(10);
			time.addEventListener(TimerEvent.TIMER, onTimer);
			time.start();
		}

		protected function onTimer(event:TimerEvent):void
		{

		}

		private function initPin():void
		{
			pin=new Sprite();
			pinNormal=getImage("dish-pin");
			pinPoison=getImage("dish-pin-poison");

			pin.addChild(pinNormal);
			pin.addChild(pinPoison);

			poisonTest=false;

			pin.pivotX=32;
			pin.pivotY=27;
			gameSP.addChild(pin);
			pin.x=40;
			pin.y=65;
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
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);

			var dish:Dish=e.currentTarget as Dish;
			if (dish)
			{
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

		}

		private function onEnterFrame(e:Event):void
		{
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
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;

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
						TweenLite.to(pin, .3, {x: 40, y: 65, rotation: 0});
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
			if (_life == 0)
				gotoGameOver();
			else
				lifeTF.text=_life.toString();
		}

		private function gotoGameOver():void
		{
			dispatchEvent(new Event("gameOver"));
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
				dx=kingArea.x + kingArea.width / 2;
				dy=kingArea.y + kingArea.height / 2 + 50;
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
			gameSP.addChild(getImage("gamebg"))

			var table:Image=getImage("dish-table");
			table.y=(768 - table.height) / 2;
			gameSP.addChild(table);

			var king:Image=getImage("dish-king");
			king.x=1024 - king.width;
			king.y=0;
			gameSP.addChild(king);

			kingArea=new Rectangle(king.x, 0, king.width, king.height);

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

		private var lifeTF:TextField;
		private var scoreTF:TextField;

		private function initAreas():void
		{
			for (var i:int=0; i < dishNum; i++)
			{
				var pt:Point=new Point(165 + 243 * (i % 3), 260 + 260 * int(i / 3));
				posArr[i]=pt;
				areaArr[i]=new Rectangle(pt.x - dishW / 2 - 68, pt.y - dishH / 2 - 127, dishW, dishH);
			}
		}
	}
}
