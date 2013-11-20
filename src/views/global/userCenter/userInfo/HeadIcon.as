package views.global.userCenter.userInfo
{
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import views.global.userCenter.UserCenterManager;
	
	/**
	 * 头像组件，例：
	 * <listing version="3.0">
	 * 
	 * 		var head:HeadIcon = new HeadIcon("1");
	 * 		head.touchable = true;
	 * 		head.defaultSkin = new Image(texture);
	 * 		head.addEventListener(HeadIcon.SECLECTED, func);
	 * 		this.addChild( head );
	 * 
	 * </listing>
	 * @author Administrator
	 */	
	public class HeadIcon extends Sprite
	{
		/**
		 * @param index	头像资源索引
		 */		
		public function HeadIcon(index:String = null)
		{
			this._index = index;
			init();
		}
		
		private function init():void
		{
			initIcon();
		}
		
		private var _icon:Image;
		private function initIcon():void
		{
			if(_index)
			{
				_icon = UserCenterManager.getImage("icon_userhead_" + _index);
				this.addChild( _icon );
				_icon.x = -_icon.width >> 1;
				_icon.y = -_icon.height >> 1;
			}
		}
		
		private var _index:String;
		private var _background:DisplayObject;
		
		public function set defaultSkin(value:DisplayObject):void
		{
			if(_background && _background == value)
				return;
			if(_background)
			{
				this.removeChild( _background );
				_background.dispose();
			}
			_background = value;
			this.addChild( _background );
			_background.x = -_background.width >> 1;
			_background.y = -_background.height >> 1;
		}
		
		/**
		 * @param index	头像资源索引
		 */		
		public function resetIcon(index:String):void
		{
			if(_index && index && _index == index)
				return;
			_index = index;
			if(!index)
			{
				if(_icon)
					_icon.visible = false;
			}
			else
			{
				if(!_icon)
					initIcon();
				else
					_icon.texture = UserCenterManager.getTexture("icon_userhead_" + _index);
				_icon.visible = true;
			}
		}
		
		/**
		 * 默认值为false.
		 * 设置为true，点击时会派发HeadIcon.SECLECTED事件，并将_index存入作为e.data中
		 */		
		override public function set touchable(value:Boolean):void
		{
			if(this._touchable == value)
				return;
			this._touchable = value;
			if(value && !this.hasEventListener(TouchEvent.TOUCH))
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			else if(!value && this.hasEventListener(TouchEvent.TOUCH))
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		private var _touchable:Boolean =false;
		override public function get touchable():Boolean
		{
			return _touchable;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(this);
			if(t && t.phase == TouchPhase.ENDED)
					dispatchEventWith(Event.TRIGGERED, false, this._index);
		}
		
		override public function dispose():void
		{
			if(_icon)
				_icon.removeFromParent(true);
			if(_background)
				_background.removeFromParent(true);
			if(this.touchable)
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
			super.dispose();
		}
	}
}