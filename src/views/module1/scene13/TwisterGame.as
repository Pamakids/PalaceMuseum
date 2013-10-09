package views.module1.scene13
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import models.SOService;

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
	import views.components.base.PalaceScene;

	public class TwisterGame extends PalaceScene
	{
		public var size:uint=3;

		private var dataArr:Array=["新", "日", "苟", "新", "日", "日", "新", "日", "又"];

		private var blockArr:Vector.<Block>;

		private var twisterAreaArr:Vector.<Rectangle>; //旋转热区
		private var indexArr:Vector.<int>;

		private var twisting:Boolean;

		private var downPointA:Point;
		private var downPointB:Point;

		private var blockHolder:Sprite;

		private var areaSize:int;

		private var areaNum:int;

		public function TwisterGame(am:AssetManager)
		{
			super(am);
		}

		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;

		private function onEnterFrame(e:Event):void
		{
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (count < 30 * 8)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintFinger=getImage("plaquehintfinger");
					var hintArrow:Image=getImage("plaquehintarrow");
					hintArrow.x=-Block.GAP / 2 - 15;
					hintArrow.y=-Block.GAP / 2 - 15;
					hintFinger.x=Block.GAP / 2;
					hintFinger.y=Block.GAP / 2;
					hintFinger.pivotX=hintFinger.width >> 1;
					hintFinger.pivotY=hintFinger.height >> 1;
					hintShow.addChild(hintArrow);
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
					hintShow.visible=!hintShow;
				}
				else
				{
					hintShow.visible=!answerShow;
					if (hintFinger.rotation >= degress6 * 30)
					{
						hintFinger.scaleX=hintFinger.scaleY=1;
					}
					else if (hintFinger.rotation <= 0)
					{
						hintFinger.scaleX=hintFinger.scaleY=.8;
					}
					hintFinger.rotation+=hintFinger.scaleX == 1 ? -degress6 : degress6;
				}
			}
		}

		private var degress6:Number=Math.PI / 60;

		override public function dispose():void
		{
//			this.assets=null;
//			removeChildren();
//			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function dispose2():void
		{
			this.assets=null;
			removeChildren();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var twistHint:String="twistHintCount";

		override protected function init():void
		{
			if (inited)
				return;
			inited=true;
			scale=DPIUtil.getDPIScale();
			addEventListener(TouchEvent.TOUCH, onTouch);

			areaSize=size - 1;
			areaNum=areaSize * areaSize;

			blockArr=new Vector.<Block>(size * size);

			indexArr=new Vector.<int>(4);

			twisterAreaArr=new Vector.<Rectangle>(areaNum);

			shape=new Shape();
			addChild(shape);

			blockHolder=new Sprite();
			addChild(blockHolder);

			this.pivotX=areaSize * Block.GAP / 2;
			this.pivotY=areaSize * Block.GAP / 2;

			for (var i:int=0; i < dataArr.length; i++)
			{
				var block:Block=new Block();
				var txt:String=dataArr[i];
				block.text=txt;
				block.addChild(getImage(txt + ""));

				block.size=size;
				block.index=i;
				blockHolder.addChild(block);

				blockArr[i]=block;
			}

			initTwisterAreas();

			TweenLite.delayedCall(3, shuffle);
		}

		private function onCloseTouch(e:Event):void
		{
			if (isOver)
				return;
			PopUpManager.removePopUp(this.parent);
		}

		private function initTwisterAreas():void
		{
			for (var i:int=0; i < areaNum; i++)
			{
				var startIndex:int=int(i / areaSize) * size + i % areaSize;
				var block:Block=blockArr[startIndex];
				var pt:Point=blockHolder.localToGlobal(new Point(block.x, block.y));
				var rect:Rectangle=new Rectangle(pt.x / scale - Block.GAP / 2, pt.y / scale - Block.GAP / 2, Block.GAP * 2, Block.GAP * 2);
				twisterAreaArr[i]=rect;
			}
		}

		private function onTouch(event:TouchEvent):void
		{
			if (twisting || !readyToGo || isOver || answerShow)
				return;
			//得到触碰并且正在移动的点（1个或多个）
			var touches:Vector.<Touch>=event.getTouches(stage, TouchPhase.MOVED);
			var touchesEnd:Vector.<Touch>=event.getTouches(stage, TouchPhase.ENDED);

			if (touchesEnd.length > 0)
			{
				downPointA=downPointB=null;
			}

			if (touches.length > 1)
			{
				//得到两个点的引用
				var touchA:Touch=touches[0];
				var touchB:Touch=touches[1];

				if (!downPointA)
				{
					var pa:Point=touchA.getLocation(stage);
					var pb:Point=touchB.getLocation(stage);
					if (checkTwisterArea(pa, pb))
					{
						downPointA=pa;
						downPointB=pb;
					}
				}

				if (!downPointA)
					return;


				//A点的当前和上一个坐标
				var currentPosA:Point=touchA.getLocation(stage);
				var previousPosA:Point=touchA.getPreviousLocation(stage);
				//B点的当前和上一个坐标
				var currentPosB:Point=touchB.getLocation(stage);
				var previousPosB:Point=touchB.getPreviousLocation(stage);
				//计算两个点之间的距离
				var currentVector:Point=currentPosA.subtract(currentPosB);
//				var previousVector:Point = previousPosA.subtract(previousPosB);
				var previousVector:Point=downPointA.subtract(downPointB);
				//计算上一个弧度和当前触碰点弧度，算出弧度差值
				var currentAngle:Number=Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number=Math.atan2(previousVector.y, previousVector.x);
				if (currentAngle < -Math.PI / 2 && previousAngle > Math.PI / 2)
					currentAngle=Math.PI * 2 - currentAngle;
				else if (previousAngle < -Math.PI / 2 && currentAngle > Math.PI / 2)
					previousAngle=Math.PI * 2 - previousAngle;
				var deltaAngle:Number=currentAngle - previousAngle;

				deltaAngle=deltaAngle % (Math.PI / 4);
				if (Math.abs(deltaAngle) > Math.PI / 18)
					twist(deltaAngle < 0);
			}
		}

		private function twist(clockwise:Boolean, auto:Boolean=false):void
		{
			if (!auto)
			{
				isMoved=true;
				downPointA=downPointB=null;
				twisting=true;
			}

			if (clockwise)
				indexArr.unshift(indexArr.pop());
			else
				indexArr.push(indexArr.shift());

			//调整索引
			blockArr[startIndex].index=indexArr[0];
			blockArr[startIndex + 1].index=indexArr[1];
			blockArr[startIndex + size + 1].index=indexArr[2];
			blockArr[startIndex + size].index=indexArr[3];

			var length:int=blockArr.length;
			var arr:Vector.<Block>=new Vector.<Block>(length);

			for (var j:int=0; j < length; j++)
			{
				var block:Block=blockArr[j];
				arr[block.index]=block;
			}

			blockArr=arr;

			if (!auto)
				TweenLite.delayedCall(.6, function():void
				{
					twisting=false;
					shape.graphics.clear();
					if (checkAllMathed())
					{
						gameOver();
					}
				});
		}

		private function gameOver():void
		{
			isOver=true;
			for each (var block:Block in blockArr)
			{
				TweenMax.to(block, 1, {shake: {rotation: .2, numShakes: 4}});
			}

			TweenLite.delayedCall(2, function():void
			{
				dispatchEvent(new Event(PalaceGame.GAME_OVER, true));
			});
		}

		private function checkAllMathed():Boolean
		{
			var sum:int=0;
			var length:int=blockArr.length;
			for (var i:int=0; i < length; i++)
			{
				var block:Block=blockArr[i];
				if (block.text == dataArr[i])
				{
					sum++;
					block.matched=true;
				}
				else
				{
					block.matched=false;
				}
			}
			return sum == length;
		}

		private function checkTwisterArea(_pa:Point, _pb:Point):Boolean
		{
			for (var i:int=0; i < twisterAreaArr.length; i++)
			{
				var rect:Rectangle=twisterAreaArr[i];
				var pa:Point=new Point(_pa.x / scale, _pa.y / scale);
				var pb:Point=new Point(_pb.x / scale, _pb.y / scale);

				if (rect.containsPoint(pa) && rect.containsPoint(pb))
				{
					startIndex=int(i / areaSize) * size + i % areaSize;
					setTwisterData(startIndex);
					return true;
				}
			}
			return false;
		}

		private function setTwisterData(_startIndex:int):void
		{
			shape.graphics.clear();
			shape.graphics.lineStyle(3, 0x66ccff);
			shape.graphics.drawRoundRect(blockArr[_startIndex].x - Block.GAP / 2 - 2, blockArr[_startIndex].y - Block.GAP / 2 - 2, Block.GAP * 2 + 2, Block.GAP * 2 + 2, 10);

			indexArr[0]=blockArr[_startIndex].index;
			indexArr[1]=blockArr[_startIndex + 1].index;
			indexArr[2]=blockArr[_startIndex + size + 1].index;
			indexArr[3]=blockArr[_startIndex + size].index;
		}

		private var step:int=10;
		private var readyToGo:Boolean;
		private var startIndex:int;
		public var isOver:Boolean;
		private var scale:Number;

		private var shape:Shape;

		private var close:ElasticButton;
		private var inited:Boolean;
		private var hintFinger:Image;
		private var _answerShow:Boolean;

		public function get answerShow():Boolean
		{
			return _answerShow;
		}

		public function set answerShow(value:Boolean):void
		{
			_answerShow=value;
			for each (var b:Block in blockArr)
			{
				if (b)
					b.alpha=_answerShow ? .5 : 1;
			}
		}

		private var hintIcon:ElasticButton;

		private function shuffle():void
		{
//			readyToGo=true;
//			return;
			if (step > 0)
			{
				var index:int=Math.random() * areaNum;
				startIndex=int(index / areaSize) * size + index % areaSize;
				setTwisterData(startIndex);
				twist(Math.random() > .5, true);
				TweenLite.delayedCall(.6, shuffle);
				step--;
			}
			else
			{
				shape.graphics.clear();
				readyToGo=true;
				isOver=false;

				if (!close)
				{
					close=new ElasticButton(getImage("clock-close"));
					close.x=492;
					close.y=-181;
					addChild(close);
					close.addEventListener(ElasticButton.CLICK, onCloseTouch);
					if (SOService.instance.checkHintCount(twistHint))
						addEventListener(Event.ENTER_FRAME, onEnterFrame);
					addHintIcon();
				}
				else
				{
					close.visible=true;
				}

			}
		}

		private function addHintIcon():void
		{
			hintIcon=new ElasticButton(getImage("gamehinticon"));
			addChild(hintIcon);
			hintIcon.x=-120;
			hintIcon.y=-50;
			hintIcon.addEventListener(ElasticButton.CLICK, onHintClick);
		}

		private function onHintClick(e:Event):void
		{
			if (answerShow)
				return;
			var answer:Image=getImage("gameanswer");
			answer.pivotX=answer.width >> 1;
			answer.pivotY=answer.height >> 1;
			addChild(answer);
			answer.x=150;
			answer.y=130;
			answerShow=true;
			TweenLite.delayedCall(3, function():void {
				answer.removeFromParent(true);
				answerShow=false;
			});
		}

		public function reset():void
		{
			close.visible=false;
			step=10;
			shuffle();
		}
	}
}

