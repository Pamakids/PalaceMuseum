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
		public static const DIRECTION_VERTICAL:String = "vertical";
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		/**
		 * @param min	最小值
		 * @param max	最大值
		 * @param maxView	同屏显示数量，暂时未使用，后期优化需要使用改参数
		 * @param durition	滚动方向
		 */		
		public function LoopNumList(min:int, max:int, maxViewNum:int = 3, direction:String = DIRECTION_VERTICAL)
		{
			this.min = min;
			this.max = max;
			this.maxViewNum = maxViewNum;
			this.durition = direction;
			initialize();
		}
		
		private var durition:String;
		private var maxViewNum:int;
		private var contents:Array;
		/**
		 * 用来标示列表中的显示顺序，位置从上到下（或从左到右）
		 */		
		private var vecLabel:Vector.<TextField>;
		/**
		 * 根据值从小到大的排序数组
		 */		
		private var indexLabel:Vector.<TextField>;
		
		private function initialize():void
		{
			vecLabel = new Vector.<TextField>();
			indexLabel = new Vector.<TextField>();
			initLabels();
			initMask();
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private const maxVelocity:int = 120;
		private const minVelocity:int = -120;
		private var velocityX:Number;
		private var velocityY:Number;
		private var crtPosition:Point;
		private var prevPosition:Point;
		
		private var prevTime:int;
		private var crtTime:int;
		private var endTime:int;
		private var friction:Number = 0.85;
		
		private var itemWidth:Number = 0;
		private var itemHeight:Number = 0;
		/**
		 * 自动滚动标记
		 */		
		private var ifScroll:Boolean = false;
		/**
		 * 拖拽标记
		 */		
		private var ifDrag:Boolean = false;
		
		private var xLength:Number = 0;
		private var yLength:Number = 0;
		
		private function onEnterFrame():void
		{
			if(ifScroll)				//滚动
			{
				velocityX *= friction;
				velocityY *= friction;
				setPosition();
				if((Math.abs(velocityX) < 0.1 && durition == DIRECTION_HORIZONTAL) || (Math.abs(velocityY) < 0.1 && durition == DIRECTION_VERTICAL))
				{
					ifScroll = false;
					correctionHandler();
				}
			}
			if(ifDrag || ifScroll)		//位置更替
			{
				//根据vx与vy速度计算移动的距离中包含了几个item
				var num:Number = (durition == DIRECTION_HORIZONTAL)?xLength:yLength;
				var item:Number = (durition == DIRECTION_HORIZONTAL)?itemWidth:itemHeight;
				var count:int = num / item;
				num = max - min;
				var i:int;
				var label:TextField;
				if(count >= 1)		//把后面的部分拿到前面
				{
					for(i=0;i<count;i++)
					{
						label = vecLabel.pop();
						if(durition == DIRECTION_HORIZONTAL)		//水平方向，修改x坐标
							label.x = vecLabel[0].x - itemWidth;
						else
							label.y = vecLabel[0].y - itemHeight;
						vecLabel.unshift( label );
					}
					
					if(durition == DIRECTION_HORIZONTAL)
						xLength -= count * item;
					else
						yLength -= count * item;
				}
				else if(count <= -1)		//把前面的一部分拿到后面
				{
					count = -count;
					for(i = 0;i<count;i++)
					{
						label = vecLabel[0];
						if(durition == DIRECTION_HORIZONTAL)		//水平方向，修改x坐标
							label.x = vecLabel[num-1].x + itemWidth;
						else
							label.y = vecLabel[num-1].y + itemHeight;
						vecLabel.push( vecLabel.shift() );
					}
					
					if(durition == DIRECTION_HORIZONTAL)
						xLength += count * item;
					else
						yLength += count * item;
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
						ifDrag = true;
						crtPosition = point;
						crtTime = getTimer();
						break;
					case TouchPhase.MOVED:
						prevTime = crtTime;
						crtTime = getTimer();
						prevPosition = crtPosition;
						crtPosition = point;
						velocityX = (durition==DIRECTION_HORIZONTAL) ? (crtPosition.x - prevPosition.x) : 0;
						velocityY = (durition==DIRECTION_HORIZONTAL) ? 0 : (crtPosition.y - prevPosition.y);
						setPosition();
						break;
					case TouchPhase.ENDED:
						var time:int = Math.max( getTimer() - prevTime, 1 );
						velocityX = (durition==DIRECTION_HORIZONTAL) ? (point.x - prevPosition.x)*1000/time : 0;
						velocityY = (durition==DIRECTION_HORIZONTAL) ? 0 : (point.y - prevPosition.y)*1000/time;
						velocityX = Math.min( Math.max(minVelocity, velocityX), maxVelocity );
						velocityY = Math.min( Math.max(minVelocity, velocityY), maxVelocity );
						ifDrag = false;
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
		}
		
		private function setPosition():void
		{
			for each(var label:TextField in vecLabel)
			{
				label.x += velocityX;
				label.y += velocityY;
				//虚拟的移动总距离
			}
			xLength += velocityX;
			yLength += velocityY;
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
			const count:int = max - min;
			var label:TextField;
			for(var i:int = 0;i<count;i++)
			{
				label = labelFactory();
				this.addChild( label );
				label.text = creatString(i+min);
				if(durition == DIRECTION_HORIZONTAL)
					label.x = label.width * i;
				else
					label.y = label.height * i
				label.touchable = false;
				vecLabel.push( label );
				indexLabel.push( label );
			}
			itemWidth = label.width;
			itemHeight = label.height;
			
			creatSequential();
		}
		
		private function creatSequential():void
		{
			var label:TextField;
			var count:int = max - min;
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
			return label;
		}
		private function creatString(i:int):String
		{
			if(i<10)
				return "0" + i;
			else
				return i.toString();
		}
		
		public function setMinToMax(min:int, max:int):void
		{
		}
		
		private var max:int;
		public function set maximum(value:int):void
		{
		}
		private var min:int;
		public function set mininum(value:int):void
		{
		}
		private var crt:int;
		
		private function get crtnum():int
		{
			return crt;
		}
		
		public function resetViewSize(width:Number, height:Number):void
		{
			this.clipRect = new Rectangle(0,0,width,height);
			quad.width = width;
			quad.height = height;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}