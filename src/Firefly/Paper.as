package Firefly
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;

	import models.PosVO;

	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;

	import states.GameTopAUIState;

	public class Paper extends MovieClip
	{


		private var _mc:Sprite;
		private var bm:Bitmap;
		private var bmd:BitmapData;
		private var paper_mc:Sprite;
		private var oldX:Number;
		private var oldY:Number;
		private var oldScale:Number;
		private var brush_mc:Sprite;

		private var defaultScale:Number=.8; //默认笔触的大小
		private var cx:Number=.02; //粗细变化参数
		private var brushMin:Number=.08; //最细笔触限制
		private var brushAlpha:Number=.3; //笔刷浓度
		private var brushBlur:Number=2; //笔刷模糊
		private var midu:Number=1; //笔刷密度
		private var mDirty:Boolean
		private var bf:BlurFilter;
		private var mIsTranslateState:Boolean

		public static const PAPER_DIRTY:String="paperDirty"


		public function Paper()
		{
			bf=new BlurFilter(brushBlur, brushBlur);
			_mc=new Brush();
			_mc.alpha=brushAlpha;
			_mc.scaleX=_mc.scaleY=defaultScale;
			_mc.filters=new Array(bf);
			paper_mc=new Sprite();
			addChild(paper_mc);
			paper_mc.addChild(_mc);
			brush_mc=new Sprite();
			paper_mc.addChild(brush_mc);
			_mc.visible=false;

//			addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
//			addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, _mouseDown, 1000000)
			bmd=new BitmapData(1024, 508, true, 0x0);
			bm=new Bitmap(bmd);
			addChild(bm);

			Agony.process.addEventListener(GameTopAUIState.PAPER_CLEAR, onPaperClear)
			Agony.process.addEventListener(GameTopAUIState.TURN_TO_TRANSLATE, onTurnToTranslate)
		}

		private function onPaperClear(e:AEvent):void
		{
			this.clear()
		}

		private function onTurnToTranslate(e:DataEvent):void
		{
			mIsTranslateState=e.data as Boolean
		}

		public function clear():void
		{
			if (mDirty)
			{
				mDirty=false
				bmd.fillRect(bmd.rect, 0x0)
			}
		}

		public function kill():void
		{
			bmd.dispose()
			Agony.process.removeEventListener(GameTopAUIState.PAPER_CLEAR, onPaperClear)
			Agony.process.removeEventListener(GameTopAUIState.TURN_TO_TRANSLATE, onTurnToTranslate)
		}

		private function _mouseUp(e:AEvent):void
		{
			_mc.visible=false;
			_mc.scaleX=_mc.scaleY=1;
			stopDrag();
		}

		private function _mouseDown(e:ATouchEvent):void
		{

			var touch:Touch

			touch=e.touch

//			trace(bm.getBounds(stage), touch.stageX, touch.stageY, mIsTranslateState)

			if (!bm.getBounds(stage).contains(touch.stageX, touch.stageY) || mIsTranslateState)
			{
				return
			}
			if (!mDirty)
			{
				Agony.process.dispatchDirectEvent(PAPER_DIRTY)
				mDirty=true
			}
			var pt:Point=this.globalToLocal(new Point(touch.stageX, touch.stageY));
			oldX=_mc.x=pt.x
			oldY=_mc.y=pt.y
			oldScale=1;
			_mc.startDrag(true);
			_mc.visible=true;

			touch.addEventListener(AEvent.MOVE, _addBrush, 1000000)
			touch.addEventListener(AEvent.RELEASE, _mouseUp, 1000000)
//			addEventListener(MouseEvent.MOUSE_MOVE, _addBrush);
		}

		private function _addBrush(e:AEvent):void
		{
			var touch:Touch=e.target as Touch;

			var pt:Point=this.globalToLocal(new Point(touch.stageX, touch.stageY));
			//计算距离
			var disX:Number=pt.x - oldX;
			var disY:Number=pt.y - oldY;
			var dis:Number=Math.sqrt(disX * disX + disY * disY);
			//改变笔触的大小,越快越小
			if (dis > 0)
			{
				var scale:Number=defaultScale - dis * cx;
				if (scale > 1)
				{
					scale=1;
				}
				else if (scale < brushMin)
				{
					scale=brushMin;
				}
				scale=(oldScale + scale) / 2;
				_mc.scaleY=_mc.scaleX=scale;
			}
			//填充
			var count:int=Math.floor(dis / midu);
			var scaleBili:Number=(oldScale - scale) / count;
			for (var i:int=0; i < count - 1; i++)
			{
				var brush:Brush=new Brush();
				brush.filters=new Array(bf);
				brush.alpha=brushAlpha;
				brush.scaleX=brush.scaleY=oldScale - i * scaleBili;
				brush_mc.addChild(brush);
				brush.x=(disX / count) * (i + 1) + oldX;
				brush.y=(disY / count) * (i + 1) + oldY;
			}
			oldScale=scale;
			oldX=pt.x;
			oldY=pt.y;
			bmd.draw(paper_mc);
			//删除填充
			brush_mc.removeChildren();
//			while (brush_mc.numChildren>0) {
//				brush_mc.removeChildAt(0);
//			}
		}
	}

}

