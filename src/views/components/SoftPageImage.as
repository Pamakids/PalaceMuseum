package views.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	/**
	 * 软页
	 * @author Administrator
	 */	
	public class SoftPageImage extends Image
	{
		//确定书打开后的高度及宽度
		private var bookWidth:Number = 800;
		private var bookHeight:Number = 480;
		
//		private var LEFT_UP_POINT:Point;
//		private var LEFT_BOTTOM_POINT:Point;
//		private var RIGHT_UP_POINT:Point;
//		private var RIGHT_BOTTOM_POINT:Point;
//		private var MID_UP_POINT:Point;
//		private var MID_BOTTOM_POINT:Point;
		
		//拖动点
		private var _dragPoint:Point = new Point();
		//拖动衍生第四个点
		private var _dragPointCopy:Point = new Point();
		//纸张边缘点：下
		private var _edgePoint:Point = new Point();
		//纸张边缘点：上与右
		private var _edgePointCopy:Point = new Point();
		
		private var currentPointCount:int;
		
		/**
		 * @param texture
		 */		
		public function SoftPageImage(texture:Texture, bookWidth, bookHeight)
		{
			super(texture);
			this.bookWidth = bookWidth;
			this.bookHeight = bookHeight;
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
		
		
		/**
		 * 
		 * @param quadBatch
		 * @param progress	[0-1]	翻页进度（0为开始，至1为完成）
		 * @param leftToRight
		 * 
		 */		
		public function setLocation(render:RenderTexture, progress:Number, leftToRight:Boolean):void
		{
			var radius:Number;
			var angle:Number;		//拖拽点相对于圆心的旋转角度
			var degAngle:Number;	//angle对应的弧度值
			var tempAngle:Number	//_edgePointCopy相对于圆心的旋转角度
			var degTemp:Number;
			if(leftToRight)
			{
				angle = -180 + progress*180;
				degAngle = deg2rad( angle );
				tempAngle = -180 + progress*90;
				degTemp = deg2rad( tempAngle );
				radius = bookWidth * progress / 2;
				
				_edgePoint.x = radius;
				_edgePoint.y = bookHeight;
				_dragPoint.x = _edgePoint.x + radius * Math.cos( degAngle );
				_dragPoint.y = _edgePoint.y + radius * Math.sin( degAngle );
				
				_edgePointCopy.y = radius * Math.tan( -degTemp ) + _edgePoint.y;
				if(_edgePointCopy.y < 0)		//有四个有效点
				{
					currentPointCount = 4;
					var d:Number;
					d = -_edgePointCopy.y;
					_edgePointCopy.x = radius * d / (d + bookHeight);
					_edgePointCopy.y = 0;
					_dragPointCopy.x = _edgePointCopy.x + _edgePointCopy.x * Math.cos( degAngle );
					_dragPointCopy.y = _edgePointCopy.y + _edgePointCopy.x * Math.sin( degAngle );
				}
				else
				{
					currentPointCount = 3;
					_edgePointCopy.x = 0;
					_dragPointCopy.x = _dragPointCopy.y = 0;
				}
			}
			else
			{
				angle = 0 - progress * 180;
				degAngle = deg2rad( angle );
				tempAngle = 0 - progress*90;
				degTemp = deg2rad( tempAngle );
				radius = bookWidth * progress / 2;
				
				_edgePoint.x = bookWidth - radius;
				_edgePoint.y = bookHeight;
				
				_dragPoint.x = _edgePoint.x + radius * Math.cos( degAngle );
				_dragPoint.y = _edgePoint.y + radius * Math.sin( degAngle );
				
				_edgePointCopy.y = _edgePoint.y + radius * Math.tan( degTemp );
				if(_edgePointCopy.y < 0)
				{
					currentPointCount = 4;
					d = -_edgePointCopy.y;
					_edgePointCopy.x = bookWidth - radius * d / (d + bookHeight);
					_edgePointCopy.y = 0;
					_dragPointCopy.x = _edgePointCopy.x + (bookWidth - _edgePointCopy.x) * Math.cos( degAngle );
					_dragPointCopy.y = _edgePointCopy.y + (bookWidth - _edgePointCopy.x) * Math.sin( degAngle );
				}
				else
				{
					currentPointCount = 3;
					
					_edgePointCopy.x = bookWidth;
					_dragPointCopy.x = bookWidth;
					_dragPointCopy.y = 0;
				}
			}
			
			createView(render, leftToRight);
		}
		
		private function createView(render:RenderTexture, leftToRight:Boolean):void
		{
			if(leftToRight)
			{
				if(currentPointCount == 3)
				{
					mVertexData.setPosition(0, 0, 0);
					mVertexData.setPosition(1, bookWidth/2, 0);
					mVertexData.setPosition(2, 0, _edgePointCopy.y);
					mVertexData.setTexCoords(2, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(3, bookWidth/2, _edgePointCopy.y);
					mVertexData.setTexCoords(3, 1, _edgePointCopy.y/bookHeight);
					render.draw( this );
					readjustSize();
					mVertexData.setPosition(0, 0, _edgePointCopy.y);
					mVertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(1, bookWidth/2, _edgePointCopy.y);
					mVertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(2, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(2, _edgePoint.x*2/bookWidth , 1);
					mVertexData.setPosition(3, bookWidth/2, bookHeight);
					render.draw( this );
					readjustSize();
					texture = anotherTexture;
					mVertexData.setPosition(0, 0, _edgePointCopy.y);
					mVertexData.setTexCoords(0, 1, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(1, _edgePointCopy.x, _edgePointCopy.y);
					mVertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(2, _edgePoint.x, _edgePoint.y);
					mVertexData.setTexCoords(2, 1-_edgePoint.x*2/bookWidth, 1);
					mVertexData.setPosition(3, _dragPoint.x, _dragPoint.y);
					render.draw( this );
				}else if(currentPointCount == 4)
				{
					mVertexData.setPosition(0, _edgePointCopy.x, 0);
					mVertexData.setTexCoords(0, _edgePointCopy.x*2/bookWidth, 0);
					mVertexData.setPosition(1, bookWidth/2, 0);
					mVertexData.setPosition(2, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(2, _edgePoint.x*2/bookWidth, 1);
					mVertexData.setPosition(3, bookWidth/2, bookHeight);
					render.draw( this );
					readjustSize();
					texture = anotherTexture;
					mVertexData.setPosition(0, _edgePointCopy.x, 0);
					mVertexData.setTexCoords(0, 1-_edgePointCopy.x*2/bookWidth, 0);
					mVertexData.setPosition(1, _dragPointCopy.x, _dragPointCopy.y);
					mVertexData.setPosition(2, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(2, 1-_edgePoint.x*2/bookWidth, 1);
					mVertexData.setPosition(3, _dragPoint.x, _dragPoint.y);
					render.draw( this );
				}
			}
			else
			{
				if(currentPointCount == 3)
				{
					mVertexData.setPosition(0, bookWidth/2, 0);
					mVertexData.setPosition(1, bookWidth, 0);
					mVertexData.setPosition(2, bookWidth/2, _edgePointCopy.y);
					mVertexData.setTexCoords(2, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(3, bookWidth, _edgePointCopy.y);
					mVertexData.setTexCoords(3, 1, _edgePointCopy.y/bookHeight);
					render.draw( this );
					readjustSize();
					mVertexData.setPosition(0, bookWidth/2, _edgePointCopy.y);
					mVertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(1, bookWidth, _edgePointCopy.y);
					mVertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(2, bookWidth/2, bookHeight);
					mVertexData.setPosition(3, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(3, (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					render.draw( this );
					readjustSize();
					texture = anotherTexture;
					mVertexData.setPosition(0, bookWidth, _edgePointCopy.y);
					mVertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(1, bookWidth, _edgePointCopy.y);
					mVertexData.setTexCoords(1, 0, _edgePointCopy.y/bookHeight);
					mVertexData.setPosition(2, _dragPoint.x, _dragPoint.y);
					mVertexData.setPosition(3, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(3, 1 - (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					render.draw( this );
				}
				else if(currentPointCount == 4)
				{
					mVertexData.setPosition(0, bookWidth/2, 0);
					mVertexData.setPosition(1, _edgePointCopy.x, 0);
					mVertexData.setTexCoords(1, (_edgePointCopy.x - bookWidth/2)*2/bookWidth, 0);
					mVertexData.setPosition(2, bookWidth/2, bookHeight);
					mVertexData.setPosition(3, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(3, (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					render.draw( this );
					readjustSize();
					texture = anotherTexture;
					mVertexData.setPosition(0, _dragPointCopy.x, _dragPointCopy.y);
					mVertexData.setPosition(1, _edgePointCopy.x, 0);
					mVertexData.setTexCoords(1, 1-(_edgePointCopy.x - bookWidth/2)*2/bookWidth, 0);
					mVertexData.setPosition(2, _dragPoint.x, _dragPoint.y);
					mVertexData.setPosition(3, _edgePoint.x, bookHeight);
					mVertexData.setTexCoords(3, 1-(_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					render.draw( this );
				}
			}
			
		}
		
		private function createNewImage():void
		{
		}
		
		private var angle:Number;
	}
}