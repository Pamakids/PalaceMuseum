package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
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
		 * @param textures 		纹理集
		 * @param currentPage	默认显示页（除去封面与封底，剩余纹理每两个纹理为一页）
		 * @param dragable		可拖拽
		 * @param duration		时间，若dragable为true，则该时间为拖拽结束页面缓动归为的时间
		 * @param coverTexture	有封面
		 * @param reverTexture	有封底
		 */		
		public function SoftPageAnimation(width:Number, height:Number, textures:Vector.<Texture>, currentPage:int=0, dragable:Boolean=false, duration:Number = 1, cover:Boolean=false, backcover:Boolean=false)
		{
//			for(var i:int = textures.length-1;i>=0;i--)
//			{
//				var img:Image = new Image(textures[i]);
//				img.scaleX = img.scaleY = 0.4;
//				img.x = i * 200;
//				this.addChild( img );
//			}
//			return;
			
			this._bookWidth = width;
			this._bookHeight = height;
			this._dragable = dragable;
			this._currentPage = currentPage;
			this._cover = cover;
			this._backcover = backcover;
			this.duration = duration;
			this.setTextures(textures);
			initialize();
		}
		
		
		private function initialize():void
		{
			_quadBatch = new QuadBatch();
			this.addChild(_quadBatch);
			createFixedPage(this._textures[_currentPage*2], this._textures[_currentPage*2+1]);
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		/**
		 * 当dragable为true时，该时间将作为拖拽结束后到翻页完成（或回归）的时间长度
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
		 * 翻页进程0-1
		 */		
		private var _progress:Number;
		public function set progress(value:Number):void
		{
			if(_progress == value)
				return;
			
			_progress = value;
			createViewByProgress();
		}
		public function get progress():Number
		{
			return _progress;
		}
		
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
			trace("setTextures");
			if(_textures && _textures == value)
				return;
			_textures = value;
			if(_cover)
				_textures.unshift( null );
			if(_backcover)
				_textures.push( null );
			
			_totalPage = Math.ceil( _textures.length >> 1 ) - 1;
			
			if(currentPage >= 0 && _currentPage != currentPage)
				createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
		}
		
		/**
		 * 临时插入或修改纹理序列的方法
		 * @param startIndex
		 * @param deleteCount
		 * @param items
		 */		
		public function spliceTextures(startIndex:Number, deleteCount:Number=0, currentPage:int=-1, ...items):void
		{
			for (var i:int = items.length-1; i>=0; i++)
			{
				if(!(items[i] is Texture))
					items.splice(i,1);
			}
			this._textures.splice(startIndex, deleteCount, items);
			
			if(currentPage >= 0)
				this._currentPage = currentPage;
			createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
			
		}
		/**
		 * 自动翻页方法，上翻一页
		 */		
		private function pageUp():void
		{
			active = false;
			_currentPage -= 1;
			if(_cover)
				createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
		}
		/**
		 * 自动翻页方法，下翻一页
		 */		
		private function pageDown():void
		{
			active = false;
			_currentPage += 1;
			if(_backcover)
				createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
		}
		/**
		 * 跳转至指定页面
		 */		
		public function turnToPage(index:int):void
		{
			if( _currentPage == index || index > _totalPage || index < 0)
				return;
			_leftToRight = (_currentPage - index) < 0;
			progress = 0;
			_currentPage = index;
			easeFunc(duration, 1, Cubic.easeIn, function():void{
				createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
				active = false;
			});
		}
		
		override public function dispose():void
		{
			if(_cacheImage)
				_cacheImage.dispose();
			if(_softImage)
				_softImage.dispose();
			if(_quadBatch)
				_quadBatch.dispose()
			if(_textures)
				_textures = null;
			super.dispose();
		}
		
		private const MIN_TOUCH_MOVE_LENGTH:Number = 100;
		private var _needUpdate:Boolean;
		private var _beginPointX:Number;
		private var _leftToRight:Boolean;
		
		private var promptValue:Number = 0.2;
		private function onTouchHandler(e:TouchEvent):void
		{
			if(active)
				return;
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				var point:Point = touch.getLocation(this);
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						this._beginPointX = point.x;		//记录起始X坐标,设定左右翻页
						_leftToRight = this._beginPointX - _bookWidth/2 < 0;
						if( (_currentPage <= 0 && _leftToRight) || (_currentPage >= _totalPage && !_leftToRight) )
							return;
						progress = promptValue;
						break;
					case TouchPhase.MOVED:
						if( (_currentPage <= 0 && _leftToRight) || (_currentPage >= _totalPage && !_leftToRight) )
							return;
						if(this._dragable)
						{
							if(_leftToRight)
								progress = Math.max(Math.min(1, (point.x - this._beginPointX) / DRAG_LENGTH), 0);
							else
								progress = Math.max(Math.min(1, (this._beginPointX - point.x) / DRAG_LENGTH), 0);
						}
						else
						{
							progress = promptValue;
						}
						break;
					case TouchPhase.ENDED:
						if( (_currentPage <= 0 && _leftToRight) || (_currentPage >= _totalPage && !_leftToRight) )
							return;
						if(this._dragable)
						{
							//根据当前的progress值来计算是否达到了翻页的要求，并依此来缓动更改progress的值至targetProgress
							if(progress > 0.8)		//翻书完成
								easeFunc(duration, 1, Cubic.easeIn, (_leftToRight)?pageUp:pageDown);
							else				//书本返回
								easeFunc(duration, 0, Cubic.easeIn);
						}
						else
						{
							//记录结束点X坐标，若满足翻页条件，则自动翻页
							var length:Number = point.x - _beginPointX;
							
							if(_leftToRight && length > MIN_TOUCH_MOVE_LENGTH )		//前翻一页
								easeFunc(duration, 1, Cubic.easeOut, pageUp);
							if( (!_leftToRight) && (length < -MIN_TOUCH_MOVE_LENGTH) ) 		//后翻一页
								easeFunc(duration, 1, Cubic.easeOut, pageDown);
							if( Math.abs(length) < MIN_TOUCH_MOVE_LENGTH )			//翻页取消
								easeFunc(duration, 0, Cubic.easeOut);
						}
						break;
				}
			}
		}
		
		/**
		 * 缓动更改progress至目标值
		 */		
		private function easeFunc( duration:Number, progressTarget:Number, ease:Function=null, onComplete:Function=null ):void
		{
			active = true;
			var obj:Object = {
				progress: progressTarget
			};
			if(ease)
				obj.ease = ease;
			if(onComplete)
				obj.onComplete = onComplete;
			else
				obj.onComplete = function():void
				{
					active = false;
				};
			TweenLite.to(this, duration, obj);
		}
		
		private const DRAG_LENGTH:Number = 500;		//拖动距离，用来计算progress
		/**
		 * 绘制左右不变纹理
		 * @param leftTexture
		 * @param rightTexture
		 */		
		private function createFixedPage(leftTexture:Texture, rightTexture:Texture):void
		{
			trace(_textures.indexOf(leftTexture), _textures.indexOf(rightTexture));
			if(leftTexture)
			{
				(!_cacheImage)?_cacheImage = new Image(leftTexture):_cacheImage.texture = leftTexture;
				_cacheImage.x = 0;
				_cacheImage.width = this._bookWidth / 2;
				_cacheImage.height = this._bookHeight;
				_quadBatch.addImage( _cacheImage );
			}
			if(rightTexture)
			{
				(!_cacheImage)?_cacheImage = new Image(rightTexture):_cacheImage.texture = rightTexture;
				_cacheImage.x = this._bookWidth/2;
				_cacheImage.width = this._bookWidth/2;
				_cacheImage.height = this._bookHeight;
				_quadBatch.addImage( _cacheImage );
			}
		}
		
		/**
		 * 绘制软页
		 */		
		private function createSoftPage(texture:Texture, another:Texture):void
		{
			if(!_softImage)
			{
				_softImage = new SoftPageImage(texture, _bookWidth, _bookHeight);
			}else
			{
				_softImage.texture = texture;
			}
			_softImage.anotherTexture = another;
			_softImage.readjustSize();
			_softImage.setLocation(_quadBatch, progress, _leftToRight);
		}
		
		
		private var active:Boolean = false;
		private function createViewByProgress():void
		{
			if(_currentPage <= 0 && _leftToRight)
				return;
			if(_currentPage >= _totalPage && !_leftToRight)
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
			trace(leftIndex, rightIndex);
			createFixedPage(_textures[leftIndex], _textures[rightIndex]);
			//使用quadBatch根据各点位置及左右翻页渲染flipImage纹理
			createSoftPage(_textures[textureIndex],  _textures[anotherIndex]);
		}
	}
}