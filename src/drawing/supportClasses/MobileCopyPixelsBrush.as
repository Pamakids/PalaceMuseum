package drawing.supportClasses{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
public class MobileCopyPixelsBrush extends CopyPixelsBrush{
	
	public function MobileCopyPixelsBrush(pixelRatio:Number, source:IBitmapDrawable, density:Number){
		super(pixelRatio, null, source, density);
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		var spot:ImagePuppet
		
		if (m_prevScale != m_scale || m_prevColor != m_color) {
			cachedWidth = m_data.width * m_scale
			cachedHeight = m_data.height * m_scale
			cachedData = new BitmapData(cachedWidth, cachedHeight, true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.scale(m_scale, m_scale)
			cachedData.draw(m_data, cachedMatrix, this.getColorTransform(), null, null, true)
			m_prevScale = m_scale
			m_prevColor = m_color
		}
		spot = new ImagePuppet(5)
		spot.bitmapData = cachedData
		m_buffer.addElement(spot, destX/m_contentRatio, destY/m_contentRatio)
	}
	
	agony_internal var m_buffer:Fusion
}
}