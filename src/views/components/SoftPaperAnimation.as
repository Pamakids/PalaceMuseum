package views.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class SoftPaperAnimation extends Sprite
	{
		public function SoftPaperAnimation(width:Number, height:Number)
		{
			bookWidth = width;
			bookHeight = height;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * 书本宽
		 */		
		private var bookWidth:Number = 0;
		/**
		 * 书本高
		 */		
		private var bookHeight:Number = 0;
		
		private var maxHeight:Number;
		/**
		 * 软页
		 */		
		private var softImage:SoftPageImage;
		private var cacheImageL:Image;
		private var cacheImageR:Image;
		private var render:RenderTexture;
		private var renderImage:Image;
		
		protected function initialize():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			maxHeight = Math.ceil( Math.sqrt(bookWidth*bookWidth + bookHeight*bookHeight) );
			
			initCacheImage();
			initRender();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initRender():void
		{
			render = new RenderTexture(bookWidth, maxHeight);
			renderImage = new Image( render);
			this.addChild( renderImage );
			renderImage.touchable = false;
			renderImage.y = bookHeight - maxHeight;
		}
		
		private function initCacheImage():void
		{
			cacheImageL = new Image(page_1);
			this.addChild( cacheImageL );
			cacheImageR = new Image(page_2);
			this.addChild( cacheImageR );
			cacheImageR.x = bookWidth/2;
			cacheImageL.touchable = cacheImageR.touchable  =false;
		}
		
		/**
		 * 时间轴方法
		 */		
		private function onEnterFrame():void
		{
			if(!isActive)
				return;
			render.clear();
			progress += this.velocity;
			if(progress >= 1)
			{
				progress = 1;
				softImage.setLocation(render, progress, pageUp);
				complete();
			}
			else
			{
				softImage.setLocation(render, progress, pageUp);
			}
		}
		
		/**
		 * 动画开关标记
		 */		
		private var isActive:Boolean = false;
		private var pageUp:Boolean = false;
		/**
		 * 动画开始，播放前需使用setPageTexture指定相关纹理
		 * @param pageUp
		 */		
		public function start(pageUp:Boolean = false, velocity = 0.05):void
		{
			if(!softImage)
			{
				initSoftImage( pageUp );
			}
			else
			{
				softImage.originalTexture = (pageUp)?page_3:page_2;
				softImage.anotherTexture = (pageUp)?page_2:page_3;
			}
			render.clear();
			cacheImageL.texture = page_1;
			cacheImageR.texture = page_4;
			this.pageUp = pageUp;
			this.velocity = velocity;
			progress = 0;
			isActive = true;
			
//			test();
		}
		
//		private var image:Image;
//		private var anoImage:Image;
//		private function test():void
//		{
//			if(!image)
//			{
//				var point:Point = this.globalToLocal(new Point());
//				
//				image = new Image(softImage.originalTexture);
//				this.parent.addChild( image );
//				image.x = point.x;
//				image.y = point.y;
//				
//				
//				anoImage = new Image(softImage.anotherTexture);
//				this.parent.addChild( anoImage);
//				image.scaleX = image.scaleY = anoImage.scaleX = anoImage.scaleY = 0.5;
//				anoImage.x = 1024 - anoImage.width;
//				anoImage.y = point.y;
//			}
//			else
//			{
//				image.texture = softImage.originalTexture;
//				anoImage.texture = softImage.anotherTexture;
//			}
//		}
		
		/**
		 * 动画播放进度[0 - 1]
		 */		
		private var progress:Number;
		private var velocity:Number;
		
		private function initSoftImage(pageUp:Boolean):void
		{
			softImage = new SoftPageImage((pageUp)?page_3:page_2, bookWidth, bookHeight);
			softImage.anotherTexture = (pageUp)?page_2:page_3;
			softImage.y = maxHeight - bookHeight;
		}
		/**
		 * 动画播放完成
		 */		
		private function complete():void
		{
			this.stop();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 动画停止
		 */		
		public function stop():void
		{
			isActive = false;
		}
		/**
		 * 验证动画是否正在播放
		 * @return 
		 * 
		 */		
		public function isRunning():Boolean
		{
			return isActive;
		}
		
		//4页纹理
		private var page_1:Texture;
		private var page_2:Texture;
		private var page_3:Texture;
		private var page_4:Texture;
		
		/**
		 * 指定相关纹理顺序
		 * @param page1
		 * @param page2
		 * @param page3
		 * @param page4
		 */		
		public function setSoftPageTexture(page1:Texture, page2:Texture, page3:Texture, page4:Texture):void
		{
			page_1 = page1;
			page_2 = page2;
			page_3 = page3;
			page_4 = page4;
		}
		
		/**
		 * 指定不变纹理，用于重绘固定显示页
		 * @param page_L
		 * @param page_R
		 * 
		 */		
		public function setFixPageTexture(page_L:Texture, page_R:Texture):void
		{
			if(render)
				render.clear();
			if(!page_1 || (page_1 && page_1 != page_L))
			{
				page_1 = page_L;
				if(cacheImageL)
					cacheImageL.texture = page_1;
			}
			if(!page_2 || (page_2 && page_2 != page_R))
			{
				page_2 = page_R;
				if(cacheImageR)
					cacheImageR.texture = page_2;
			}
		}
		
		override public function dispose():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if(softImage)
				softImage.removeFromParent(true);
			if(cacheImageL)
				cacheImageL.removeFromParent(true);
			if(cacheImageR)
				cacheImageR.removeFromParent(true);
			super.dispose();
		}
	}
}