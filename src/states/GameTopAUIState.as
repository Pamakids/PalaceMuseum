package states
{
	import com.greensock.TweenLite;

	import Firefly.Paper;

	import assets.BtnAssets;
	import assets.ImgAssets;

	import models.Config;
	import models.PosVO;
	import models.StateManager;

	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	import sound.SoundAssets;

	public class GameTopAUIState extends UIState
	{
		public static const TURN_TO_NEXT_TIP:String="turnToNextTip"

		public static const TAKE_PHOTO:String="takePhoto"

		public static const PAPER_CLEAR:String="paperClear"

		public static const TURN_TO_TRANSLATE:String="turnToTranslate"


		override public function enter():void
		{
			var imgBtn:ImageButton
			var stats:Fusion
			var img:ImagePuppet

			AgonyUI.addImageButtonData(BtnAssets.btnAEffect, "btnAEffect", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(BtnAssets.btnBEffect, "btnBEffect", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(BtnAssets.btnCEffect, "btnCEffect", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(BtnAssets.btnDEffect, "btnDEffect", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(BtnAssets.btnEEffect, "btnEEffect", ImageButtonType.BUTTON_RELEASE)

			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight

			fusion.scaleX=fusion.scaleY=PosVO.scale;
			fusion.x=PosVO.OffsetX;
			fusion.y=PosVO.OffsetY;

			// bgAAA
			{
				img=new ImagePuppet
				img.interactive=false
				img.embed(ImgAssets.img_bgAAA)
				this.fusion.addElement(img)
			}

			mImgList=[]

			// A
			{
				mBtnA=new ImageButton("btnAEffect")
				this.fusion.addElement(mBtnA, 0, 8)
				mBtnA.addEventListener(AEvent.CLICK, onTranslate)

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnA, false)
					mBtnA.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)

				}
				mBtnA.image.visible=false
			}

			// B
			{
				mBtnB=new ImageButton("btnBEffect")
				mBtnB.userData=1
				this.fusion.addElement(mBtnB, -20, 0, LayoutType.B__A, LayoutType.BA)
				//mBtnB.addEventListener(AEvent.CLICK, onBrushStateChange)


				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnB, false)
					mBtnB.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}
				//mBtnB.image.visible = false
			}

			// C
			{
				mBtnC=new ImageButton("btnCEffect")
				mBtnC.userData=2
				this.fusion.addElement(mBtnC, -16, 0, LayoutType.B__A, LayoutType.BA)
				mBtnC.addEventListener(AEvent.CLICK, onPaperClear)

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnC, false)
					mBtnC.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}
				mBtnC.image.visible=false
			}

			// tips...
			{
				imgBtn=new ImageButton("btnDEffect")
				this.fusion.addElement(imgBtn, -3, 0, LayoutType.B__A, LayoutType.BA)
				imgBtn.image.visible=false

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnD, false)
					imgBtn.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}


				imgBtn.addEventListener(AEvent.CLICK, onTipChange)
				imgBtn.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
				imgBtn.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
			}

			// complete
			{
				mFinishBtn=new ImageButton("btnEEffect")
				this.fusion.addElement(mFinishBtn, -11, 0, LayoutType.B__A, LayoutType.BA)
				mFinishBtn.image.visible=false
//				this.onPaperClear(null)

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnE, false)
					mFinishBtn.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}

				mFinishBtn.addEventListener(AEvent.CLICK, onTakePhoto)
				mFinishBtn.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
				mFinishBtn.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
			}

			//			var l:int = mImgList.length
			//			while(--l>-1){
			//				imgBtn = mImgList[l]
			//				imgBtn.addEventListener(AEvent.PRESS, onMakeSfxForPress)
			//			}
			//		
			{
				img=new ImagePuppet(5)
				img.embed(BtnAssets.btn_close, false)
				this.fusion.addElement(img, AgonyUI.fusion.spaceWidth - 60, 60)
				img.addEventListener(AEvent.CLICK, onTopComplete)
			}

			Agony.process.addEventListener(Paper.PAPER_DIRTY, onPaperDirty)
		}

		override public function exit():void
		{
			Agony.process.removeEventListener(Paper.PAPER_DIRTY, onPaperDirty)
			TweenLite.killTweensOf(this.fusion)

			if (mTranslateImg)
			{
				mTranslateImg.kill()
			}
		}


		private var mImgList:Array
		private var mFinishBtn:ImageButton
		private var mIsTranslateState:Boolean
		private var mBtnA:ImageButton, mBtnB:ImageButton, mBtnC:ImageButton
		private var mTranslateImg:ImagePuppet



		private function onTranslate(e:AEvent):void
		{
			this.doSetTranslateState(!mIsTranslateState)
		}

		private function doSetTranslateState(b:Boolean):void
		{
			if (mIsTranslateState == b)
			{
				return
			}

			mBtnA.image.visible=mIsTranslateState=!mIsTranslateState
			if (mIsTranslateState)
			{
				mTranslateImg=new ImagePuppet
				mTranslateImg.embed(ImgAssets.getTranslateRef(Config.SCENE_INDEX), false)
				AgonyUI.fusion.addElement(mTranslateImg, 0, 202)
			}
			else
			{
				mTranslateImg.kill()
				mTranslateImg=null
			}
			Agony.process.dispatchEvent(new DataEvent(TURN_TO_TRANSLATE, mIsTranslateState))
		}

		private function onClear(e:AEvent):void
		{
			var target:ImageButton

			target=e.target as ImageButton
//			if(target.userData == 1){
//				DrawingManager.getInstance().paper.brushIndex = 2
//				mBtnB.image.visible = true
//				mBtnC.image.visible = false
//			}
//			else if(target.userData == 2){
//				DrawingManager.getInstance().paper.brushIndex = 1
//				mBtnB.image.visible = false
//				mBtnC.image.visible = true
//			}

			this.doSetTranslateState(false)
		}

		private function onTipChange(e:AEvent):void
		{
			Agony.process.dispatchDirectEvent(TURN_TO_NEXT_TIP)
			this.doSetTranslateState(false)
		}

		private function onTakePhoto(e:AEvent):void
		{
			SoundAssets.playSFX('camera');
			this.doSetTranslateState(false)
			Agony.process.dispatchDirectEvent(TAKE_PHOTO)
		}

		private function onTopComplete(e:AEvent):void
		{
			StateManager.setGameScene(false)

			if (Config.onComplete != null)
			{
				Config.onComplete()
			}
		}



		private const SCALE_A:Number=0.85
		private const SCLAE_T:Number=0.3

		private function onButtonPress(e:AEvent):void
		{
			var target:ImageButton

			target=e.target as ImageButton
			target.image.visible=true
		}

		private function onButtonRelease(e:AEvent):void
		{
			var target:ImageButton

			target=e.target as ImageButton
			target.image.visible=false
		}


		private function onPaperClear(e:AEvent):void
		{
			mFinishBtn.alpha=0.44
			mFinishBtn.interactive=false
			this.doSetTranslateState(false)
//			DrawingManager.getInstance().isPaperDirty = false
			Agony.process.dispatchDirectEvent(PAPER_CLEAR)
		}

		private function onPaperDirty(e:AEvent):void
		{
			mFinishBtn.alpha=1
			mFinishBtn.interactive=true
		}
	}
}
