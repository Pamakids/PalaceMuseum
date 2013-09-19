package views.global.userCenter.userInfo
{
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 头像组件
	 * @author Administrator
	 */	
	public class HeadIcon extends Sprite
	{
		public static const SECLECTED:String = "head_seclected";
		
		public function HeadIcon(width:Number, height:Number)
		{
			this.width = width;
			this.height = height;
		}
		/**
		 * 组件中所含头像纹理的资源索引
		 */		
		public var id:String;
		
		private var _icon:Image;
		private var _background:Scale9Image;
		
		public function set background(value:Scale9Textures):void
		{
			if(_background && _background.textures == value)
				return;
			if(!_background)
				_background = new Scale9Image(value);
			else
				_background.textures = value;
			_background.width = this.width;
			_background.height = this.height;
		}
		
		public function set icon(texture:Texture):void
		{
			if(_icon && _icon.texture == texture)	return;
			if(!_icon)
			{
				_icon = new Image(texture);
				_icon.width = width;
				_icon.height = height;
				this.addChild( _icon );
			}else
			{
				_icon.texture = texture;
			}
		}
		private var _width:Number;
		override public function set width(value:Number):void
		{
			if(_icon)
				_icon.width = value;
			if(_background)
				_background.width = value;
			this._width = value;
		}
		private var _height:Number;
		override public function set height(value:Number):void
		{
			if(_icon)
				_icon.height = value;
			if(_background)
				_background.height = value;
			this._height = value;
		}
		
		private var _touchable:Boolean = false;
		override public function set touchable(value:Boolean):void
		{
			if(_touchable == value)
				return;
			_touchable = value;
			if(_touchable && !this.hasEventListener(TouchEvent.TOUCH))
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			else if(!_touchable && this.hasEventListener(TouchEvent.TOUCH))
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(this);
			if(t)
			{
				if(t.phase == TouchPhase.ENDED)
					dispatchEventWith(SECLECTED, false, this.id);
			}
		}
		
		override public function dispose():void
		{
			if(_icon)
			{
				this.removeChild( _icon );
				_icon.dispose();
				_icon = null;
			}
			if(_background)
			{
				this.removeChild( _background );
				_background.dispose();
				_background = null;
			}
			if(this.hasEventListener(TouchEvent.TOUCH))
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
			super.dispose();
		}
	}
}