/**
 * Change log
 *
 * 2013-02-03	v1
 * 		initial release
 */

package ldEasyNape
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.ShapeType;

	public dynamic class LDEasyUserData
	{
		public var body:Body;

		private var _fillColor:uint;
		private var _fillAlpha:Number;
		private var _borderThinkness:Number;
		private var _borderColor:uint;

		private var _shape:*;
		private var _graphicType:String;
		private var _graphic:Sprite;

		public function LDEasyUserData()
		{

		}

		public function createGraphic():void
		{
			if (_graphicType != "auto")
				return;
			_graphic=new Sprite();
			var g:Graphics=_graphic.graphics;
			_shape=body.shapes.at(0);
			if (_shape == null)
				return;

			switch (_shape.type)
			{
				case ShapeType.CIRCLE:
				{
					g.lineStyle(_borderThinkness, _borderColor);
					g.beginFill(_fillColor, _fillAlpha);
					g.drawCircle(0, 0, _shape.radius);
					g.endFill();
					break;
				}
				case ShapeType.POLYGON:
				{
					g.lineStyle(_borderThinkness, _borderColor);
					g.beginFill(_fillColor, _fillAlpha);

					var vertix:Vec2=_shape.localVerts.at(0);
					g.moveTo(vertix.x, vertix.y);
					for (var i:int=1; i < _shape.localVerts.length; i++)
					{
						vertix=_shape.localVerts.at(i);
						g.lineTo(vertix.x, vertix.y);
					}
					g.endFill();
					break;
				}
			}
		}

		public function get graphic():Sprite
		{
			if (_graphicType == "")
			{
				return null;
			}
			else
			{
				return _graphic;
			}
		}

		public function setGraphicAuotmatically(fillColor:uint=0x0000FF, fillAlpha:Number=0.5, borderThinkness:Number=1, borderColor:uint=0):void
		{
			_fillColor=fillColor;
			_fillAlpha=fillAlpha;
			_borderColor=borderColor;
			_borderThinkness=borderThinkness;
			_graphicType="auto";
		}

		public function setGraphic(sprite:Sprite):void
		{
			_graphicType="customer";
			_graphic=sprite;
		}

		public function clone():LDEasyUserData
		{
			var ldEUD:LDEasyUserData=new LDEasyUserData();
			if (_graphicType == "auto")
			{
				ldEUD.setGraphicAuotmatically(_fillColor, _fillAlpha, _borderThinkness, _borderColor);
			}
			else
			{
				//ldEUD.setGraphic(_graphic);
			}
			return ldEUD;
		}

	}
}
