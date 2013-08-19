package modules.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.base.PalaceScene;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TwisterGame extends PalaceScene
	{
		public var size:uint=3;

		private var dataArr:Array=["苟","日","新","日","日","新","又","日","新"];

		private var blockArr:Vector.<Block>;
//		private var twistingBlockArr:Vector.<Block>;//长度4

		private var twisterAreaArr:Vector.<Rectangle>;//旋转热区
		private var indexArr:Vector.<int>;

		private var twisting:Boolean;

		private var downPointA:Point;
		private var downPointB:Point;

		private var blockHolder:Sprite;

		private var areaSize:int;

		private var areaNum:int;

		public function TwisterGame()
		{
			addEventListener(Event.ADDED_TO_STAGE,inits);

			var mStarling:Starling = Starling.current;
			//开启触碰模拟器，便于PC测试
			mStarling.simulateMultitouch = true;
		}	

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,inits);
			addEventListener(TouchEvent.TOUCH,onTouch);

			areaSize=size-1;
			areaNum=areaSize*areaSize;

			blockArr=new Vector.<Block>(size*size);

//			twistingBlockArr=new Vector.<Block>(4);
			indexArr=new Vector.<int>(4);

			twisterAreaArr=new Vector.<Rectangle>(areaNum);

			var sp:Shape=new Shape();
			sp.graphics.beginFill(0x66ccff);
			sp.graphics.drawRect(0,0,1024,768);
			sp.graphics.endFill();
			addChild(sp);

			blockHolder=new Sprite();
			addChild(blockHolder);

			blockHolder.pivotX=size*Block.GAP/2;
			blockHolder.pivotY=size*Block.GAP/2;

			blockHolder.x=512;
			blockHolder.y=768/2;

			for (var i:int = 0; i < dataArr.length; i++) 
			{
				var block:Block=new Block();
				block.text=i.toString();
//					dataArr[i];

				block.size=size;
				block.index=i;
				blockHolder.addChild(block);

				blockArr[i]=block;
			}

			initTwisterAreas();

			shuffle();
		}

		private function initTwisterAreas():void
		{
			for (var i:int = 0; i < areaNum; i++) 
			{
				var startIndex:int=int(i/areaSize)*size+i%areaSize;
				var block:Block=blockArr[startIndex];
				var pt:Point=blockHolder.localToGlobal(new Point(block.x,block.y));
				var rect:Rectangle=new Rectangle(pt.x,pt.y,size*Block.GAP*2,size*Block.GAP*2);
				twisterAreaArr.push(rect);
			}
		}

		private function onTouch(event:TouchEvent):void
		{
			if(twisting&&!readyToGo)
				return;
			event.stopImmediatePropagation();
			//得到触碰并且正在移动的点（1个或多个）
			var touchesBegin:Vector.<Touch> = event.getTouches(stage, TouchPhase.BEGAN);
			var touches:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
			var touchesEnd:Vector.<Touch> = event.getTouches(stage, TouchPhase.ENDED);

			if(touchesEnd.length>0){
				downPointA=downPointB=null;
			}

			if (touchesBegin.length == 2){
				var touchABegin:Touch = touchesBegin[0];
				var touchBBegin:Touch = touchesBegin[1];

				var pa:Point  = touchABegin.getLocation(stage);
				var pb:Point  = touchBBegin.getLocation(stage);
				if(checkTwisterArea(pa,pb)){
					downPointA=pa;
					downPointB=pb;
				}
			}

			if (touches.length == 2)
			{
				if(!downPointA)
					return;
				//得到两个点的引用
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				//A点的当前和上一个坐标
				var currentPosA:Point  = touchA.getLocation(stage);
				var previousPosA:Point = touchA.getPreviousLocation(stage);
				//B点的当前和上一个坐标
				var currentPosB:Point  = touchB.getLocation(stage);
				var previousPosB:Point = touchB.getPreviousLocation(stage);
				//计算两个点之间的距离
				var currentVector:Point  = currentPosA.subtract(currentPosB);
//				var previousVector:Point = previousPosA.subtract(previousPosB);
				var previousVector:Point = downPointA.subtract(downPointB);
				//计算上一个弧度和当前触碰点弧度，算出弧度差值
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				if(currentAngle<-Math.PI/2&&previousAngle>Math.PI/2)
					currentAngle=Math.PI*2-currentAngle;
				else if(previousAngle<-Math.PI/2&&currentAngle>Math.PI/2)
					previousAngle=Math.PI*2-previousAngle;
				var deltaAngle:Number = currentAngle - previousAngle;

				deltaAngle=deltaAngle%(Math.PI/4);
				if(Math.abs(deltaAngle)>Math.PI/5)
				{
					trace(deltaAngle);
					twist(deltaAngle<0);
				}
			}
		}

		private function twist(clockwise:Boolean,auto:Boolean=false):void
		{
			if(!auto){
				downPointA=downPointB=null;
				twisting=true;
			}

			if(clockwise)
				indexArr.unshift(indexArr.pop());
			else
				indexArr.push(indexArr.shift());

			blockArr[startIndex].index=indexArr[0];
			blockArr[startIndex+1].index=indexArr[1];
			blockArr[startIndex+size+1].index=indexArr[2];
			blockArr[startIndex+size].index=indexArr[3];

//			var _block:Block=blockArr[startIndex];
//			if(clockwise){
//				blockArr[startIndex]=blockArr[startIndex+size];
//				blockArr[startIndex+size]=blockArr[startIndex+size+1];
//				blockArr[startIndex+size+1]=blockArr[startIndex+1];
//				blockArr[startIndex+1]=_block;
//			}else{
//				blockArr[startIndex]=blockArr[startIndex+1];
//				blockArr[startIndex+1]=blockArr[startIndex+size+1];
//				blockArr[startIndex+size+1]=blockArr[startIndex+size];
//				blockArr[startIndex+size]=_block;
//			}

			var length:int=blockArr.length
			var arr:Vector.<Block>=new Vector.<Block>(length);

			for (var j:int = 0; j < length; j++) 
			{
				var block:Block=blockArr[j];
				arr[block.index]=block;
			}

			blockArr=arr;

//			for (var i:int = 0; i < twistingBlockArr.length; i++) 
//			{
//				twistingBlockArr[i].index=indexArr[i];
//			}

			var str:String=""
			for (var i:int = 0; i < blockArr.length; i++) 
			{
				str+=blockArr[i].index.toString();
			}
			trace(str);

//			trace(twistingBlockArr[0].index,twistingBlockArr[1].index,twistingBlockArr[2].index,twistingBlockArr[3].index);

			if(!auto)
				TweenLite.delayedCall(1.1,function():void{
					twisting=false;
					if(checkAllMathed){

					}
				});
		}

		private function checkAllMathed():Boolean{
			var sum:int=0;
			var length:int=blockArr.length;
			for (var i:int = 0; i < length; i++) 
			{
				var block:Block=blockArr[i];
				if(block.text==dataArr[i]){
					sum++;
					block.matched=true;
				}else{
					block.matched=false;
				}
			}
			return sum==length;
		}

		private function sortNumbers(_a:Block, _b:Block):Number
		{
			if (_a.index < _b.index)
				return -1;
			else if (_a.index > _b.index)
				return 1;
			else
				return 0;
		}

		private function checkTwisterArea(downPointA:Point, downPointB:Point):Boolean
		{
			for (var i:int = 0; i < twisterAreaArr.length; i++) 
			{
				var rect:Rectangle=twisterAreaArr[i];
//				if(rect.containsPoint(downPointA)&&rect.containsPoint(downPointB))
				{
					startIndex=int(i/areaSize)*size+i%areaSize;
					setTwisterData(startIndex);
					return true;
				}
			}
			return false;
		}

		private function setTwisterData(_startIndex:int):void
		{
			trace("index",_startIndex)
			indexArr[0]=blockArr[_startIndex].index;
			indexArr[1]=blockArr[_startIndex+1].index;
			indexArr[2]=blockArr[_startIndex+size+1].index;
			indexArr[3]=blockArr[_startIndex+size].index;

//			twistingBlockArr[0]=blockArr[_startIndex];
//			twistingBlockArr[1]=blockArr[_startIndex+1];
//			twistingBlockArr[2]=blockArr[_startIndex+size+1];
//			twistingBlockArr[3]=blockArr[_startIndex+size];
		}

		private var step:int=10;
		private var readyToGo:Boolean;

		private var startIndex:int;
		private function shuffle():void
		{
//			readyToGo=true;
//			return;
			if(step>0){
				var index:int=Math.random()*areaNum;
				startIndex=int(index/areaSize)*size+index%areaSize;
				setTwisterData(startIndex);
				twist(Math.random()>.5,true);
				TweenLite.delayedCall(.6,shuffle);
				step--;
			}else{
				readyToGo=true;
			}
		}
	}
}

