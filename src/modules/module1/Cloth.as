package modules.module1
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Cloth extends Sprite
	{
		public var type:String;
		public function Cloth()
		{
		}

		private var _img:Image;

		public function get img():Image
		{
			return _img;
		}

		public function set img(value:Image):void
		{
			if(_img&&_img!=value){
				removeChild(_img);
				_img.dispose();
			}
			if(value){
				_img = value;
				addChild(_img);

				pivotX=_img.width>>1;
				pivotY=_img.height>>1;
			}else if(_img){
				removeChild(_img);
				_img.dispose();
			}
		}
//
//		public function copy(_cloth:Cloth):void{
//			type=_cloth.type;
//			img=new Image(_cloth.img.texture);
//		}

		public function distroy():void{
			type="";
			img=null;
			_renderer=null;
		}

		private var _renderer:BoxCellRenderer;

		public function get renderer():BoxCellRenderer
		{
			return _renderer;
		}

		public function set renderer(value:BoxCellRenderer):void
		{
			if(value){
				if(_renderer!=value){
					img=new Image(Image(value.defaultIcon).texture);
					type=value.label;
				}
				_renderer = value;
			}else{
				distroy();
			}

		}

	}
}

