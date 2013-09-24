package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	//import org.agony2d.debug.Logger;
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
public class PaperBase extends DrawingBase {
	
	public function PaperBase( contentRatio:Number ) {
		super(contentRatio)
	}
	
	public function get content() : BitmapData {
		return m_content
	}
	
	/** [0 ~ 1] */
	public function get contentRatio() : Number {
		return m_contentRatio// > 1 ? 1: m_contentRatio
	}
	
	public function get fitRatio() : Number {
		return m_fitRatio
	}
	
	/** override... */
//	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
//		return null
//	}
//	
//	/** override... */
//	public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
//		return null
//	}

//	public function getBrushByIndex( index:int ) : IBrush {
//		return m_brushList[index]
//	}
	
	/** override... */
	public function dispose() : void {
		
	}
	
	protected function redraw( position:int, startPosition:int ) : void {
		var type:int
		var currX:Number, currY:Number, prevX:Number, prevY:Number
		var brush:BrushBase
		
		m_content.fillRect(m_content.rect, 0x0)
		m_bytesB.position = startPosition
		while (m_bytesB.position < position) {
			type             =  m_bytesB.readByte()
			brush            =  m_brushList[m_bytesB.readShort()]
			brush.m_density  =  m_bytesB.readShort() * .1	
			brush.m_scale    =  m_bytesB.readShort() * .1
			brush.m_color    =  m_bytesB.readUnsignedInt()
			currX            =  m_bytesB.readShort() * .1
			currY            =  m_bytesB.readShort() * .1
			if (brush is TransformationBrush) {
				cachedAngle = m_bytesB.readShort() * .001
			}
			if (type == 0) {
				brush.drawPoint(currX, currY)
				//m_delay.delayedCall(time, drawPoint, localX, localY, scale, brushIndex)
			}
			else if (type == 1) {
				prevX  =  m_bytesB.readShort() * .1
				prevY  =  m_bytesB.readShort() * .1
				brush.drawLine(currX, currY, prevX, prevY)
				//m_delay.delayedCall(time, drawLine, localX, localY, prevLocalX, prevLocalY, scale, prevScale, brushIndex)
			}
			m_bytesB.readInt() * .001 // time
		}
	}
	
	agony_internal var m_brushList:Vector.<BrushBase> = new <BrushBase>[]
	agony_internal var m_brushIndex:int
	agony_internal var m_bytesB:ByteArray = new ByteArray // output bytes...
	agony_internal var m_base:BitmapData
}
}