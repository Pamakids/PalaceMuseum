package
{
	import starling.display.Image;
	import starling.display.Sprite;

	import vo.VO;

	public class Arrow extends Sprite
	{
		[Embed(source="assets/arrow.png")]
		private static var arrow:Class;
		private var _dx:Number;

		private var arw:Image;
		public var speedX:Number=0;
		public var speedY:Number=0;

		public var head:Sprite;

		public function get dx():Number
		{
			return _dx;
		}

		public function set dx(value:Number):void
		{
			_dx=Math.min(value,80);
			arw.x=-(_dx);
//			trace(int(_dx),int(arw.x),int(width/2));
		}


		public function Arrow()
		{
			arw=Image.fromBitmap(new arrow());
			addChild(arw);
			pivotY=height>>1;

			head=new Sprite();
			head.x=width;
			head.y=0;
			addChild(head);
		}

		public function update():void
		{
			this.x+=speedX;
			this.y+=speedY;

			this.rotation=Math.atan2(speedY,speedX);

			speedY+=.5;
		}
	}
}

