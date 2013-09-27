package states
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.CameraRoll;
	
	import assets.ImgAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	// [ bytes ] paster - draw
	public class GameSceneUIState extends UIState
	{
		
		public static const START_DRAW:String = "startDraw"
		
		public static const TOP_AND_BOTTOM_AUTO_BACK:String = "topAndBottomAutoBack"
			
		public static const PAPER_DIRTY:String = "paperDirty"
			
			
		override public function enter():void{
			mSceneIndex = Config.SCENE_INDEX
			mTipRefList = ImgAssets.getTipList(mSceneIndex)
			
			this.doAddBg()
			this.doAddPaper()
			this.doAddListeners()
			//TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
				
			//this.fusion.interactive = false
			this.fusion.y = 127
				
		}
		
		private function doAddBg() : void{
			var img:ImagePuppet 
			var tx:Number, ty:Number
			
			// bgAA
			{
				img = new ImagePuppet
				img.embed(ImgAssets.img_bgAA)
				this.fusion.addElement(img)
			}
			
			// bgA
			{
				img = new ImagePuppet
				img.embed(ImgAssets.getBgRef(Config.SCENE_INDEX))
				this.fusion.addElement(img, 0, 35)
			}
			
			// tip...
			{
				switch(mSceneIndex)
				{
					case 0:
					{
						tx = 145
						ty = 71
						break;
					}
					case 1:
					{
						tx = 163
						ty = 53
						break;
					}
					case 2:
					{
						tx = 82
						ty = 74
						break;
					}
					case 3:
					{
						tx = 94
						ty = 154
						break;
					}
					default:
					{
						break;
					}
				}
				
				mTipImg = new ImagePuppet
				this.fusion.addElement(mTipImg, tx, ty)
			}
		}
		
		private function doAddListeners(): void{
			Agony.process.addEventListener(GameTopUIState.TURN_TO_NEXT_TIP, onTurnToNextTip)
			Agony.process.addEventListener(GameTopUIState.TAKE_PHOTO, onTakePhoto)
		}
		
		override public function exit():void{
			var ges:GestureFusion
			
			if(mDelayID >= 0){
				DelayManager.getInstance().removeDelayedCall(mDelayID)
			}
			if(mEraser){
				mEraser.kill()
			}
//			if(mIsPaperState){
//				TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
//			}
			mPaper.isStarted = false
			Agony.process.removeEventListener(GameTopUIState.TURN_TO_NEXT_TIP, onTurnToNextTip)
			Agony.process.removeEventListener(GameTopUIState.TAKE_PHOTO, onTakePhoto)
		}
		
		
		
		
		
		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////
		
		private var mBoard:Fusion
		private var mPaper:CommonPaper
		private var mImg:ImagePuppet
		private var mPixelRatio:Number, mContentRatio:Number
		private var mEraser:SpritePuppet
		private var mDelayID:int = -1
		private var mIsPaperState:Boolean = true
		private var mTipImg:ImagePuppet
		private var mTipIndex:int = -1
		private var mSceneIndex:int
		private var mTipRefList:Array
		
		
		private function doAddPaper():void
		{	
			var img:ImagePuppet
			
			mPixelRatio = AgonyUI.pixelRatio
			mPaper = DrawingManager.getInstance().paper
			mPaper.isStarted = true
			mContentRatio = mPaper.contentRatio
			
			// board...
			{
				mBoard = new Fusion
//				mBoard.interactive = false
					
				// paper...
				{
					mImg = new ImagePuppet
					//mImg.interactive = false
					mImg.bitmapData = mPaper.content
					mImg.scaleX = mImg.scaleY = 1 / mContentRatio
					mBoard.addElement(mImg)
					mImg.addEventListener(AEvent.PRESS, __onNewTouch)
				}
						
				this.fusion.addElement(mBoard, 0, 35)	
			}
		}
		
		private function getEraser() : IComponent {
			if(!mEraser){
				mEraser = new SpritePuppet
				mEraser.cacheAsBitmap = true
				mEraser.interactive=false
			}
			mEraser.graphics.clear()
			mEraser.graphics.lineStyle(1.4, 0, 0.9)
			mEraser.graphics.beginFill(0xdddd44, 0.15)
			mEraser.graphics.drawCircle(0,0,mPaper.currBrush.scale * Config.ERASER_SIZE)
			return mEraser
		}
		
		private function __onNewTouch(e:AEvent):void
		{
			var touch:Touch
			var ratio:Number
			var point:Point
			
//			ratio = 1 / mContentRatio * mBoard.scaleRatio
			ratio = 1 / mContentRatio * mPixelRatio
			touch = AgonyUI.currTouch
			//trace(ratio)
//			point = mImg.transformCoord(touch.stageX  , touch.stageY )
//			point = mImg.transformCoord(touch.stageX  , touch.stageY )	
			point = mImg.transformCoord(touch.stageX / mPixelRatio, touch.stageY / mPixelRatio )
				
//			if(mPaper.drawPoint(touch.stageX * ratio, touch.stageY * ratio)){
			//trace(point)
//			if(mPaper.drawPoint(point.x, point.y)){
			if(mPaper.startDraw(point.x* ratio, point.y* ratio)){
				touch.addEventListener(AEvent.MOVE, __onMove, false, 22000)
				touch.addEventListener(AEvent.RELEASE, __onRelease, false,22000)
				
				if(mPaper.isEraseState){
					mBoard.addElement(this.getEraser(), point.x* 1 / mContentRatio, point.y* 1 / mContentRatio)
				}
				//Logger.reportMessage(this, "new touch...")
				if(!DrawingManager.getInstance().isPaperDirty){
					Agony.process.dispatchDirectEvent(PAPER_DIRTY)
					DrawingManager.getInstance().isPaperDirty = true
				}
				Agony.process.dispatchDirectEvent(START_DRAW)
			}
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			var ratio:Number
			var pointA:Point, pointB:Point
			
//			ratio = 1 / mContentRatio * mBoard.scaleRatio
			ratio = 1 / mContentRatio * mPixelRatio
			touch = e.target as Touch
//			trace(ratio)
			
			pointA = mImg.transformCoord(touch.stageX / mPixelRatio , touch.stageY  / mPixelRatio)
			pointB = mImg.transformCoord(touch.prevStageX / mPixelRatio , touch.prevStageY / mPixelRatio )
				
//			pointA = mImg.transformCoord(touch.stageX , touch.stageY )
//			pointB = mImg.transformCoord(touch.prevStageX , touch.prevStageY )
				
			//trace(pointA + "..." + pointB)
//			mPaper.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY)
//			mPaper.drawLine(pointA.x, pointA.y,pointB.x, pointB.y)
			mPaper.drawLine(pointA.x * ratio, pointA.y * ratio,pointB.x * ratio,pointB.y * ratio)
			if(mEraser){
				mEraser.x = pointA.x * 1 / mContentRatio
				mEraser.y = pointA.y * 1 / mContentRatio
			}
			e.stopImmediatePropagation()
		}
		
		private function __onRelease(e:AEvent):void {
			mPaper.endDraw()
			if(mEraser){
				mEraser.kill()
				mEraser = null
			}
		}
		
		private function onStateToBrush(e:AEvent):void{
			mIsPaperState = true
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		}
		
		private function onTurnToNextTip(e:AEvent):void{
			if(++mTipIndex < mTipRefList.length){
				mTipImg.embed(mTipRefList[mTipIndex], false)
				
			}
			else{
				mTipIndex = -1
				mTipImg.bitmapData = null
			}
		}
		
		private function onTakePhoto(e:AEvent):void{
			var roll:CameraRoll
			var BA:BitmapData
			
			if(CameraRoll.supportsAddBitmapData){
				BA = new BitmapData(this.fusion.spaceWidth, this.fusion.spaceHeight, true, 0x0)
				BA.draw(this.fusion.displayObject)
				roll = new CameraRoll
				roll.addBitmapData(BA)
				roll.addEventListener(Event.COMPLETE, onCameraRollComplete)
			}
			//trace(this.fusion.spaceWidth, this.fusion.spaceHeight)
		}
		
		private function onCameraRollComplete(e:Event):void{
			var roll:CameraRoll
			
			roll = e.target as CameraRoll
			roll.removeEventListener(Event.COMPLETE, onCameraRollComplete)
			trace("camera roll complete...")
		}
	}
}