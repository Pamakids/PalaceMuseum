package views.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;

	/**
	 * 软页
	 * @author Administrator
	 */	
	public class SoftPageImage extends Image
	{
		//四个点确定一个能动的页面
		private var _dragPoint:Point;
		private var _dragPointCopy:Point;
		private var _edgePoint:Point;
		private var _edgePointCopy:Point;
		
		/**
		 * @param texture
		 */		
		public function SoftPageImage(texture:Texture)
		{
			super(texture);
		}
		
		/**新一页纹理*/
		public var anotherTexture:Texture;
		
		/**重置四个顶点坐标*/
		private function resetAllTexCoords():void
		{
			mVertexData.setTexCoords(0, 0, 0);
			mVertexData.setTexCoords(1, 1, 0);
			mVertexData.setTexCoords(2, 0, 1);
			mVertexData.setTexCoords(3, 1.0, 1.0);
		}
		
		/**@override*/
		override public function readjustSize():void
		{
			super.readjustSize();
			resetAllTexCoords();
			onVertexDataChanged();
		}
		
		/**设置顶点位置：软皮模式*/
		public function setLocationSoft(quadBatch:QuadBatch, progress:Number, defaultDirection:Boolean = false):void
		{
			
		}
	}
}