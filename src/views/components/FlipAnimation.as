package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

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
			contentWidth=bitmap.width;
			contentHeight=bitmap.height;
			interval=horizontal ? contentWidth / slices : contentHeight / slices;
			textures=new Vector.<Texture>(slices);
			var bd:BitmapData=bitmap.bitmapData;
			var newBD:BitmapData;
			var w:int=horizontal ? bd.width / slices : bd.width;
			var h:int=horizontal ? bd.height : bd.height / slices;
			trace(w, h);
			for (var i:int; i < slices; i++)
			{
				newBD=new BitmapData(w, h);
				newBD.copyPixels(bd, new Rectangle(horizontal ? i * w : 0, horizontal ? 0 : i * h, w, h), new Point());
				textures[i]=Texture.fromBitmapData(newBD);
			}
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private var needUpdate:Boolean=true;

		private function onStage():void
		{
//			animationIndex=1;
			flipImage();
		}

		private var preImage:FlipImage;

		private function flipImage():void
		{
			var toy:Number=0;
			if (!horizontal)
			{
				if (flipingImage && flipingImage.y > height - interval)
					toy=height - contentHeight;
			}
			TweenLite.to(this, duration, {y: toy, temp: minToMax ? -1 : 1, ease: Cubic.easeOut, onComplete: function():void
			{
				temp=1;
				trace(animationIndex, flipingImage.y);
				animationIndex++;
				if (animationIndex != textures.length)
					flipImage();
				else
					dispatchEvent(new Event('completed'));
			}, onUpdate: function():void
			{
				flipingImage=getImage();
				flipingImage.location=temp;
				if (temp > 0)
					flipingImage.y=animationIndex * interval - interval;
				else
					flipingImage.y=animationIndex * interval;
				var percnet:Number=Math.abs(temp);
				if (percnet < 1)
				{
					if (getChildIndex(preImage) != -1)
					{
						removeChild(preImage);
						preImage.dispose();
					}
					addChild(flipingImage);
				}
				preImage=flipingImage;
//				if (contentHeight > height)
//					y=temp * (animationIndex / textures.length) * (contentHeight - height);
			}});
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
