package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
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
	public class FlipAnimationForMap extends Container
	{
		private var textures:Vector.<Texture>;
		private var minToMax:Boolean;
		private var contentWidth:Number;
		private var contentHeight:Number;
		private var interval:int;
		private var duration:Number;
		private var slices:int = 4;

		/**
		 * @param textures 素材纹理
		 * @param duration 动画总时间
		 * @param minToMax 是否从小到大，比如水平是根据x值从小到大，则是从左到右滚动
		 */
		public function FlipAnimationForMap(textures:Vector.<Texture>, duration:Number=3, minToMax:Boolean=true)
		{
			super();
			this.duration=duration / slices;
			this.minToMax=minToMax;
			this.textures = textures;
			
			var texture:Texture = textures[0];
			contentWidth=texture.width;
			interval=texture.height;
			contentHeight=interval*4;
			doScale();
		}

		private function doScale():void
		{
			width=contentWidth;
			scaleX=scaleY=.8;
			x=width * (1 - scaleX) / 2;
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
			if (flipingImage && flipingImage.y > height - interval * 2 && y == 0)
			{
				toy=(height - contentHeight) * scaleX;
				TweenLite.to(this, 0.8, {delay: 0.3, y: toy, ease: Cubic.easeOut, onComplete: function():void
				{
					flipImage();
				}});
				return;
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
					animationPlayed();
				}
			}, onUpdate: function():void
			{
				flipingImage=getImage();

				//根据temp值替换纹理材质
				if (_backcover)
				{
					if (temp > 0) //反面
//						flipingImage.texture=backcovers[animationIndex];
						flipingImage.texture=_backcover;
					else
						flipingImage.texture=textures[animationIndex];
				}

				flipingImage.location=temp;
				if (temp > 0)
				{
					flipingImage.y=animationIndex * interval - interval;
				}
				else
				{
					flipingImage.y=animationIndex * interval;
				}
				var percnet:Number=Math.abs(temp);
				if (percnet < 1)
				{
					if (getChildIndex(preImage) != -1)
						removeChild(preImage, true);
					addChild(flipingImage);
				}
				preImage=flipingImage;
			}});
		}

		public function animationPlayed():void
		{
			height=contentHeight;
			flipingImage=null;
			TweenLite.delayedCall(0.5, function():void
			{
				dispatchEvent(new Event('completed'));
			});
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
			doScale();
			flipImage();
		}

		private var imageDic:Dictionary=new Dictionary();

		private function getImage():FlipImage
		{
			var fi:FlipImage=imageDic[animationIndex] as FlipImage;
			if (!fi)
			{
				fi=new FlipImage(textures[animationIndex], false, minToMax, true);
				fi.y=animationIndex * interval;
				fi.x=width / 2 - contentWidth / 2;
			}
			return fi;
		}

		private var animationIndex:int;
		public var temp:Number=0;
		private var flipingImage:FlipImage;

		private var _backcover:Texture;
		public function set backcover(value:Texture):void
		{
			if(_backcover && _backcover == value)
				return;
			_backcover = value;
		}
	}
}
