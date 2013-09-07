package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	/**
	 * 书本软翻页动画
	 * @author aser_sayhi
	 */	
	public class SoftPageAnimation extends Sprite
	{
		public static const PAGE_UP:String = "page_up";
		public static const PAGE_DOWN:String = "page_down";
		public static const ANIMATION_COMPLETED:String = "animation_completed";
		
		
		private var _bookWidth:Number;
		private var _bookHeight:Number;
		
		/**
		 * @param width			书本宽
		 * @param height		书本高
		 * @param textures 		纹理集
		 * @param _currentPage	默认显示页（除去封面与封底，剩余纹理每两个纹理为一页）
		 * @param dragable		可拖拽
		 * @param duration		时间，若dragable为true，则该时间为拖拽结束页面缓动归为的时间
		 * @param coverTexture	有封面
		 * @param reverTexture	有封底
		 */		
		public function SoftPageAnimation(width:Number, height:Number, textures:Vector.<Texture>, currentPage:int=0, dragable:Boolean=false, duration:Number = 1, cover:Boolean=false, backcover:Boolean=false)
		{
			this._bookWidth = width;
			this._bookHeight = height;
			this._maxHeight = Math.ceil( Math.sqrt(_bookWidth*_bookWidth + _bookHeight*_bookHeight) );
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
			_render = new RenderTexture(_bookWidth, _maxHeight);
			_mainImage = new Image( _render);
			this.addChild( _mainImage );
			_mainImage.touchable = false;
			_mainImage.y = _bookHeight - _maxHeight;
			
			_cacheImage = new Image((!_cover)?_textures[_currentPage*2]:_textures[_currentPage*2+1]);
			_softImage = new SoftPageImage((!_cover)?_textures[_currentPage*2]:_textures[_currentPage*2+1], _bookWidth, _bookHeight);
			_cacheImage.y = _softImage.y = _maxHeight - _bookHeight;
			_cacheImage.touchable = _softImage.touchable = false;
			
			//创建热区
			quad = new Quad(width, height, 0x000000);
			quad.alpha = 0;
			this.addChild( quad );
			
			createViewByProgress();
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		private var quad:Quad;
		
		
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
		public function get currentPage():int
		{
			return _currentPage;
		}
		public function set currentPage(value:int):void
		{
			_currentPage = value;
		}
		/**
		 * 页总数
		 */		
		private var _totalPage:int;
		/**
		 * 翻页进程0-1
		 */		
		private var _progress:Number = 0;
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
		private var _textures:Vector.<Texture>;
		private var _render:RenderTexture;
		private var _mainImage:Image;
		private var _cacheImage:Image;
		private var _softImage:SoftPageImage;
		
		/*封面 */		
		private var _cover:Boolean;
		private var _backcover:Boolean;
		
		
		/**
		 * 重置书页纹理集合
		 * @param value
		 * @param _currentPage
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
			if(currentPage >= 0 && _currentPage != currentPage)
				this._currentPage = currentPage;
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
			
			if(_currentPage >= 0)
				this._currentPage = currentPage;
			createFixedPage(_textures[_currentPage*2], _textures[_currentPage*2+1]);
		}
		
		/**
		 * 自动翻页方法，上翻一页
		 */		
		private function pageUp():void
		{
			active = false;
			_currentPage-=1;
			createViewByProgress();
			if(_buttonCallBackMode)
				dispatchEvent(new Event(ANIMATION_COMPLETED));
			else
				dispatchEvent(new Event(PAGE_UP));
		}
		/**
		 * 自动翻页方法，下翻一页
		 */		
		private function pageDown():void
		{
			active = false;
			_currentPage += 1;
			createViewByProgress();
			if(_buttonCallBackMode)
				dispatchEvent(new Event(ANIMATION_COMPLETED));
			else
				dispatchEvent(new Event(PAGE_DOWN));
		}
		/**
		 * 跳转至指定页面.使用此方法需将buttonCallBackMode设为true
		 */		
		public function turnToPage(target:int):void
		{
			trace(_currentPage, target);
			if(active)
				return;
			if( _currentPage == target || target > _totalPage || target < 0)
				return;
			_startPage = _currentPage;
			_leftToRight = (_currentPage > target);
			_currentPage = (_leftToRight)?target+1:target-1;
			progress = 0.01;
			easeFunc(duration, 1, null, function():void{
				(_leftToRight)?pageUp():pageDown();
			});
		}
		private var _startPage:int;
		private var _buttonCallBackMode:Boolean = false;
		public function set buttonCallBackMode(value:Boolean):void
		{
			if(_buttonCallBackMode == value)
				return;
			_buttonCallBackMode = value;
			if(_buttonCallBackMode)
			{
				this.removeEventListener(TouchEvent.TOUCH,onTouchHandler);
			}
			else
			{
				this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
			}
		}
		
		override public function dispose():void
		{
			if(quad)
				quad.removeFromParent(true);
			quad = null;
			
			if(_cacheImage)
			{
				_cacheImage.dispose();
				_cacheImage = null;
			}
			if(_textures)
				_textures = null;
			if(_softImage)
			{
				_softImage.dispose();
				_softImage = null;
			}
			if(_mainImage)
			{
				_mainImage.dispose();
				_mainImage = null;
			}
			if(_render)
			{
				_render.clear();
				_render.dispose();
				_render
			}
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
								easeFunc(duration, 1, /*Cubic.easeOut*/null, pageUp);
							if( (!_leftToRight) && (length < -MIN_TOUCH_MOVE_LENGTH) ) 		//后翻一页
								easeFunc(duration, 1, /*Cubic.easeOut*/null, pageDown);
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
					createViewByProgress();
				};
			TweenLite.to(this, duration, obj);
		}
		
		private const DRAG_LENGTH:Number = 500;		//拖动距离，用来计算progress
		private var _maxHeight:Number;
		/**动画进行中*/		
		private var active:Boolean = false;
		
		/**
		 * 绘制左右不变纹理
		 * @param leftTexture
		 * @param rightTexture
		 */		
		private function createFixedPage(leftTexture:Texture, rightTexture:Texture):void
		{
			if(leftTexture)
			{
				_cacheImage.readjustSize();
				_cacheImage.texture = leftTexture;
				_cacheImage.x = 0;
				_cacheImage.width = this._bookWidth / 2;
				_cacheImage.height = this._bookHeight;
				_render.draw( _cacheImage );
			}
			if(rightTexture)
			{
				_cacheImage.readjustSize();
				_cacheImage.texture = rightTexture;
				_cacheImage.x = this._bookWidth/2;
				_cacheImage.width = this._bookWidth/2;
				_cacheImage.height = this._bookHeight;
				_render.draw( _cacheImage );
			}
		}
		
		private function createSoftPage(value1:Texture, value2:Texture):void
		{
			_softImage.texture = value1;
			_softImage.anotherTexture = value2;
			_softImage.readjustSize();
			_softImage.setLocation(_render, _progress, _leftToRight);
		}
		
		private function createViewByProgress():void
		{
			_render.clear();
			var l:int, r:int, index:int, another:int;
			if(_progress == 0 || _progress == 1)			//不需更新软页，只更新固定页，以_currentPage为参考
			{
				trace("progress: "+ _progress);
				l = _currentPage*2;
				r = _currentPage*2+1;
				createFixedPage(_textures[l], _textures[r]);
			}
			else
			{
				if(_buttonCallBackMode)
				{
					if(_leftToRight)
					{
						l = (_currentPage-1)*2;
						r = _startPage*2+1;
						index = r - 1;
						another = l + 1;
					}else
					{
						l = _startPage*2;
						r = (_currentPage+1)*2 + 1;
						index = l + 1;
						another = r - 1;
					}
				}
				else
				{
					if(_leftToRight)
					{
						l = (_currentPage-1)*2;
						r = l+3;
						index = l+2;
						another = l+1;
					}else
					{
						l = _currentPage*2;
						r = l+3;
						index = l+1;
						another = l+2;
					}
				}
				createFixedPage(_textures[l], _textures[r]);
				createSoftPage(_textures[index], _textures[another]);
			}
		}
	}
}