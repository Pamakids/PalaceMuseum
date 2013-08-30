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
		private var _bookWidth:Number;
		private var _bookHeight:Number;
		
		/**
		 * @param width			书本宽
		 * @param height		书本高
		 * @param textures 		纹理集[	[left,right], [left,right]...	]
		 * @param coverTexture	有封面
		 * @param reverTexture	有封底
		 * @param currentPage	默认显示页
		 * @param dragable		可拖拽
		 */		
		public function SoftPageAnimation(width:Number, height:Number, textures:Vector.<Texture>, cover:Boolean=false, backcover:Boolean=false, currentPage:int=0, dragable:Boolean=false)
		{
			this._bookWidth = width;
			this._bookHeight = height;
			this._dragable = dragable;
			this._currentPage = currentPage;
			this._cover = cover;
			this._backcover = backcover;
			this.setTextures(textures);
			
			initialize();
		}
		
//initialize---------------------------------------------------------------------------------
		
		private function initialize():void
		{
			_quadBatch = new QuadBatch();
			this.addChild(_quadBatch);
			
			var i:int = _currentPage*2;
			createFixedPage(this._textures[i], this._textures[i+1]);
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
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
		 * 页总数
		 */		
		private var _totalPage:int;
		/**
		 * 翻页进程，区间[-1, 1]
		 */		
		private var _progress:Number;
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
		
		/**
		 * 重置书页纹理集合
		 * @param value
		 * @param currentPage
		 */		
		public function setTextures(value:Vector.<Texture>, currentPage:int=-1):void
		{
			if(_textures && _textures == value)
				return;
			_textures = value;
			if(_cover)
				_textures.unshift( null );
			if(_backcover)
				_textures.push( null );
			
			_totalPage = Math.ceil( _textures.length >> 1 ) - 1;
			
			if(currentPage >= 0)
				_currentPage = currentPage;
			_needUpdate = true;
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
		public function pageUp():void
		{
			if(_currentPage <= 0)
				return;
			
			//缓动更改progress的值并更新渲染
			
			trace("pageUp");
		}
		/**
		 * 自动翻页方法，下翻一页
		 */		
		public function pageDown():void
		{
			if(_currentPage >= _totalPage)
				return;
			
			//缓动更改progress的值并更新渲染
			
			trace("pageDown");
		}
		public function turnToPage(index:int):void{}
		
		override public function dispose():void{}
		
//logical-------------------------------------------------------------------------------------
			
		private const MIN_TOUCH_MOVE_LENGTH:Number = 100;
		private var _needUpdate:Boolean;
		private var _beginPointX:Number;
		private var _leftToRight:Boolean;
		private function onTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				var point:Point = touch.getLocation(this);
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						this._beginPointX = point.x;		//记录起始X坐标,设定左右翻页
						_leftToRight = this._beginPointX < 0;
						
						if(this._dragable)
						{
							//可拖拽的情况下，需要预先掀起一角以给显示可拖拽
							_progress = (_leftToRight)?-0.95:0.95;
							createViewByProgress();
						}
						break;
					case TouchPhase.MOVED:
						if(this._dragable)
						{
							//计算progress的值
							_progress = (point.x<0)?point.x/_leftTexture.frame.width:point.x/_rightTexture.frame.width;
							if(_progress<-1)
								_progress = -1;
							if(_progress > 1)
								_progress = 1;
							
							trace(_progress);
							createViewByProgress();
						}
						break;
					case TouchPhase.ENDED:
						if(this._dragable)
						{
							//根据当前的progress值来计算是否达到了翻页的要求，并依此来缓动更改progress的值至targetProgress
						}
						else
						{
							//记录结束点X坐标，若满足翻页条件，则自动翻页
							var length:Number = point.x - _beginPointX;
							if(_leftToRight && length > MIN_TOUCH_MOVE_LENGTH )		//前翻一页
								pageUp();
							if( (!_leftToRight) && (length < -MIN_TOUCH_MOVE_LENGTH) ) 		//后翻一页
								pageDown();
						}
						break;
				}
			}
			else
			{
				_needUpdate = false;
			}
		}
		
		private var _leftTexture:Texture;
		private var _rightTexture:Texture;
		/**
		 * 绘制左右不变纹理
		 * @param leftTexture
		 * @param rightTexture
		 */		
		private function createFixedPage(leftTexture:Texture, rightTexture:Texture):void
		{
			if(leftTexture)
			{
				_leftTexture = leftTexture;
				(!_cacheImage)?_cacheImage = new Image(leftTexture):_cacheImage.texture = leftTexture;
				_cacheImage.x = -_cacheImage.width;
				_cacheImage.width = leftTexture.frame.width;
				_cacheImage.height = leftTexture.frame.height;
				_quadBatch.addImage( _cacheImage );
			}
			if(rightTexture)
			{
				_rightTexture = rightTexture;
				(!_cacheImage)?_cacheImage = new Image(rightTexture):_cacheImage.texture = rightTexture;
				_cacheImage.x = 0;
				_cacheImage.width = rightTexture.frame.width;
				_cacheImage.height = rightTexture.frame.height;
				_quadBatch.addImage( _cacheImage );
			}
		}
		
		/**
		 * 绘制软页
		 */		
		private function createSoftPage(texture:Texture, another:Texture):void
		{
			(!_softImage)?_softImage = new SoftPageImage(texture):_softImage.texture = texture;
			_softImage.anotherTexture = another;
			_softImage.readjustSize();
			_softImage.setLocationSoft(_quadBatch, _progress, _leftToRight);
		}
		
		private function createViewByProgress():void
		{
			if(_currentPage == 0 && _leftToRight)
				return;
			if(_currentPage == _totalPage)
				return;
			//几个纹理索引
			var leftIndex:int, rightIndex:int, textureIndex:int, anotherIndex:int;
			if(_leftToRight)
			{
				leftIndex = (_currentPage-1)*2;
				rightIndex = leftIndex+3;
				textureIndex = leftIndex+2;
				anotherIndex = leftIndex+1;
			}
			else
			{
				leftIndex = _currentPage*2;
				rightIndex = leftIndex+3;
				textureIndex = leftIndex+1;
				anotherIndex = leftIndex+2;
			}
			//清理纹理
			_quadBatch.reset();
			//渲染左侧与右侧固定纹理
			createFixedPage(_textures[leftIndex], _textures[rightIndex]);
			//使用quadBatch根据各点位置及左右翻页渲染flipImage纹理
			createSoftPage(_textures[textureIndex],  _textures[anotherIndex]);
		}
	}
}