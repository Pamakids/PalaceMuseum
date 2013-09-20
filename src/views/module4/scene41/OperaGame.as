package views.module4.scene41
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class OperaGame extends PalaceGame
	{
		public function OperaGame(am:AssetManager=null)
		{
			super(am);
			initStart();
		}

		private var startHolder:Sprite;
		private var gameHolder:Sprite;
		private var endHolder:Sprite;

		private var gameLevel:int;

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
			startHolder.addChild(getImage("gamebg"));
			var startBtn:ElasticButton=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down");
			startBtn.addEventListener(ElasticButton.CLICK, onStartClick);
			startHolder.addChild(startBtn);
			startBtn.x=512;
			startBtn.y=650;
		}

		private function onStartClick(e:Event):void
		{
			initGame();
		}

		private function initGame():void
		{
			removeChild(startHolder);
			startHolder.dispose();
			startHolder=null;

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
			}

			addBodys();
			addMasks();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
					ropeSP.graphics.moveTo(body.stagePt.x, 0);
					ropeSP.graphics.lineTo(body.x, body.y);
				}

			}
		}

		private var length:int=6;
		private var railYArr:Array=[184, 421, 720];
		private var spArr:Array=[];
		private var bodyArr:Vector.<OperaBody>=new Vector.<OperaBody>(length);
		private var typeArr:Array=["1", "1", "1", "1", "1", "1"];

		private var bodyPosArr:Array=[new Point(100, 100), new Point(500, 100),
			new Point(300, 300), new Point(700, 300), new Point(200, 500), new Point(600, 500)];

		private var ropeSP:Shape;

		private function addBodys():void
		{
			for (var i:int=0; i < length; i++)
			{
				addOneBody(i);
			}
		}

		private function addOneBody(index:int):void
		{
			var body:OperaBody=new OperaBody();
			body.index=index;
			var type:String=typeArr[index];
			body.type=type;
//				typeArr.splice(index, 1);
//				onStageTypeArr.push(type);
			body.body=getImage("body" + type);
//				body.rope=getImage("rope" + type);
			body.head=getImage("head" + type);
			body.stagePt=bodyPosArr[index]
			body.reset();
			body.playEnter();
			bodyArr[index]=body;
			var sp:Sprite=spArr[int(index / 2)];
			sp.addChild(body);
		}

		private function removeOneBody(body:OperaBody):void
		{
			body.playExit(function():void {
				body.parent.removeChild(body);
				addOneBody(body.index);
				body.dispose();
//				bodyArr[body.index]=null;
			});
		}

		private function addMasks():void
		{
			for (var i:int=0; i < length; i++)
			{
				addOneMask(i);
			}
		}

		private function addOneMask(index:int, isInit:Boolean=true):void
		{
			var mask:OperaMask=new OperaMask();
			var type:String=typeArr[index];
			mask.index=index;
			mask.type=type;
			var img:Image=getImage("mask" + type);
			mask.addChild(img);
			gameHolder.addChild(mask);
			mask.addEventListener(TouchEvent.TOUCH, onMaskTouch);

			if (!isInit)
			{
				var dy:Number=mask.y;
				mask.y=900;
				TweenLite.to(mask, .5, {y: dy});
			}
		}

		private function onMaskTouch(e:TouchEvent):void
		{
			var mask:OperaMask=e.currentTarget as OperaMask;
			if (!mask)
				return;
			var tc:Touch=e.getTouch(mask);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{

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
					if (body.getBounds(this).containsPoint(pt) && mask.type == body.type && !body.isMatched)
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

		private function initResult():void
		{
			removeChild(gameHolder);
			gameHolder.dispose();
			gameHolder=null;

			endHolder=new Sprite();
			addChild(endHolder);
		}
	}
}
