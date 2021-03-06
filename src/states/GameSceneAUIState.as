package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;

	import Firefly.Paper;

	import assets.ImgAssets;

	import controllers.MC;

	import models.Config;
	import models.PosVO;

	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	// [ bytes ] paster - draw
	public class GameSceneAUIState extends UIState
	{

		public static const START_DRAW:String="startDraw"

		public static const TOP_AND_BOTTOM_AUTO_BACK:String="topAndBottomAutoBack"


		override public function enter():void
		{
			mSceneIndex=Config.SCENE_INDEX
			mTipRefList=ImgAssets.getTipList(mSceneIndex)

			this.doAddBg()
			this.doAddListeners()
			//TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)

			//this.fusion.interactive = false
//			this.fusion.y=151

			var dx:Number=151;
			if (!MC.isIOS)
			{
				fusion.scaleX=fusion.scaleY=PosVO.scale;
				dx=dx * PosVO.scale;
			}
			fusion.x=PosVO.OffsetX;
			fusion.y=dx + PosVO.OffsetY;

		}

		private function doAddBg():void
		{
			var img:ImagePuppet
			var tx:Number, ty:Number

			// bgAA
			{
				img=new ImagePuppet
				img.embed(ImgAssets.img_bgAA)
				this.fusion.addElement(img)
			}

			// bgA
			{
				img=new ImagePuppet
				trace(Config.SCENE_INDEX)
				img.embed(ImgAssets.getBgRef(Config.SCENE_INDEX))
				this.fusion.addElement(img, 0, 10)
			}

			// tip...
			{
				switch (mSceneIndex)
				{
					case 0:
					{
						tx=145
						ty=71
						break;
					}
					case 1:
					{
						tx=163
						ty=53
						break;
					}
					case 2:
					{
						tx=82
						ty=74
						break;
					}
					case 3:
					{
						tx=94
						ty=154
						break;
					}
					default:
					{
						break;
					}
				}

				mTipImg=new ImagePuppet
				this.fusion.addElement(mTipImg, tx, ty)
			}
			// board...
			{
				mBoard=new Fusion
				// paper...
				{
					var sprite:SpritePuppet=new SpritePuppet
					mBoard.addElement(sprite)
					{
						mPaper=new Paper
						sprite.addChild(mPaper)
						mPaper.width=1030;
						mPaper.height=586;
//						mPaper.scaleX=mPaper.scaleY=PosVO.scale;
					}
				}

				this.fusion.addElement(mBoard, 0, 15)
			}
		}

		private function doAddListeners():void
		{
			Agony.process.addEventListener(GameTopUIState.TURN_TO_NEXT_TIP, onTurnToNextTip)
			Agony.process.addEventListener(GameTopUIState.TAKE_PHOTO, onTakePhoto)
		}

		override public function exit():void
		{
			var ges:GestureFusion

			if (mDelayID >= 0)
			{
				DelayManager.getInstance().removeDelayedCall(mDelayID)
			}
			if (mEraser)
			{
				mEraser.kill()
			}
			//			if(mIsPaperState){
			//				TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
			//			}
			Agony.process.removeEventListener(GameTopUIState.TURN_TO_NEXT_TIP, onTurnToNextTip)
			Agony.process.removeEventListener(GameTopUIState.TAKE_PHOTO, onTakePhoto)
			mPaper.kill()
			if (mPhoto)
			{
				TweenLite.killTweensOf(mPhoto)
				mPhoto.kill()
				mPhoto=null
			}
		}





		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////

		private var mPaper:MovieClip
		private var mBoard:Fusion
		private var mImg:ImagePuppet
		private var mPixelRatio:Number, mContentRatio:Number
		private var mEraser:SpritePuppet
		private var mDelayID:int=-1
		private var mIsPaperState:Boolean=true
		private var mTipImg:ImagePuppet
		private var mTipIndex:int=-1
		private var mSceneIndex:int
		private var mTipRefList:Array
		private var mPhoto:ImagePuppet

		private var clickAble:Boolean=true;

		private function onTurnToNextTip(e:AEvent):void
		{
			if (++mTipIndex < mTipRefList.length)
			{
				mTipImg.embed(mTipRefList[mTipIndex], false)

			}
			else
			{
				mTipIndex=-1
				mTipImg.bitmapData=null
			}
		}

		private function onTakePhoto(e:AEvent):void
		{
			if (!clickAble)
				return;
			var roll:CameraRoll
			var BA:BitmapData

			if (mPhoto)
			{
				TweenLite.killTweensOf(mPhoto)
				mPhoto.kill()
				mPhoto=null
			}

			BA=new BitmapData(this.fusion.spaceWidth, this.fusion.spaceHeight, true, 0x0)
			BA.draw(this.fusion.displayObject, new Matrix(1 / Agony.pixelRatio, 0, 0, 1 / Agony.pixelRatio))
			{
				var sc:Number=PosVO.scale;
				sc=1;
				clickAble=false;
				mPhoto=new ImagePuppet(5)
				mPhoto.bitmapData=BA
				mPhoto.scaleX=sc
				mPhoto.scaleY=sc
				this.fusion.addElement(mPhoto, AgonyUI.fusion.spaceWidth / 2, AgonyUI.fusion.spaceHeight / 2 - 100)
				TweenLite.to(mPhoto, 1, {scaleX: 0.8 * sc, scaleY: 0.8 * sc, ease: Cubic.easeOut, onComplete: function():void {
					TweenLite.to(mPhoto, 0.5, {alpha: 0, onComplete: function():void {
						clickAble=true;
						mPhoto.kill()
						mPhoto=null
					}})

				}})
			}
			if (CameraRoll.supportsAddBitmapData)
			{
				roll=new CameraRoll
				roll.addBitmapData(BA)
				roll.addEventListener(Event.COMPLETE, onCameraRollComplete)
			}
			//trace(this.fusion.spaceWidth, this.fusion.spaceHeight)
		}

		private function onCameraRollComplete(e:Event):void
		{
			var roll:CameraRoll

			roll=e.target as CameraRoll
			roll.removeEventListener(Event.COMPLETE, onCameraRollComplete)
			trace("camera roll complete...")
		}
	}
}
