package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
final public class EraseBrush extends BrushBase {
	
	public function EraseBrush(contentRatio:Number, fitRatio:Number,  density:Number, content:BitmapData, source:DisplayObject) {
		var bounds:Rectangle
		
		super(contentRatio, fitRatio, content, density)
		m_data = source
		m_data.blendMode = BlendMode.LAYER
		bounds = source.getBounds(source)
		m_offsetX = (bounds.left + bounds.right) / 2
		m_offsetY = (bounds.top + bounds.bottom) / 2
	}
	
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		cachedMatrix.identity()
		cachedMatrix.scale(m_scale * m_fitRatio, m_scale * m_fitRatio)
//		cachedMatrix.scale(m_scale , m_scale )
		cachedMatrix.translate(destX - m_offsetX, destY - m_offsetY)
//		m_content.drawWithQuality(m_data, cachedMatrix, null, BlendMode.ERASE, null, false, "low")
		m_content.draw(m_data, cachedMatrix, null, BlendMode.ERASE, null, false)
		//m_content.fillRect(new Rectangle(destX - 30, destY - 30, 60,60),0x0)
	}
	
	agony_internal var m_data:DisplayObject
	agony_internal var m_offsetX:Number, m_offsetY:Number
}
}