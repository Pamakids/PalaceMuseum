package drawing.supportClasses {
	import flash.display.BitmapData;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.utils.MathUtil;
	
	use namespace agony_internal;
	
public class TransformationBrush extends BrushBase {
	
	public function TransformationBrush( contentRatio:Number, fitRatio:Number, content:BitmapData, sourceList:Array, density:Number, 
										appendScaleLow:Number, appendScaleHigh:Number, rotatable:Boolean ) {
		var i:int
		
		super(contentRatio, fitRatio, content, density)
		m_dataList = new <BitmapData>[]
		m_length = sourceList.length
		for (i = 0; i < m_length; i++) {
			m_dataList[i] = sourceToBitmapData(sourceList[i])
		}
		m_appendScaleLow = appendScaleLow
		m_appendScaleHigh = appendScaleHigh
		m_rotatable = rotatable
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		var data:BitmapData
		var tmpScale:Number
		
		tmpScale = ((m_appendScaleLow != 0 || m_appendScaleHigh != 0) ? (m_scale + MathUtil.getRandomBetween(m_appendScaleLow, m_appendScaleHigh)) : m_scale) * m_fitRatio
		data = m_dataList[int(m_length * Math.random())]
		cachedMatrix.identity()
		cachedMatrix.translate(-data.width * .5, -data.height * .5)
		cachedMatrix.scale(tmpScale, tmpScale)
		if (m_rotatable) {
			cachedMatrix.rotate(cachedAngle)
		}
		cachedMatrix.translate(destX, destY)
		m_content.drawWithQuality(data, cachedMatrix, this.getColorTransform(), null, null, false,"low")

	}
	
	final override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var distA:Number, tmpX:Number, tmpY:Number
		var i:int, l:int
		
		tmpX = currX - prevX
		tmpY = currY - prevY
		distA = Math.sqrt(tmpX * tmpX + tmpY * tmpY)
		l = Math.ceil(distA / m_density / m_fitRatio / m_scale)
		while (++i <= l) {
			this.drawPoint(prevX + tmpX * i / l, prevY + tmpY * i / l)
			cachedAngle += ADDED_ANGLE
		}	
		//m_rotateSeed = 0
	}
	
	internal var ADDED_ANGLE:Number = 44 * Math.PI / 180
	internal var m_dataList:Vector.<BitmapData>
	internal var m_length:int
	internal var m_appendScaleLow:Number, m_appendScaleHigh:Number
	internal var m_rotatable:Boolean
	//internal var m_rotateSeed:Number = 0
}
}