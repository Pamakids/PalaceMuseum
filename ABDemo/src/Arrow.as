package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Arrow extends Sprite
	{
		[Embed(source="assets/arrow.png")]
		private static var arrow:Class;

		private var pt:Particle;

		public function Arrow()
		{
			addChild(Image.fromBitmap(new arrow()));
			pivotX=Math.abs(VO.ARROW_TAIL);
			pivotY=height>>1;
		}

		public function addParticle():void
		{
			if(!pt)
			{
				pt=new Particle();
				pt.y=pivotY;
				addChild(pt);
			}
		}

		public function removeParticle():void{
			if(pt)
			{
				pt.dispose();
				removeChild(pt);
				pt=null;
			}
		}
	}
}

