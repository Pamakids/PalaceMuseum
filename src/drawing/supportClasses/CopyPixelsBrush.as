package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	//import org.agony2d.debug.Logger;
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
public class CopyPixelsBrush extends BrushBase{
	
	public function CopyPixelsBrush( contentRatio:Number, fitRatio:Number, content:BitmapData, source:IBitmapDrawable, density:Number ) {
		super(contentRatio, fitRatio, content, density)
		m_data = sourceToBitmapData(source)
		cachedData = m_data.clone()
		cachedWidth = m_data.width * m_scale * m_fitRatio
		cachedHeight = m_data.height * m_scale * m_fitRatio
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		var tScale:Number
		
		if (m_prevScale != m_scale) {
			//if(m_prevColor != m_color || m_prevAlpha != m_alpha){
				tScale = m_scale * m_fitRatio
				cachedWidth = m_data.width * tScale
				cachedHeight = m_data.height * tScale
				cachedMatrix.identity()
				cachedMatrix.scale(tScale, tScale)
				cachedData = new BitmapData(cachedWidth, cachedHeight, true, 0x0)
				cachedData.draw(m_data, cachedMatrix, this.getColorTransform(), null, null, true)
				m_prevScale = m_scale
				m_prevColor = m_color
				m_prevAlpha = m_alpha
			//}
		}
		else if(m_prevColor != m_color || m_prevAlpha != m_alpha){
			tScale = m_scale * m_fitRatio
			cachedMatrix.identity()
			cachedMatrix.scale(tScale, tScale)
			cachedData.fillRect(cachedData.rect, 0x0)
			cachedData.draw(m_data, cachedMatrix, this.getColorTransform(), null, null, true)
			m_prevColor = m_color
			m_prevAlpha = m_alpha
		}
		
		cachedPoint.x = destX - cachedWidth  * .5
		cachedPoint.y = destY - cachedHeight * .5
		m_content.copyPixels(cachedData, cachedData.rect, cachedPoint, null, null, true)
	}
	
	agony_internal var m_data:BitmapData, cachedData:BitmapData
	agony_internal var cachedWidth:Number, cachedHeight:Number, m_prevScale:Number, m_prevAlpha:Number
	agony_internal var m_prevColor:uint = 0xFFFFFF
}
}