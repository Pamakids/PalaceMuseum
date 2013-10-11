package views.module1.scene12
{
	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;

	public class ClothCircle extends Sprite
	{
		public function ClothCircle()
		{
		}

		public var dataArr:Array;
		public var circle:Image;

		private var _angle:Number=0;

		//椭圆
		public static const RX:Number=360; //x轴半径
		public static const RY:Number=88; //y轴半径

		public var sp1:Sprite;
		public var sp2:Sprite;

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle=value;
			circle.rotation=value;
			for each (var cloth:Cloth2 in dataArr)
			{
				setClothPos(cloth);
			}
		}


		private var circleHodler:Sprite;

		public function initCircle():void
		{
			this.alpha=.3;
			len=dataArr.length;
			dAngle=Math.PI * 2 / len;

			circleHodler=new Sprite();
			circleHodler.addChild(circle);
			circleHodler.scaleY=RY / RX;
			circle.pivotX=circle.width >> 1;
			circle.pivotY=circle.height >> 1;
			addChild(circleHodler);

			for (var i:int=0; i < len; i++)
			{
				var cloth:Cloth2=dataArr[i];
				cloth.index=i;
				initCloth(cloth)
			}
		}

		private function initCloth(cloth:Cloth2):void
		{
			cloth.initCloth();
			var index:int=cloth.index
			var clothAngle:Number=angle + Math.PI / 2 + dAngle * index;
			var pt:Point=new Point(Math.cos(clothAngle) * RX, Math.sin(clothAngle) * RY);
			cloth.x=686;
			cloth.y=500;
			var offset:Number=Math.sin(clothAngle);
			var scale:Number=((1 + offset) / 2 + 1) / 2; //0.5-1
			var alpha:Number=((1 + offset) / 2 + 3) / 4; //0.75-1
			cloth.scaleX=cloth.scaleY=scale;
			cloth.alpha=alpha;
			cloth.offset=(1 + offset) / 2; //0-1
			var pr:Sprite=offset > 0 ? sp1 : sp2;
			if (pr != cloth.parent)
				pr.addChild(cloth);
			cloth.playEnter(pt);
		}

		private var dAngle:Number;
		private var len:int;

		private function setClothPos(cloth:Cloth2):void
		{
			var index:int=cloth.index
			var clothAngle:Number=angle + Math.PI / 2 + dAngle * index;
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
