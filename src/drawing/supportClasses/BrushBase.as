package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import drawing.IBrush;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;

public class BrushBase extends DrawingBase implements IBrush{
	
	public function BrushBase( pixelRatio:Number, fitRatio:Number, content:BitmapData, density:Number ) {
		super(pixelRatio)
		m_fitRatio = fitRatio
		m_content = content
		this.density = m_rawDensity = density
		m_color = 0x0
		m_scale = m_alpha = 1
	}
	
	/** 每隔多少像素绘制一次，最低不小于3... */
	public function get density() : Number {
		return m_density
	}
	
	public function set density( v:Number ) : void {
		m_density = (v < 3 ? 3 : v)// * m_contentRatio
	}
	
	public function get scale() : Number {
		return m_scale
	}
	
	public function set scale( v:Number ) : void {
		m_scale = v
	}
	
	public function get color() : uint {
		return m_color
	}
	
	public function set color( v:uint ) : void {
		m_color = v
	}
	
	public function get alpha() : Number {
		return m_alpha
	}
	
	public function set alpha( v:Number ) : void {
		m_alpha = v
	}
	
	/** override... */
	public function drawPoint( destX:Number, destY:Number ) : void {
		
	}
	
	public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var distA:Number, tmpX:Number, tmpY:Number
		var i:int, l:int
		
		tmpX = currX - prevX
		tmpY = currY - prevY
		distA = Math.sqrt(tmpX * tmpX + tmpY * tmpY)
		l = Math.ceil(distA / m_density / m_fitRatio / m_scale)
		while (++i <= l) {
			this.drawPoint(prevX + tmpX * i / l, prevY + tmpY * i / l)
		}	
	}
	
	public function reset() : void{
		m_color = 0x0
		m_scale = m_alpha = 1
		this.density = m_rawDensity
	}
	
	protected function sourceToBitmapData( source:IBitmapDrawable ) : BitmapData {
		var rect:Rectangle
		var result:BitmapData
		
		if (source is BitmapData) {
			result = (source as BitmapData).clone()
		}
		else {
			rect = (source is BitmapData) ? (source as BitmapData).rect : (source as DisplayObject).getBounds(source as DisplayObject)
			result = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.translate(-rect.x, -rect.y)
			result.draw(source, cachedMatrix, null, null, null, true)
		}
		return result
	}
	
	protected function getColorTransform() :  ColorTransform {
		var r:Number, g:Number, b:Number
		
		r = ((m_color >> 16) & 255) / 255.0;
		g = ((m_color >> 8) & 255) / 255.0;
		b = (m_color & 255) / 255.0;
		cachedColorTransform.redMultiplier = r;
		cachedColorTransform.greenMultiplier = g;
		cachedColorTransform.blueMultiplier = b;
		cachedColorTransform.alphaMultiplier = m_alpha;
		//cachedColorTransform.redOffset = cachedColorTransform.greenOffset = cachedColorTransform.blueOffset = cachedColorTransform.alphaOffset = 0
		return cachedColorTransform
	}
	
	public var m_scale:Number, m_alpha:Number, m_density:Number, m_rawDensity:Number
	public var m_color:uint
}
}