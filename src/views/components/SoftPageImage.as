package views.components
{
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	/**
	 * 软页
	 * @author Administrator
	 */	
	public class SoftPageImage extends Sprite
	{
		private var original:Texture;
		private var another:Texture;
		private var bookHeight:Number;
		private var bookWidth:Number;
		public function SoftPageImage(bookWidth:Number, bookHeight:Number)
		{
			this.bookWidth = bookWidth;
			this.bookHeight = bookHeight;
		}
		//旧面两页
		private var cacheImage_0:QuadImage;
		private var cacheImage_1:QuadImage;
		//新面
		private var cacheImage_2:QuadImage;
		
		public function set originalTexture(texture:Texture):void
		{
			if(original && original == texture)
				return;
			original = texture;
			if(!cacheImage_0)
			{
				cacheImage_0 = new QuadImage(original);
				this.addChild(cacheImage_0);
				cacheImage_1 = new QuadImage(original);
				this.addChild(cacheImage_1);
				cacheImage_0.touchable = cacheImage_1.touchable = false;
			}else
			{
				cacheImage_1.texture = original;
				cacheImage_0.texture = original;
			}
		}
		public function set anotherTexture(texture:Texture):void
		{
			if(another && another == texture)
				return;
			another = texture;
			if(!cacheImage_2)
			{
				cacheImage_2 = new QuadImage(another);
				this.addChild(cacheImage_2);
			}else
			{
				cacheImage_2.texture = texture;
			}
		}
		
		//拖动点
		private var _dragPoint:Point = new Point();
		//拖动衍生第四个点
		private var _dragPointCopy:Point = new Point();
		//纸张边缘点：下
		private var _edgePoint:Point = new Point();
		//纸张边缘点：上与右
		private var _edgePointCopy:Point = new Point();
		
		private var currentPointCount:int;
		
		/**重置四个顶点坐标*/
		private function resetAllTexCoords(image:QuadImage):void
		{
			image.vertexData.setTexCoords(0, 0, 0);
			image.vertexData.setTexCoords(1, 1, 0);
			image.vertexData.setTexCoords(2, 0, 1);
			image.vertexData.setTexCoords(3, 1.0, 1.0);
		}
		
		public function readjustSizeHandler(image:QuadImage):void
		{
			image.readjustSize();
			resetAllTexCoords(image);
			image.vertexDataChanged();
		}
		
		private function readjustSize():void
		{
			readjustSizeHandler(cacheImage_0);
			readjustSizeHandler(cacheImage_1);
			readjustSizeHandler(cacheImage_2);
		}
		
		override public function dispose():void
		{
			this.original = null;
			this.another = null;
			if(cacheImage_0)
				cacheImage_0.removeFromParent(true);
			if(cacheImage_1)
				cacheImage_1.removeFromParent(true);
			if(cacheImage_2)
				cacheImage_2.removeFromParent(true);
			super.dispose();
		}
		
		/**
		 * 
		 * @param quadBatch
		 * @param progress	[0-1]	翻页进度（0为开始，至1为完成）
		 * @param leftToRight
		 * 
		 */		
		public function setLocation(progress:Number, pageUp:Boolean):void
		{
			var radius:Number;
			var angle:Number;		//拖拽点相对于圆心的旋转角度
			var degAngle:Number;	//angle对应的弧度值
			var tempAngle:Number	//_edgePointCopy相对于圆心的旋转角度
			var degTemp:Number;
			if(pageUp)
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
			
			readjustSize();
			createView(pageUp);
		}
		
		private function createView(pageUp:Boolean):void
		{
			if(currentPointCount == 3)
				cacheImage_1.visible = true;
			else
				cacheImage_1.visible = false;
			if(pageUp)
			{
				if(currentPointCount == 3)
				{
					cacheImage_0.vertexData.setPosition(0, 0, 0);
					cacheImage_0.vertexData.setTexCoords(0, 0, 0);
					cacheImage_0.vertexData.setPosition(1, bookWidth/2, 0);
					cacheImage_0.vertexData.setTexCoords(1, 1, 0);
					cacheImage_0.vertexData.setPosition(2, 0, _edgePointCopy.y);
					cacheImage_0.vertexData.setTexCoords(2, 0, _edgePointCopy.y/bookHeight);
					cacheImage_0.vertexData.setPosition(3, bookWidth/2, _edgePointCopy.y);
					cacheImage_0.vertexData.setTexCoords(3, 1, _edgePointCopy.y/bookHeight);
					cacheImage_0.vertexDataChanged();
					cacheImage_1.vertexData.setPosition(0, 0, _edgePointCopy.y);
					cacheImage_1.vertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					cacheImage_1.vertexData.setPosition(1, bookWidth/2, _edgePointCopy.y);
					cacheImage_1.vertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					cacheImage_1.vertexData.setPosition(2, _edgePoint.x, bookHeight);
					cacheImage_1.vertexData.setTexCoords(2, _edgePoint.x*2/bookWidth , 1);
					cacheImage_1.vertexData.setPosition(3, bookWidth/2, bookHeight);
					cacheImage_1.vertexDataChanged();
					cacheImage_2.vertexData.setPosition(0, 0, _edgePointCopy.y);
					cacheImage_2.vertexData.setTexCoords(0, 1, _edgePointCopy.y/bookHeight);
					cacheImage_2.vertexData.setPosition(1, _edgePointCopy.x, _edgePointCopy.y);
					cacheImage_2.vertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					cacheImage_2.vertexData.setPosition(2, _edgePoint.x, _edgePoint.y);
					cacheImage_2.vertexData.setTexCoords(2, 1-_edgePoint.x*2/bookWidth, 1);
					cacheImage_2.vertexData.setPosition(3, _dragPoint.x, _dragPoint.y);
					cacheImage_2.vertexDataChanged();
				}else if(currentPointCount == 4)
				{
					cacheImage_0.vertexData.setPosition(0, _edgePointCopy.x, 0);
					cacheImage_0.vertexData.setTexCoords(0, _edgePointCopy.x*2/bookWidth, 0);
					cacheImage_0.vertexData.setPosition(1, bookWidth/2, 0);
					cacheImage_0.vertexData.setPosition(2, _edgePoint.x, bookHeight);
					cacheImage_0.vertexData.setTexCoords(2, _edgePoint.x*2/bookWidth, 1);
					cacheImage_0.vertexData.setPosition(3, bookWidth/2, bookHeight);
					cacheImage_0.vertexDataChanged();
					cacheImage_2.vertexData.setPosition(0, _edgePointCopy.x, 0);
					cacheImage_2.vertexData.setTexCoords(0, 1-_edgePointCopy.x*2/bookWidth, 0);
					cacheImage_2.vertexData.setPosition(1, _dragPointCopy.x, _dragPointCopy.y);
					cacheImage_2.vertexData.setPosition(2, _edgePoint.x, bookHeight);
					cacheImage_2.vertexData.setTexCoords(2, 1-_edgePoint.x*2/bookWidth, 1);
					cacheImage_2.vertexData.setPosition(3, _dragPoint.x, _dragPoint.y);
					cacheImage_2.vertexDataChanged();
				}
			}
			else
			{
				if(currentPointCount == 3)
				{
					cacheImage_0.vertexData.setPosition(0, bookWidth/2, 0);
					cacheImage_0.vertexData.setTexCoords(0, 0, 0);
					cacheImage_0.vertexData.setPosition(1, bookWidth, 0);
					cacheImage_0.vertexData.setTexCoords(1, 1, 0);
					cacheImage_0.vertexData.setPosition(2, bookWidth/2, _edgePointCopy.y);
					cacheImage_0.vertexData.setTexCoords(2, 0, _edgePointCopy.y/bookHeight);
					cacheImage_0.vertexData.setPosition(3, bookWidth, _edgePointCopy.y);
					cacheImage_0.vertexData.setTexCoords(3, 1, _edgePointCopy.y/bookHeight);
					cacheImage_0.vertexDataChanged();
					cacheImage_1.vertexData.setPosition(0, bookWidth/2, _edgePointCopy.y);
					cacheImage_1.vertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					cacheImage_1.vertexData.setPosition(1, bookWidth, _edgePointCopy.y);
					cacheImage_1.vertexData.setTexCoords(1, 1, _edgePointCopy.y/bookHeight);
					cacheImage_1.vertexData.setPosition(2, bookWidth/2, bookHeight);
					cacheImage_1.vertexData.setPosition(3, _edgePoint.x, bookHeight);
					cacheImage_1.vertexData.setTexCoords(3, (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					cacheImage_1.vertexDataChanged();
					cacheImage_2.vertexData.setPosition(0, bookWidth, _edgePointCopy.y);
					cacheImage_2.vertexData.setTexCoords(0, 0, _edgePointCopy.y/bookHeight);
					cacheImage_2.vertexData.setPosition(1, bookWidth, _edgePointCopy.y);
					cacheImage_2.vertexData.setTexCoords(1, 0, _edgePointCopy.y/bookHeight);
					cacheImage_2.vertexData.setPosition(2, _dragPoint.x, _dragPoint.y);
					cacheImage_2.vertexData.setPosition(3, _edgePoint.x, bookHeight);
					cacheImage_2.vertexData.setTexCoords(3, 1 - (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					cacheImage_2.vertexDataChanged();
				}
				else if(currentPointCount == 4)
				{
					cacheImage_0.vertexData.setPosition(0, bookWidth/2, 0);
					cacheImage_0.vertexData.setPosition(1, _edgePointCopy.x, 0);
					cacheImage_0.vertexData.setTexCoords(1, (_edgePointCopy.x - bookWidth/2)*2/bookWidth, 0);
					cacheImage_0.vertexData.setPosition(2, bookWidth/2, bookHeight);
					cacheImage_0.vertexData.setPosition(3, _edgePoint.x, bookHeight);
					cacheImage_0.vertexData.setTexCoords(3, (_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					cacheImage_0.vertexDataChanged();
					cacheImage_2.vertexData.setPosition(0, _dragPointCopy.x, _dragPointCopy.y);
					cacheImage_2.vertexData.setPosition(1, _edgePointCopy.x, 0);
					cacheImage_2.vertexData.setTexCoords(1, 1-(_edgePointCopy.x - bookWidth/2)*2/bookWidth, 0);
					cacheImage_2.vertexData.setPosition(2, _dragPoint.x, _dragPoint.y);
					cacheImage_2.vertexData.setPosition(3, _edgePoint.x, bookHeight);
					cacheImage_2.vertexData.setTexCoords(3, 1-(_edgePoint.x - bookWidth/2)*2/bookWidth, 1);
					cacheImage_2.vertexDataChanged();
				}
			}
		}
	}
}