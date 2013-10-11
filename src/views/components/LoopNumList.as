package views.components
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import models.FontVo;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	/**
	 * 循环数字列表
	 * @author Administrator
	 */	
	public class LoopNumList extends Sprite
	{
		public static const DIRECTION_VERTICAL:String = "vertical";
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		/**
		 * @param min	最小值
		 * @param max	最大值
		 * @param maxView	同屏显示数量，暂时未使用，后期优化需要使用该参数
		 * @param durition	滚动方向
		 */		
		public function LoopNumList(min:int, max:int, maxViewNum:int = 3, direction:String = DIRECTION_VERTICAL)
		{
			this.min = min;
			this.max = max;
//			this.maxViewNum = maxViewNum;
			this.durition = direction;
			this.crtnum = min;
			initialize();
		}
		
		private var durition:String;
//		private var maxViewNum:int;
		private var contents:Array;
		/**
		 * 用来标示列表中的显示顺序，位置从上到下（或从左到右）
		 */		
		private var vecLabel:Vector.<TextField>;
		
		private function initialize():void
		{
			vecLabel = new Vector.<TextField>();
			initLabels();
			initMask();
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private const maxVelocity:int = 120;
		private const minVelocity:int = -120;
		private var velocityX:int;
		private var velocityY:int;
		private var crtPosition:Point;
		private var prevPosition:Point;
		
		private var prevTime:int;
		private var crtTime:int;
		private var endTime:int;
		private var friction:Number = 0.95;
		
		private var itemWidth:Number = 0;
		private var itemHeight:Number = 0;
		private var totalWidth:Number = 0;
		private var totalHeight:Number = 0;
		/**
		 * 自动滚动标记
		 */		
		private var ifScroll:Boolean = false;
		
		private var xLength:Number = 0;
		private var yLength:Number = 0;
		
		private function onEnterFrame():void
		{
			if(ifScroll)				//滚动
			{
				velocityX *= friction;
				velocityY *= friction;
				setPosition();
				if((velocityX == 0 && durition == DIRECTION_HORIZONTAL) || (velocityY == 0 && durition == DIRECTION_VERTICAL))
				{
					ifScroll = false;
					correctionHandler();
				}
			}
		}
		
		
		private function onTouch(e:TouchEvent):void
		{
			var point:Point;
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				point = touch.getLocation(this);
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						crtPosition = point;
						crtTime = getTimer();
						break;
					case TouchPhase.MOVED:
						prevTime = crtTime;
						crtTime = getTimer();
						prevPosition = crtPosition;
						crtPosition = point;
						velocityX = (durition==DIRECTION_HORIZONTAL) ? crtPosition.x - prevPosition.x : 0;
						velocityY = (durition==DIRECTION_HORIZONTAL) ? 0 : crtPosition.y - prevPosition.y;
						setPosition();
						break;
					case TouchPhase.ENDED:
						var time:int = Math.max( getTimer() - prevTime, 1 );
						velocityX = (durition==DIRECTION_HORIZONTAL) ? (point.x - prevPosition.x)*1000/time : 0;
						velocityY = (durition==DIRECTION_HORIZONTAL) ? 0 : (point.y - prevPosition.y)*0100/time;
						velocityX = Math.min( Math.max(minVelocity, velocityX), maxVelocity );
						velocityY = Math.min( Math.max(minVelocity, velocityY), maxVelocity );
						ifScroll = true;
						break;
				}
			}
		}
		
		/**
		 * 位置校正
		 */		
		private function correctionHandler():void
		{
			velocityX = velocityY = 0;
			
			var label:TextField = vecLabel[0];
			var d:Number;
			if(durition == DIRECTION_HORIZONTAL)
			{
				d = Math.abs( label.x % itemWidth );
				velocityX = (d > itemWidth/2)?(d - itemWidth):d;
			}
			else
			{
				d = Math.abs( label.y % itemHeight );
				velocityY = (d > itemHeight/2)?( d - itemHeight ):d;
			}
			setPosition();
			yLength = 0;
			xLength = 0;
			
			searchCrtNum();
		}
		
		/**
		 * 获取当前显示数字
		 */		
		private function searchCrtNum():void
		{
			var item:TextField;
			for(var i:int = vecLabel.length-1;i>=0;i--)
			{
				item = vecLabel[i];
				if(durition == DIRECTION_HORIZONTAL)
				{
					if(item.x != 0)
						continue;
					crtnum = int(vecLabel[i+1].text);
					break;
				}
				else
				{
					if(item.y != 0)
						continue;
					crtnum = int(vecLabel[i+1].text);
					break;
				}
			}
		}
		
		private function setPosition():void
		{
			for each(var item:TextField in vecLabel)
			{
				item.x += velocityX;
				item.y += velocityY;
			}
			testPosition()
		}
		/**
		 * 检测文本位置，符合变更条件即变更位置
		 */		
		private function testPosition():void
		{
			var i:int;
			var item:TextField;
			const num:int = vecLabel.length-1;
			if(durition == DIRECTION_HORIZONTAL)			//水平移动
			{
				if(velocityX > 0)
				{
					for(i = num;;)
					{
						item = vecLabel[i];
						if(item.x >= totalWidth/2)
						{
							item.x = vecLabel[0].x - itemWidth;
							vecLabel.unshift(vecLabel.pop());
						}
						else
							break;
					}
				}
				else
				{
					for(i = 0;;)
					{
						item = vecLabel[i];
						if(item.x <= -totalWidth/2)
						{
							item.x = vecLabel[num].x + itemWidth;
							vecLabel.push(vecLabel.shift());
						}else
							break;
					}
				}
			}
			else					//垂直
			{
				if(velocityY > 0)
				{
					for(i = num;;)
					{
						item = vecLabel[i];
						if(item.y >= totalHeight/2)
						{
							item.y = vecLabel[0].y - itemHeight;
							vecLabel.unshift(vecLabel.pop());
						}
						else
							break;
					}
				}
				else
				{
					for(i = 0;;)
					{
						item = vecLabel[i];
						if(item.y <= -totalHeight/2)
						{
							item.y = vecLabel[num].y + itemHeight;
							vecLabel.push(vecLabel.shift());
						}else
							break;
					}
				}
			}
		}
		
		
		private var quad:Quad;
		private function initMask():void
		{
			this.clipRect = new Rectangle(0,0,69,90);
			//热区
			quad = new Quad(69,90,0x000000);
			quad.alpha = 0;
			this.addChild( quad );
		}
		
		private function initLabels():void
		{
			const count:int = max - min + 1;
			var label:TextField;
			for(var i:int = 0;i<count;i++)
			{
				label = labelFactory();
				label.text = creatString(i+min);
				if(durition == DIRECTION_HORIZONTAL)
					label.x = label.width * i;
				else
					label.y = label.height * i
			}
			itemWidth = label.width;
			itemHeight = label.height;
			totalWidth = itemWidth * count;
			totalHeight = itemHeight * count;
			
			//创建显示顺序
			creatSequential();
		}
		
		private function creatSequential():void
		{
			var label:TextField;
			var count:int = max - min + 1;
			var num:int = count >> 1;
			for( var i:int = count - 1; i>=num; i--)		//将后面的item移动至前面
			{
				label = vecLabel.pop();
				if(durition == DIRECTION_HORIZONTAL)		//水平方向，修改x坐标
					label.x = vecLabel[0].x - itemWidth;
				else
					label.y = vecLabel[0].y - itemHeight;
				vecLabel.unshift( label );
			}
		}
		
		public var labelFactory:Function = defaultLabelFactory;
		private function defaultLabelFactory():TextField
		{
			var label:TextField = new TextField(69, 30, "", FontVo.PALACE_FONT, 26, 0xfeffcf);
			label.hAlign = "left";
			label.vAlign = "center";
			this.addChild( label );
			label.touchable = false;
			vecLabel.push(label);
			return label;
		}
		private function creatString(i:int):String
		{
			if(i<10)
				return "0" + i;
			else
				return i.toString();
		}
		/**
		 * 重置数字范围
		 * @param min
		 * @param max
		 */		
		public function resetMinToMax(min:int, max:int):void
		{
			if(this.min == min && this.max == max)
				return;
			this.min = min;
			this.max = max;
			var item:TextField;
			var i:int;
			var num:int = vecLabel.length;		//原显示对象数量
			var newNum:int = max-min+1;			//现在需要的显示对象数量
			if(num >= newNum)
			{
				for(i = 0;i<num;i++)
				{
					item = vecLabel[i];
					if(i>=newNum)		//清理多余对象
					{
						item.removeFromParent(true);
					}
					else				//重新赋值
					{
						item.text = creatString(min+i);
						item.x = (durition == DIRECTION_HORIZONTAL)?itemWidth*i:0;
						item.y = (durition == DIRECTION_HORIZONTAL)?0:itemHeight*i;
					}
				}
				vecLabel.splice(newNum, (num-newNum));
			}
			else
			{
				for(i=0;i<newNum;i++)
				{
					if(i<num)		//重新赋值
						item = vecLabel[i];
					else		//创建新对象
						item = labelFactory();
					item.text = creatString(min+i);
					item.x = (durition == DIRECTION_HORIZONTAL)?itemWidth*i:0;
					item.y = (durition == DIRECTION_HORIZONTAL)?0:itemHeight*i;
				}
			}
			
			crtnum = int(vecLabel[1].text);
			totalHeight = itemHeight * newNum;
			totalWidth = itemWidth * newNum;
			creatSequential();
		}
		/**
		 * 列表最大数值
		 */		
		private var max:int;
		/**
		 * 列表最小数值
		 */		
		private var min:int;
		/**
		 * 当前选中数值
		 */		
		private var crt:int;
		
		private function set crtnum(value:int):void
		{
			if(crt == value)
				return;
			crt = value;
			dispatchEventWith(Event.CHANGE, false, crt);
		}
		public function getCrtNum():int
		{
			return crt;
		}
		public function setCrtNum(value:int):void
		{
			if(value<min || value > max)
				throw new Error("数字范围超出");
			for each(var item:TextField in vecLabel)
			{
				if(int(item.text) == value)
				{
					if(durition == DIRECTION_HORIZONTAL)
					{
						velocityX = (item.x>0)?-itemWidth:itemWidth;
						moveTimes = (itemWidth-item.x) / velocityX;
					}
					else
					{
						velocityY = (item.y>0)?-itemHeight:itemHeight;
						moveTimes = (itemHeight-item.y) / velocityY;
					}
					
					var timer:Timer = new Timer(100, moveTimes);
					timer.addEventListener(TimerEvent.TIMER, function onTimer(e:TimerEvent):void{
						setPosition();
					});
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function onComplete(e:TimerEvent):void{
						crtnum = value;
					});
					timer.start();
					break;
				}
			}
		}
		private var moveTimes:uint=0;
		
		public function resetViewSize(width:Number, height:Number):void
		{
			this.clipRect = new Rectangle(0,0,width,height);
			quad.width = width;
			quad.height = height;
		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if(quad)
				quad.removeFromParent(true);
			super.dispose();
		}
	}
}