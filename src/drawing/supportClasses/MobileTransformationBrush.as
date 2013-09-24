package drawing.supportClasses{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
public class MobileTransformationBrush extends TransformationBrush{
	
	public function MobileTransformationBrush( pixelRatio:Number, sourceList:Array, density:Number, 
											   appendScaleLow:Number, appendScaleHigh:Number, rotatable:Boolean ) {
		super(pixelRatio, null, sourceList, density, appendScaleLow, appendScaleHigh, rotatable);
		cachedDataList = m_dataList.concat()
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		var data:BitmapData
		var tmpScale:Number
		var spot:ImagePuppet
		var i:int
		var ctf:ColorTransform
		
		if(m_prevColor != m_color){
			ctf = this.getColorTransform()
			while(i<m_length){
				cachedDataList[i] = data = m_dataList[i++].clone()
				data.colorTransform(data.rect, ctf)
			}
			m_prevColor = m_color
		}
		
		tmpScale = (m_appendScaleLow != 0 || m_appendScaleHigh != 0) ? (m_scale + MathUtil.getRandomBetween(m_appendScaleLow, m_appendScaleHigh)) : m_scale
		data = cachedDataList[int(m_length * Math.random())]
		spot = new ImagePuppet(5)
		spot.bitmapData = data
		if(tmpScale != 1 && (m_appendScaleLow != 0 || m_appendScaleHigh != 0)){
			tmpScale = (m_appendScaleLow != 0 || m_appendScaleHigh != 0) ? (m_scale + MathUtil.getRandomBetween(m_appendScaleLow, m_appendScaleHigh)) : m_scale
			spot.scaleX = spot.scaleY = tmpScale
		}
		if (m_rotatable) {
			spot.rotation = cachedAngle / cachedTwoPI * 360
		}
		m_buffer.addElement(spot, destX/m_contentRatio, destY/m_contentRatio)
	}
	
	agony_internal var m_buffer:Fusion
	agony_internal var m_prevColor:uint = 0xFFFFFF
	agony_internal var cachedDataList:Vector.<BitmapData>
}
}
