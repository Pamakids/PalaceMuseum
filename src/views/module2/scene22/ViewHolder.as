package views.module2.scene22
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;

	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;

	public class ViewHolder extends Sprite
	{
		private var _img1:Image;
//		private var _img2:Image;

//		public function get img2():Image
//		{
//			return _img2;
//		}
//
//		public function set img2(value:Image):void
//		{
//			if (!_img2)
//			{
//				_img2=value;
//				addChild(_img2);
//				_img2.x=_width;
//				this._width+=_img2.width;
//				this.clipRect=new Rectangle(0, 0, _width, _height);
//			}
//		}

		private var _scale:Number=1;
		public var viewPortWidth:Number=0;
		public var viewPortHeight:Number=0;
		public var _width:Number;
		public var _height:Number;

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
				layer1.addChild(_img1);
				this._width=_img1.width;
				this._height=_img1.height;
				this.clipRect=new Rectangle(0, 0, _width, _height);
			}
		}

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
				layer2.addChild(_img2);
				this.clipRect=new Rectangle(0, 0, _width, _height);
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
			layer2.alpha=value/10;
//			if (!this.filter)
//			{
//				blurF=new BlurFilter(value, value);
//				filter=blurF;
//			}
//			else
//				blurF.blurX=blurF.blurY=value;
		}

		public function getBlur():Number
		{
			if(layer2){
				return layer2.alpha*10;
			}else{
				return 0;
			}
//			if (this.filter)
//				return blurF.blurX;
//			else
//				return 0;
		}

		private var layer1:Sprite;
		private var layer2:Sprite;

		private var lion1:Sprite;
		private var lion2:Sprite;

		public function ViewHolder()
		{
			layer1=new Sprite();
			layer2=new Sprite();
			addChild(layer1);
			addChild(layer2);
		}

		private var sit:Image;
		private var stand:Image;

		private var sit2:Image;
		private var stand2:Image;

		public function initLion(img1:Image, img2:Image,img3:Image,img4:Image):void
		{
			sit=img1;
			stand=img2;

			layer1.addChild(sit);
			sit.x=220;
			sit.y=156;

			layer1.addChild(stand);
			stand.x=225;
			stand.y=149;

			sit.visible=false;


			sit2=img3;
			stand2=img4;

			layer2.addChild(sit2);
			sit2.x=sit.x;
			sit2.y=sit.y;

			layer2.addChild(stand2);
			stand2.x=stand.x;
			stand2.y=stand.y;

			sit2.visible=false;
		}

		override public function dispose():void{
			layer1.removeChildren(0,-1,true);
			layer2.removeChildren(0,-1,true);
			super.dispose();
		}

		private var _standUp:Boolean;
		private var ox:Number=-557
		private var oy:Number=0;

		public function get standUp():Boolean
		{
			return _standUp;
		}

		public function set standUp(value:Boolean):void
		{
			_standUp=value;
			var dy1:Number=stand.y - 50;
			var dy2:Number=stand.y;
			if (!value)
			{
				TweenLite.to(stand, .3, {y: dy1, ease: Quad.easeOut, onComplete: function():void {
					TweenLite.to(stand, 2, {y: dy2, ease: Bounce.easeOut, onComplete: function():void {
						sit.visible=!value;
						stand.visible=value;
					}});
				}});

				TweenLite.to(stand2, .3, {y: dy1, ease: Quad.easeOut, onComplete: function():void {
					TweenLite.to(stand2, 2, {y: dy2, ease: Bounce.easeOut, onComplete: function():void {
						sit2.visible=!value;
						stand2.visible=value;
					}});
				}});
			}
		}
	}
}


