package models
{
	import flash.display.Shape;

	import assets.BrushAssets;

	import drawing.CommonPaper;
	import drawing.DrawingPlayer;
	import drawing.IBrush;

	import org.agony2d.view.AgonyUI;

	/** singleton... */
	public class DrawingManager
	{
		public function get paper():CommonPaper
		{
			return mPaper
		}

		public var isPaperDirty:Boolean

		public function initialize():void
		{
			this.doInitPaper()
			this.doAddBrush()
		}

		private var mPaper:CommonPaper
		private var mPlayer:DrawingPlayer


		///////////////////////////////////////////////////////

		private static var mInstance:DrawingManager

		public static function getInstance():DrawingManager
		{
			return mInstance||=new DrawingManager
		}


		private function doInitPaper():void
		{
			mPaper=new CommonPaper(1024, 508, 1 / AgonyUI.pixelRatio, null, 850)
		}

		private function doAddBrush():void
		{
			var eraser:Shape
			var brush:IBrush

			// 加入画笔
			eraser=new Shape()
			eraser.graphics.beginFill(0x44dd44, 1)
			eraser.graphics.drawCircle(0, 0, Config.ERASER_SIZE)
			eraser.cacheAsBitmap=true

			brush=mPaper.createCopyPixelsBrush((new (BrushAssets.brush1)).bitmapData, 0, 10)
			brush.color=0xc22121
			brush.alpha=0.33
			brush.scale=0.10

//			brush = mPaper.createTransformationBrush([(new (BrushAssets.eraser)).bitmapData], 1, 15,0,0,true)
			brush=mPaper.createEraseBrush(eraser, 1, 10)
			brush.scale=2.8

			brush=mPaper.createTransformationBrush([(new (BrushAssets.light)).bitmapData], 2, 8)
			brush.color=0xc22121
			brush.alpha=0.33
			brush.scale=0.16

			mPaper.brushIndex=2


		}


	}
}
