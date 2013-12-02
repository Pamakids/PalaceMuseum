package views.module2.scene22
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;

	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;

	public class ViewHolder extends Sprite
	{
		private var _img1:Image;
		private var _img2:Image;

		public function get img2():Image
		{
			return _img2;
		}

		public function set img2(value:Image):void
		{
			if (!_img2)
			{
				_img2=value;
				addChild(_img2);
				_img2.x=_width;
				this._width+=_img2.width;
				this.clipRect=new Rectangle(0, 0, _width, _height);
			}
		}

		private var _scale:Number=1;
		public var viewPortWidth:Number=0;
		public var viewPortHeight:Number=0;
		public var _width:Number;
		public var _height:Number;

		private var blurF:BlurFilter;

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{

			if (value < viewPortHeight / _height)
				value=viewPortHeight / _height;
			_scale=value;
			this.scaleX=this.scaleY=_scale;
			pivotX=pivotX;
			pivotY=pivotY;
		}

		public function get img1():Image
		{
			return _img1;
		}

		public function set img1(value:Image):void
		{
			if (!_img1)
			{
				_img1=value;
				addChild(_img1);
				this._width=_img1.width;
				this._height=_img1.height;
			}
		}

		override public function set pivotX(value:Number):void
		{
			value=Math.max(viewPortWidth / scale / 2, Math.min(_width - viewPortWidth / scale / 2, value));

			if (pivotX != value)
				super.pivotX=value;

			var vw:Number=viewPortWidth / _scale;
			clipRect.x=pivotX - vw / 2;
			clipRect.width=vw;
		}

		override public function set pivotY(value:Number):void
		{
			value=Math.max(viewPortHeight / scale / 2, Math.min(_height - viewPortHeight / scale / 2, value));

			if (pivotY != value)
				super.pivotY=value;

			var vh:Number=viewPortHeight / _scale;
			clipRect.y=pivotY - vh / 2;
			clipRect.height=vh;
		}

		public function blur(value:Number):void
		{
//			trace(value)
			value=Math.max(0, Math.min(value, 10))
			if (!this.filter)
			{
				blurF=new BlurFilter(value, value);
				filter=blurF;
			}
			else
				blurF.blurX=blurF.blurY=value;
		}

		public function getBlur():Number
		{
			if (this.filter)
				return blurF.blurX;
			else
				return 0;
		}

		public function ViewHolder()
		{
		}

		private var sit:Image;
		private var stand:Image;

		public function initLion(img1:Image, img2:Image):void
		{
			sit=img1;
			stand=img2;

			addChild(sit);
			sit.x=1211;
			sit.y=214;

			addChild(stand);
			stand.x=1222;
			stand.y=208;

			sit.visible=stand.touchable=false;
		}

		private var _standUp:Boolean;

		public function get standUp():Boolean
		{
			return _standUp;
		}

		public function set standUp(value:Boolean):void
		{
			_standUp=value;
			var dy1:Number=stand.y - 100;
			var dy2:Number=stand.y;
			if (!value)
			{
				TweenLite.to(stand, .5, {y: dy1, ease: Quad.easeOut, onComplete: function():void {
					TweenLite.to(stand, 2.5, {y: dy2, ease: Bounce.easeOut, onComplete: function():void {
						sit.visible=sit.touchable=!value;
						stand.visible=stand.touchable=value;
					}});
				}});
			}
		}
	}
}
