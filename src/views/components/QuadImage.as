package views.components
{
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	/**
	 * 软页的组成图片元件
	 * @author Administrator
	 */	
	public class QuadImage extends Image
	{
		public function QuadImage(texture:Texture)
		{
			super(texture);
		}
		
		/**
		 * 获取原始顶点数据
		 * @return 
		 */		
		public function get vertexData():VertexData
		{
			return this.mVertexData;
		}
		
		public function vertexDataChanged():void
		{
			super.onVertexDataChanged();
		}
	}
}