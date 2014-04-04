package com.pamakids
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	import models.PosVO;

	public class FullFillBG extends Sprite
	{

		[Embed(source="palace_left.jpg")]
		private static var leftBG:Class;
		[Embed(source="palace_right.jpg")]
		private static var rightBG:Class;

		public function FullFillBG()
		{
			super();

			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE,inits);
			else
				inits(null);
		}

		protected function inits(event:Event):void
		{
			var w:Number=Math.max(stage.fullScreenHeight,stage.fullScreenWidth);
			var h:Number=Math.min(stage.fullScreenHeight,stage.fullScreenWidth);

			var left:Bitmap=new leftBG();
			var right:Bitmap=new rightBG();

			addChild(left);
			addChild(right);

			left.width=right.width=PosVO.OffsetX;
			left.height=right.height=h;

			right.x=w-PosVO.OffsetX;

			this.mouseChildren=this.mouseEnabled=false;
		}
	}
}

