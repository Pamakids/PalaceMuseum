package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class FieldBlock extends Sprite
	{

		[Embed(source="assets/f1.png")]
		public static var f1:Class;
		[Embed(source="assets/f2.png")]
		public static var f2:Class;

		public var speedY:Number;
		private var _index:int;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
			if(value%2==0)
				addChild(Image.fromBitmap(new f1()));
			else
				addChild(Image.fromBitmap(new f2()));
			pivotX=width>>1;
			this.y=200+value*57;
			this.speedY=.1;
		}

		public function FieldBlock()
		{
		}

		public function update():void{
			this.speedY+=.01
			this.y+=speedY;
			this.scaleX=1-(568-this.y)/568+.1;
			this.scaleY=1-(568-this.y)/568+.1;
			if(this.y>=568)
			{
				this.y=0;
				this.scaleX=.1;
				this.scaleY=.1;
				this.speedY=.1;
			}
		}
	}
}

