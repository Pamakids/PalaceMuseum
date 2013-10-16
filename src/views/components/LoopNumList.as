package views.components
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		private static const DURITION_VERTICAL:String = "vertical";
		private static const DURITION_HORIZONTAL:String = "horizontal";
		
		/**
		 * @param min	最小值
		 * @param max	最大值
		 * @param maxView	同屏显示数量，暂时未使用，后期优化需要使用该参数
		 * @param durition	滚动方向
		 */		
		public function LoopNumList(min:int, max:int, isHorizontal:Boolean=false)
		{
			this.min = min;
			this.max = max;
			this.isHorizontal = isHorizontal;
			initialize();
		}
		
		private var isHorizontal:Boolean;
		/**
		 * 用来标示列表中的显示顺序，位置从上到下（或从左到右）
		 */		
		private var vecLabel:Vector.<TextField>;
		private const maxTextfieldNum:int = 7;
		private function initialize():void
		{
			vecLabel = new Vector.<TextField>(maxTextfieldNum);
			initLabels();
			initHotspot();
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initHotspot():void
		{
			this.clipRect = new Rectangle(0,0,69,90);
			var quad:Quad = new Quad(clipRect.width, clipRect.height, 0x000000);
			this.addChild( quad );
			quad.alpha = 0;
		}
		
		private function initLabels():void
		{
			var label:TextField;
			for(var i:int = 0;i<maxTextfieldNum;i++)
			{
				label = labelFactory();
				label.text = creatString(i+min);
				if(isHorizontal)
					label.x = label.width * i;
				else
					label.y = label.height * i;
				
				vecLabel[i] = label;		
			}
			itemWidth = label.width;
			itemHeight = label.height;
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
		private var friction:Number = 0.9;
		
		private var itemWidth:Number = 0;
		private var itemHeight:Number = 0;
		/**
		 * 自动滚动标记
		 */		
		private var ifScroll:Boolean = false;
		
		private function onEnterFrame():void
		{
			if(ifScroll)				//滚动
			{
				velocityX *= friction;
				velocityY *= friction;
				setPosition();
				if((velocityX == 0 && isHorizontal) || (velocityY == 0 && !isHorizontal))
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
						velocityX = isHorizontal ? crtPosition.x - prevPosition.x : 0;
						velocityY = isHorizontal ? 0 : crtPosition.y - prevPosition.y;
						setPosition();
						break;
					case TouchPhase.ENDED:
						var time:int = Math.max( getTimer() - prevTime, 1 );
						velocityX = isHorizontal ? (point.x - prevPosition.x)*1000/time : 0;
						velocityY = isHorizontal ? 0 : (point.y - prevPosition.y)*0100/time;
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
			if(isHorizontal)
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
			searchCrtNum();
		}
		
		/**
		 * 获取当前显示数字
		 */		
		private function searchCrtNum():void
		{
			for each(var item:TextField in vecLabel)
			{
				if( (isHorizontal && item.x == itemWidth) || (!isHorizontal && item.y == itemHeight) )
				{
					crtnum = int(item.text);
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
			
			testPosition();
		}
		
		/**
		 * 检测文本位置，符合变更条件即变更位置与文本内容
		 */		
		private function testPosition():void
		{
			var i:int;
			var item:TextField;
			var tempItem:TextField;
			var n:int;
			const num:int = maxTextfieldNum-1;
			if(isHorizontal)			//水平移动
			{
				if(velocityX > 0)
				{
					for(i = num;;)
					{
						item = vecLabel[i];
						if(item.x >= itemWidth*3)
						{
							tempItem = vecLabel[0];
							item.x = tempItem.x - itemWidth;
							n = int(tempItem.text)-1;
							if(n<min)
								n = max - (min-n) + 1;
							item.text = creatString(n);
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
						if(item.x <= -itemWidth)
						{
							tempItem = vecLabel[num];
							item.x = tempItem.x + itemWidth;
							n = int(tempItem.text)+1;
							if(n>max)
								n = min + (n-max) - 1;
							item.text = creatString(n);
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
						if(item.y >= itemHeight*3)
						{
							tempItem = vecLabel[0];
							item.y = tempItem.y - itemHeight;
							n = int(tempItem.text)-1;
							if(n<min)
								n = max - (min-n) + 1;
							item.text = creatString(n);
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
						if(item.y <= -itemHeight)
						{
							tempItem = vecLabel[num];
							item.y = tempItem.y + itemHeight;
							n = int(tempItem.text)+1;
							if(n>max)
								n = min + (n-max) - 1;
							item.text = creatString(n);
							vecLabel.push(vecLabel.shift());
						}else
							break;
					}
				}
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
			var num:int = crt;
			if(num > max || num<min)
				crt = min;
			setCrtNum(crt);
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
			var num:int;
			var item:TextField;
			for(var i:int = 0; i< maxTextfieldNum;i++)
			{
				item = vecLabel[i];
				num = value - ( (isHorizontal) ? (itemWidth-item.x)/itemWidth : (itemHeight-item.y)/itemHeight );
				if(num<min)
					num = max - (min-num) + 1;
				else if(num>max)
					num = min + (num-max) -1;
				item.text = creatString( num );
			}
			crtnum = value;
		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for each(var item:TextField in vecLabel)
			{
				item.removeFromParent(true);
			}
			super.dispose();
		}
	}
}