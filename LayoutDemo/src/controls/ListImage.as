package controls
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ListImage extends FeathersControl implements IListItemRenderer
	{
		private var _image:Image;
		private var _texture:Texture;
		public function ListImage(value:Texture)
		{
			this._texture = value;
		}
		
		public function get data():Object
		{
			return _texture;
		}
		
		public function set data(value:Object):void
		{
			if(!(value is Texture))
				return;
			if(this._texture == value)
				return;
			this._texture = value as Texture;
			if(!this._image)
			{
				this._image = new Image(_texture);
			}else
				this._image.texture = value as Texture;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _index:int = -1;
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _owner:List;
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _isSelected:Boolean;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override protected function draw():void
		{
			this.width = _image.width;
			this.height = _image.height;
			this.pivotX = this.pivotY = 0;
		}
		
		override protected function initialize():void
		{
			if(!this._image)
			{
				this._image = new Image(_texture);
				this.addChild(_image);
			}
		}
		
	}
}