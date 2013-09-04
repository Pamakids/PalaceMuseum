package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	import views.components.base.Container;

	[Event(name="completed", type="starling.events.Event")]
	/**
	 * 折叠动画
	 * @author mani
	 */
	public class FlipAnimation extends Container
	{

		private var textures:Vector.<Texture>;
		private var horizontal:Boolean;
		private var minToMax:Boolean;
		private var contentWidth:Number;
		private var contentHeight:Number;
		private var interval:int;
		private var duration:Number;
		private var slices:int;

		private var result:Image;

		/**
		 * @param bitmap 折叠素材
		 * @param slices 切片数量
		 * @param duration 动画总时间
		 * @param horizontal 是否水平
		 * @param minToMax 是否从小到大，比如水平是根据x值从小到大，则是从左到右滚动
		 */
		public function FlipAnimation(bitmap:Bitmap, slices:int, duration:Number=3, horizontal:Boolean=false, minToMax:Boolean=true)
		{
			super();
			this.duration=duration / slices;
			this.slices=slices;
			this.horizontal=horizontal;
			this.minToMax=minToMax;
			result=new Image(Texture.fromBitmap(bitmap));
			result.visible=false;
			contentWidth=bitmap.width;
			contentHeight=bitmap.height;
			interval=horizontal ? contentWidth / slices : contentHeight / slices;
			textures=new Vector.<Texture>;
			var bd:BitmapData=bitmap.bitmapData;
			var newBD:BitmapData;
			var w:int=horizontal ? bd.width / slices : bd.width;
			var h:int=horizontal ? bd.height : bd.height / slices;
			for (var i:int; i < slices; i++)
			{
				newBD=new BitmapData(w, h);
				newBD.copyPixels(bd, new Rectangle(horizontal ? i * w : 0, horizontal ? 0 : i * h, w, h), new Point());
				textures[i]=Texture.fromBitmapData(newBD);
				newBD.dispose();
			}
			if (!horizontal)
			{
				width=contentWidth;
				scaleX=scaleY=.8;
				x=width * (1 - scaleX) / 2;
			}
			bd.dispose();
		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			super.dispose();
			for each (var t:Texture in textures)
			{
				t.dispose();
			}
			while (numChildren)
			{
				removeChildAt(0, true);
			}
			if (result && result.parent)
			{
				removeChild(result, true);
			}
			result=null;
			textures=null;
		}

		private var needUpdate:Boolean=true;

		override protected function init():void
		{
			flipImage();
		}

		private var preImage:FlipImage;

		private function flipImage():void
		{
			var toy:Number=y;
			var tox:Number=x;
			if (!horizontal)
			{
				if (flipingImage && flipingImage.y > height - interval * 2 && y == 0)
				{
					toy=(height - contentHeight) * scaleX;
					TweenLite.to(this, 0.8, {delay: 0.3, y: toy, ease: Cubic.easeOut, onComplete: function():void
					{
						flipImage();
					}});
					return;
				}
			}
			else if (flipingImage && flipingImage.x > width - interval * 2)
			{
				tox=width - contentHeight;
			}
			TweenLite.to(this, duration, {y: toy, x: tox, temp: minToMax ? -1 : 1, ease: Cubic.easeOut, onComplete: function():void
			{
				temp=minToMax ? 1 : -1;
				trace(animationIndex, flipingImage.y);
				animationIndex++;
				if (animationIndex != textures.length)
				{
					flipImage();
				}
				else
				{
					if (!horizontal)
					{
						height=contentHeight;
						result.x=width / 2 - contentWidth / 2;
					}
					else
					{
						width=contentWidth;
						result.y=height / 2 - contentHeight / 2;
					}
					addChild(result);
					removeSlices();
					flipingImage=null;
					result.visible=true;
					TweenLite.delayedCall(0.5, function():void
					{
						dispatchEvent(new Event('completed'));
					});
				}
			}, onUpdate: function():void
			{
				flipingImage=getImage();
				flipingImage.location=temp;
				if (temp > 0)
				{
					if (!horizontal)
						flipingImage.y=animationIndex * interval - interval;
					else
						flipingImage.x=animationIndex * interval - interval;
				}
				else
				{
					if (!horizontal)
						flipingImage.y=animationIndex * interval;
					else
						flipingImage.x=animationIndex * interval;
				}
				var percnet:Number=Math.abs(temp);
				if (percnet < 1)
				{
					if (getChildIndex(preImage) != -1)
						removeChild(preImage, true);
					addChild(flipingImage);
				}
				preImage=flipingImage;
//				if (contentHeight > height)
//					y=temp * (animationIndex / textures.length) * (contentHeight - height);
			}});
		}

		private function removeSlices():void
		{
			for each (var im:Image in imageDic)
			{
				removeChild(im);
			}
		}

		public function playAnimation():void
		{
			while (numChildren)
			{
				removeChildAt(0);
			}
			TweenLite.killTweensOf(this);
			y=0;
			animationIndex=0;
			temp=0;
			flipImage();
		}

		private var imageDic:Dictionary=new Dictionary();

		private function getImage():FlipImage
		{
			var fi:FlipImage=imageDic[animationIndex] as FlipImage;
			if (!fi)
			{
				fi=new FlipImage(textures[animationIndex], horizontal, minToMax, true);
				if (!horizontal)
				{
					fi.y=animationIndex * interval;
					fi.x=width / 2 - contentWidth / 2;
				}
				else
				{
					fi.y=height / 2 - contentHeight / 2;
					fi.x=animationIndex * interval;
				}
//				imageDic[animationIndex]=fi;
			}
			return fi;
		}

		private var animationIndex:int;
		public var temp:Number=0;
		private var flipingImage:FlipImage;
	}
}
