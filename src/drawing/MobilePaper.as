package drawing {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.utils.getTimer;
	
	import drawing.supportClasses.MobileCopyPixelsBrush;
	import drawing.supportClasses.MobileTransformationBrush;
	import drawing.supportClasses.PaperBase;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
public class MobilePaper extends PaperBase {
	
	public function MobilePaper(board:Fusion, paperWidth:int, paperHeight:int, pixelRatio:Number=1, data:BitmapData=null) {
		var img:ImagePuppet
		
		super(paperWidth, paperHeight, pixelRatio, data);
		m_board = board
		m_board.interactive = false
		img = new ImagePuppet
		img.bitmapData = m_content
		m_board.addElement(img)
		m_buffer = new Fusion
		m_board.addElement(m_buffer)
	}
	
	override public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		var brush:MobileCopyPixelsBrush
		m_brushList[index] = brush = new MobileCopyPixelsBrush(m_contentRatio, source, density)
		brush.m_buffer = m_buffer
		return brush
	}
	
	override public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		var brush:MobileTransformationBrush
		m_brushList[index] = brush = new MobileTransformationBrush(m_contentRatio, sourceList, density, appendScaleLow, appendScaleHigh, rotatable)
		brush.m_buffer = m_buffer
		return brush
	}
	
//	override public function drawPoint( destX:Number, destY:Number ) : void {
//		super.drawPoint(destX / m_pixelRatio, destY / m_pixelRatio)
//		if(!m_dirty){
//			m_dirty = true
//		}
//	}
	
//	override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
//		super.drawLine(currX / m_pixelRatio, currY / m_pixelRatio, prevX / m_pixelRatio, prevY / m_pixelRatio)
//		if(!m_dirty){
//			m_dirty = true
//		}
//	}
	
//	override public function update( deltaTime:Number ) : void {
//		super.update(deltaTime)
//		if(++m_numFrames > 12){// || m_numSpot > 100){
//			this.doFlush()
//			m_numFrames = 0
//		}
//	}
	
	override public function addCommand() : void {
		super.addCommand()
		this.doFlush()
	}
	
	protected function doFlush() : void{
		if(m_numSpot){
			//var rect:Rectangle = m_buffer.displayObject.getBounds(Agony.stage)
			//trace(rect)
			var t:int = getTimer()
			m_content.draw(m_buffer.displayObject, null, null, null, null, false)
			Logger.reportMessage(this, m_buffer.numElement + "...elapsedT: " + (getTimer() - t))
			m_buffer.removeAllElement()
			m_numSpot = 0
		}
	}
	
	agony_internal var m_board:Fusion, m_buffer:Fusion
	agony_internal var m_dirty:Boolean
	agony_internal var m_numFrames:int
}
}