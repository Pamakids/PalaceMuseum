package states
{
	import com.greensock.TweenLite;

	import assets.BtnAssets;
	import assets.ImgAssets;

	import drawing.CommonPaper;

	import models.Config;
	import models.DrawingManager;
	import models.StateManager;

	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameTopUIState extends UIState
	{


		public static const TURN_TO_NEXT_TIP:String="turnToNextTip"

		public static const TAKE_PHOTO:String="takePhoto"


		override public function enter():void
		{
			var imgBtn:ImageButton
			var stats:Fusion
			var img:ImagePuppet

			AgonyUI.addImageButtonData(BtnAssets.btnEffect, "btnEffect", ImageButtonType.BUTTON_RELEASE)

			mPaper=DrawingManager.getInstance().paper

			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight

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
				mBtnA=new ImageButton("btnEffect")
				this.fusion.addElement(mBtnA, 93, 64)
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
				mBtnB=new ImageButton("btnEffect")
				mBtnB.userData=1
				this.fusion.addElement(mBtnB, 42, 0, LayoutType.B__A, LayoutType.BA)
				mBtnB.addEventListener(AEvent.CLICK, onBrushStateChange)


				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnB, false)
					mBtnB.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}
				//mBtnB.image.visible = false
			}

			// C
			{
				mBtnC=new ImageButton("btnEffect")
				mBtnC.userData=2
				this.fusion.addElement(mBtnC, 42, 0, LayoutType.B__A, LayoutType.BA)
				mBtnC.addEventListener(AEvent.CLICK, onBrushStateChange)

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnC, false)
					mBtnC.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}
				mBtnC.image.visible=false
			}

			// tips...
			{
				imgBtn=new ImageButton("btnEffect")
				this.fusion.addElement(imgBtn, 42, 0, LayoutType.B__A, LayoutType.BA)
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
				mFinishBtn=new ImageButton("btnEffect")
				this.fusion.addElement(mFinishBtn, 42, 0, LayoutType.B__A, LayoutType.BA)
				mFinishBtn.image.visible=false
				this.onPaperClear(null)

				{
					img=new ImagePuppet
					img.embed(BtnAssets.btnE, false)
					mFinishBtn.addElement(img, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				}

				mFinishBtn.addEventListener(AEvent.CLICK, onTopComplete)
				mFinishBtn.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
				mFinishBtn.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
			}

//			var l:int = mImgList.length
//			while(--l>-1){
//				imgBtn = mImgList[l]
//				imgBtn.addEventListener(AEvent.PRESS, onMakeSfxForPress)
//			}
//			
			Agony.process.addEventListener(GameSceneUIState.PAPER_DIRTY, onPaperDirty)
		}

		override public function exit():void
		{
			Agony.process.removeEventListener(GameSceneUIState.PAPER_DIRTY, onPaperDirty)
			TweenLite.killTweensOf(this.fusion)

			if (mTranslateImg)
			{
				mTranslateImg.kill()
			}
		}


		private var mPaper:CommonPaper
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
				AgonyUI.fusion.addElement(mTranslateImg, 0, 162)
			}
			else
			{
				mTranslateImg.kill()
				mTranslateImg=null
			}
		}

		private function onBrushStateChange(e:AEvent):void
		{
			var target:ImageButton

			target=e.target as ImageButton
			if (target.userData == 1)
			{
				DrawingManager.getInstance().paper.brushIndex=2
				mBtnB.image.visible=true
				mBtnC.image.visible=false
			}
			else if (target.userData == 2)
			{
				DrawingManager.getInstance().paper.brushIndex=1
				mBtnB.image.visible=false
				mBtnC.image.visible=true
			}

			this.doSetTranslateState(false)
		}

		private function onTipChange(e:AEvent):void
		{
			Agony.process.dispatchDirectEvent(TURN_TO_NEXT_TIP)
			this.doSetTranslateState(false)
		}

		private function onTopComplete(e:AEvent):void
		{
			this.doSetTranslateState(false)
			Agony.process.dispatchDirectEvent(TAKE_PHOTO)
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
			DrawingManager.getInstance().isPaperDirty=false
		}

		private function onPaperDirty(e:AEvent):void
		{
			mFinishBtn.alpha=1
			mFinishBtn.interactive=true
		}
	}
}
