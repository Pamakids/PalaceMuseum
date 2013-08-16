package controls
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.TokenList;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ImageSprite extends Sprite implements IListItemRenderer
	{
		private var _texture:Texture;
		public function set texture(texture:Texture):void
		{
			_texture = texture;
		}
		public function get texture():Texture
		{
			return _texture;
		}
		
		private var _image:Image;
		
		public function ImageSprite(texture:Texture=null)
		{
			if(texture)
				this.texture = texture;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function initialize(e:Event):void
		{
			initImage();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch;
			var touches:Vector.<Touch> = e.getTouches(stage);
			if(touches.length>0)
			{
				touch = touches[0];
				if(touch.phase == TouchPhase.ENDED)
				{
					this.isSelected = !this.isSelected;
				}
			}
		}
		
		private function initImage():void
		{
			this._image = new Image( this._texture );
			this.addChild( _image );
		}
		
		public function get data():Object
		{
			return this._texture;
		}
		public function set data(value:Object):void
		{
			this.texture = value as Texture;
		}
		
		public function get index():int
		{
			return 0;
		}
		
		public function set index(value:int):void
		{
		}
		
		private var _list:List;
		public function get owner():List
		{
			return _list;
		}
		
		public function set owner(value:List):void
		{
			_list = value;
		}
		
		private var _isSelected:Boolean = false;
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function update():void
		{
			trace(_list.selectedIndex);
		}
		
		public function get minWidth():Number
		{
			return 0;
		}
		
		public function set minWidth(value:Number):void
		{
		}
		
		public function get minHeight():Number
		{
			return 0;
		}
		
		public function set minHeight(value:Number):void
		{
		}
		
		public function get maxWidth():Number
		{
			return 0;
		}
		
		public function set maxWidth(value:Number):void
		{
		}
		
		public function get maxHeight():Number
		{
			return 0;
		}
		
		public function set maxHeight(value:Number):void
		{
		}
		
		public function get isEnabled():Boolean
		{
			return false;
		}
		
		public function set isEnabled(value:Boolean):void
		{
		}
		
		public function get isInitialized():Boolean
		{
			return false;
		}
		
		public function get nameList():TokenList
		{
			return null;
		}
		
		public function setSize(width:Number, height:Number):void
		{
		}
		
		public function validate():void
		{
		}
	}
}