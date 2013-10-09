package views.module1.scene12
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class ClothCircle extends Sprite
	{
		public function ClothCircle()
		{
			super();
		}

		public var dataArr:Array;
		public var circle:Image;

		private var _angle:Number=0;

		//椭圆
		public static const RX:Number=600; //x轴半径
		public static const RY:Number=300; //y轴半径

		public var sp1:Sprite;
		public var sp2:Sprite;

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle=value;
			for each (var cloth:Cloth2 in dataArr)
			{
				setClothPos(cloth);
			}
		}


		private var circleHodler:Sprite;

		public function initCircle():void
		{
			var len:int=dataArr.length;
			dAngle=Math.PI * 2 / len;

			circleHodler=new Sprite();
			circleHodler.addChild(circle);
			circleHodler.scaleY=RY / RX;
			circleHodler.pivotX=circleHodler.width >> 1;
			circleHodler.pivotY=circleHodler.height >> 1;
			addChild(circleHodler);

			for (var i:int=0; i < len; i++)
			{
				var cloth:Cloth2=dataArr[i];
				cloth.index=i;
				setClothPos(cloth);
			}
		}

		private var dAngle:Number;

		private function setClothPos(cloth:Cloth2):void
		{
			var index:int=cloth.index
			var clothAngle:Number=angle + Math.PI / 4 + dAngle * index;
			cloth.x=Math.cos(clothAngle) * RX;
			cloth.y=Math.sin(clothAngle) * RY;
			var offset:Number=Math.sin(clothAngle);
			var scale:Number=((1 + offset) / 2 + 1) / 2; //0.5-1
			var alpha:Number=((1 + offset) / 2 + 3) / 4; //0.75-1
			cloth.scaleX=cloth.scaleY=scale;
			cloth.alpha=alpha;
			cloth.offset=(1 + offset) / 2; //0-1
			var pr:Sprite=offset > 0 ? sp1 : sp2;
			if (pr != cloth.parent)
				pr.addChild(cloth);
		}
	}
}
