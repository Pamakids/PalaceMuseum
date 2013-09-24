package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
public class DrawingBase {
	
	public function DrawingBase( contentRatio:Number ) {
		m_contentRatio = contentRatio
	}
	
	agony_internal static var cachedPoint:Point = new Point
	agony_internal static var cachedMatrix:Matrix = new Matrix
	agony_internal static var cachedColorTransform:ColorTransform = new ColorTransform
	agony_internal static var cachedAngle:Number
	agony_internal static var cachedTwoPI:Number = Math.PI * 2

	agony_internal var m_contentRatio:Number, m_fitRatio:Number
	agony_internal var m_content:BitmapData
}
}