package views.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 书本软翻页动画
	 * @author aser_sayhi
	 */	
	public class SoftPageAnimation extends Sprite
	{
		/**
		 * @param textures 		纹理集[	[left,right], [left,right]...	]
		 * @param coverTexture	封面
		 * @param reverTexture	背面
		 * @param currentPage	当前显示页索引
		 * @param dragable		可拖拽
		 */		
		public function SoftPageAnimation(textures:Vector.<Texture>=null, cover:Boolean=false, backcover:Boolean=false, currentPage:int=0, dragable:Boolean=false)
		{
			this._dragable = dragable;
			this._currentPage = currentPage;
			this._cover = cover;
			this._backcover = backcover;
			if(textures)
				setTextures(textures);
		}
		
//initialize---------------------------------------------------------------------------------
		
		private function initialize():void
		{
			_quadBatch = new QuadBatch();
			this.addChild(_quadBatch);
			//显示默认的图片
			createFixedImage();
			
			if(!this.hasEventListener(TouchEvent.TOUCH))
				this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		private function createFixedImage():void
		{
			var texture:Texture;
			if(_textures[_currentPage] && _textures[_currentPage][0])
			{
				texture = _textures[_currentPage][0]
			}
		}		
		
//control-------------------------------------------------------------------------------------
		/**
		 * 当dragable为true时，该时间将失效
		 */		
		public var duration:Number = 1;
		/**
		 * 是否可拖拽，值为false时为自动翻页，值为true时，书页为手动翻页
		 */		
		private var _dragable:Boolean;
		/**
		 * 当前页索引
		 */		
		private var _currentPage:int;
		/**
		 * 翻页进程，区间[-1, 1]
		 */		
		private var _progress:Number;
		private function set progress(value:Number):void{}
		/**
		 * 翻页目标进程（-1or1）
		 */		
		private var _targetProgress:int;
		
		/**批处理显示*/
		private var _quadBatch:QuadBatch;
		private var _textures:Vector.<Texture>;
		private var _cacheImage:Image;
		private var _softImage:SoftPageImage;
		
		/*封面 */		
		private var _cover:Boolean;
		private var _backcover:Boolean;
		
//public--------------------------------------------------------------------------------------
		
		public function setTextures(value:Vector.<Texture>, currentPage:int=0):void
		{
			setTexturesFunc(value);
			this._currentPage = currentPage;
			initialize();
		}
		/**
		 * 临时插入或修改纹理序列的方法
		 * @param startIndex
		 * @param deleteCount
		 * @param items
		 */		
		public function spliceTextures(startIndex:Number, deleteCount:Number, ...items):void{}
		/**
		 * 自动翻页方法，上翻一页
		 */		
		public function pageUp():void{}
		/**
		 * 自动翻页方法，下翻一页
		 */		
		public function pageDown():void{}
		public function turnToPage(index:int):void{}
		
		override public function dispose():void{}
		
//logical-------------------------------------------------------------------------------------
			
		private function setTexturesFunc(value:Vector.<Texture>):void
		{
			if(_textures == value)
				return;
			
		}
		
		private var needUpdate:Boolean;
		private var beginPointX:Number;
		
		private function onTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			var point:Point = touch.getLocation(this);
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						this.beginPointX = point.x;		//记录起始X坐标
						break;
					case TouchPhase.MOVED:
						if(this._dragable)
						{
							//确定progerss值
							//根据progress算出flipImage的各点，运算方法在SoftPageImage类中进行
							//使用quadBatch渲染左侧纹理（必要时）
							//使用quadBatch渲染右侧纹理（必要时）
							//使用quadBatch根据各点位置及左右翻页渲染flipImage纹理
						}
						else
						{
							//确定progress的值
						}
						break;
					case TouchPhase.ENDED:
						if(this._dragable)
						{
							//根据当前的progress值来计算是否达到了翻页的要求，并依此来缓动更改progress的值至targetProgress
						}
						else
						{
						}
						break;
				}
			}
			else
			{
				needUpdate = false;
			}
		}
	}
}