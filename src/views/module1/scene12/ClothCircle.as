package views.module1.scene12
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class ClothCircle extends Sprite
	{
		public function ClothCircle()
		{
		}

		public var dataArr:Array;
		public var light:Texture;

		private var _angle:Number=0;

		//椭圆
		public static const RX:Number=360; //x轴半径
		public static const RY:Number=90; //y轴半径

		public var sp1:Sprite;
		public var sp2:Sprite;

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle=normalizeAngle(value);
			for each (var cloth:Cloth2 in dataArr)
			{
				setClothPos(cloth);
			}
		}

		private function normalizeAngle(value:Number):Number
		{
			var angle:Number;
			angle=value % (Math.PI * 2);
			if (angle < 0)
				angle=Math.PI * 2 + angle;
			return angle;
		}

		private var circleHodler:Sprite;

		public function initCircle():void
		{
			this.alpha=.3;
			len=dataArr.length;
			dAngle=Math.PI * 2 / len;

			circleHodler=new Sprite();
			addChild(circleHodler);

			for (var i:int=0; i < len; i++)
			{
				var cloth:Cloth2=dataArr[i];
				cloth.index=i;
				initCloth(cloth)
			}

			TweenLite.delayedCall(len / 2, readyCallback);
		}

		private function initCloth(cloth:Cloth2):void
		{
			cloth.initCloth();
			var index:int=cloth.index
			var clothAngle:Number=angle + Math.PI / 2 + dAngle * index;
			var dx:Number=Math.cos(clothAngle) * RX;
			var dy:Number=Math.sin(clothAngle) * RY;
			var pt:Point=new Point(dx, dy - 70);
			var offset:Number=Math.sin(clothAngle);
			var scale:Number=getScale(offset);
			cloth.x=350;
			cloth.y=50;
			cloth.scaleX=cloth.scaleY=scale;
			cloth.offset=(1 + offset) / 2; //0-1
			var pr:Sprite=offset > 0 ? sp1 : sp2;

			TweenLite.delayedCall(index / 2, function():void {
				if (pr != cloth.parent)
					pr.addChild(cloth);
				cloth.playEnter(pt);
			});

			var shadow:Image=new Image(light);
			shadow.pivotX=shadow.width >> 1;
			shadow.pivotY=shadow.height >> 1;
			shadow.x=dx;
			shadow.y=dy - 105;
			shadow.scaleX=shadow.scaleY=scale;
			shadowArr.push(shadow);
			circleHodler.addChild(shadow);
		}

		private var shadowArr:Array=[];
		private var dAngle:Number;
		private var len:int;
		public var checkIndex:Function;
		public var readyCallback:Function;

		private function getScale(_offset):Number
		{
			var scale:Number=((1 + _offset) / 2 + 1) / 2
			return scale * scale; //0.25-1
		}

		private function setClothPos(cloth:Cloth2):void
		{
			var index:int=cloth.index
			var clothAngle:Number=angle + Math.PI / 2 + dAngle * index;
			var dx:Number=Math.cos(clothAngle) * RX;
			var dy:Number=Math.sin(clothAngle) * RY;
			var offset:Number=Math.sin(clothAngle);
			var scale:Number=getScale(offset);
			var pr:Sprite=offset > 0 ? sp1 : sp2;
			cloth.x=dx;
			cloth.y=dy - 70;
			cloth.scaleX=cloth.scaleY=scale;
			cloth.offset=(1 + offset) / 2; //0-1
			if (pr != cloth.parent)
				pr.addChild(cloth);

			var shadow:Image=shadowArr[index];
			shadow.x=dx;
			shadow.y=dy - 105;
			shadow.scaleX=shadow.scaleY=scale;
		}

		public function startDrag():void
		{
			TweenLite.killTweensOf(this);
		}

		public function tweenPlay(speedX:Number):void
		{
			trace(speedX)
			TweenLite.killTweensOf(this);
			var index:int=getTargetIndex(speedX);
			var destAngle:Number=getAngle(index)
			var delay:Number=getDelay(destAngle);
			TweenLite.to(this, delay, {angle: destAngle, ease: Back.easeOut, onComplete: function():void {
				var i:int=(len - index) % len;
				if (i < 0)
					i+=len;
				checkIndex(dataArr[i].type);
			}});
		}

		private function getAngle(index:int):Number
		{
			return dAngle * index;
		}

		private function getDelay(speedX:Number):Number
		{
			return Math.abs(speedX) > 0.02 ? 1 : .5;
		}

		private function getTargetIndex(speedX:Number):int
		{
			var index:int;
			var index1:int=Math.floor(angle / dAngle);
			var index2:int=Math.ceil(angle / dAngle);
			var vx:Number=Math.abs(speedX);
			var fix:int=Math.abs(speedX) > 0.02 ? 1 : 0;
			if (speedX > 0)
				index=index1 - fix;
			else
				index=index2 + fix;
			return index;
		}
	}
}
