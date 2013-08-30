package views.components
{
	import starling.display.Image;
	import starling.textures.Texture;

	public class FlipImage extends Image
	{

		private var horizontal:Boolean;
		/**
		 * 从小到大，从左往右
		 */
		private var minToMax:Boolean;
		/**
		 * 翻滚时从-1到1是否相连
		 */
		private var coherent:Boolean;

		/**
		 * 折叠图片
		 * @param texture 图片材质
		 * @param horizontal 是否水平翻转
		 * @param minToMax 是否从往右或从右往左
		 * @coherent 翻滚时从-1到1是否相连
		 */
		public function FlipImage(texture:Texture, horizontal:Boolean=false, minToMax:Boolean=false, coherent:Boolean=false)
		{
			this.horizontal=horizontal;
			this.minToMax=minToMax;
			this.coherent=coherent;
			super(texture);
		}

		private var _location:Number;

		public function get location():Number
		{
			return _location;
		}

		/**
		 * 设置翻转位置系数， -1 到 1
		 * @param value
		 *
		 */
		public function set location(value:Number):void
		{
			if (value > 1)
				value=1;
			else if (value < -1)
				value=-1;
			_location=value;
			var fpl:Number=Math.abs(value);
			var w:Number=width;
			var h:Number=height;
			var topOffset:Number=horizontal ? h / 8 : width / 8;
			if (value >= 0)
			{
				if (horizontal)
				{
					//0 右上角 2 右下角 1 左上角 3 左下角
					if (minToMax)
					{
						mVertexData.setPosition(1, w, 0);
						mVertexData.setPosition(3, w, h);
						mVertexData.setPosition(0, w - w * fpl, -topOffset * (1 - fpl));
						mVertexData.setPosition(2, w - w * fpl, h + topOffset * (1 - fpl));
					}
					else
					{
						mVertexData.setPosition(0, w, 0);
						mVertexData.setPosition(2, w, h);
						mVertexData.setPosition(1, w - w * fpl, -topOffset * (1 - fpl));
						mVertexData.setPosition(3, w - w * fpl, h + topOffset * (1 - fpl));
					}
				}
				else
				{
					//0 右上角 2 右下角 1 左上角 3 左下角
					if (minToMax)
					{
						mVertexData.setPosition(1, 0, h);
						mVertexData.setPosition(0, w, h);
						mVertexData.setPosition(2, w + topOffset * (1 - fpl), h - h * fpl);
						mVertexData.setPosition(3, -topOffset * (1 - fpl), h - h * fpl);
					}
					else
					{
						mVertexData.setPosition(2, 0, h);
						mVertexData.setPosition(3, w, h);
						mVertexData.setPosition(1, w + topOffset * (1 - fpl), h - h * fpl);
						mVertexData.setPosition(0, -topOffset * (1 - fpl), h - h * fpl);
					}
				}
			}
			else
			{
				if (horizontal)
				{
					//0 右上角 2 右下角 1 左上角 3 左下角
					if (minToMax)
					{
						mVertexData.setPosition(0, 0, 0);
						mVertexData.setPosition(2, 0, h);
						mVertexData.setPosition(1, w * fpl, -topOffset * (1 - fpl));
						mVertexData.setPosition(3, w * fpl, h + topOffset * (1 - fpl));
					}
					else
					{
						mVertexData.setPosition(1, w, 0);
						mVertexData.setPosition(3, w, h);
						mVertexData.setPosition(0, w - w * fpl, -topOffset * (1 - fpl));
						mVertexData.setPosition(2, w - w * fpl, h + topOffset * (1 - fpl));
					}
				}
				else
				{
					//0 右上角 2 右下角 1 左上角 3 左下角
					if (minToMax)
					{
//						if (!coherent)
//						{
//						y=-h;
						mVertexData.setPosition(0, w, 0);
						mVertexData.setPosition(1, 0, 0);
						mVertexData.setPosition(2, w + topOffset * (1 - fpl), h * fpl);
						mVertexData.setPosition(3, -topOffset * (1 - fpl), h * fpl);
//						}
//						else
//						{
//							mVertexData.setPosition(0, w, 0);
//							mVertexData.setPosition(1, 0, 0);
//							mVertexData.setPosition(2, w + topOffset * (1 - fpl), -h * (1 - fpl));
//							mVertexData.setPosition(3, -topOffset * (1 - fpl), -h * (1 - fpl));
//						}
					}
					else
					{
						mVertexData.setPosition(2, w, 0);
						mVertexData.setPosition(3, 0, 0);
						mVertexData.setPosition(0, w + topOffset * (1 - fpl), h * fpl);
						mVertexData.setPosition(1, -topOffset * (1 - fpl), h * fpl);
					}
				}
			}
		}

	}
}
