package
{
	import controls.ImageSprite;
	import controls.ListImage;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.ILayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import themes.MetalWorksMobileTheme;
	
	public class Main extends Sprite
	{
		[Embed(source="/../assets/withoutThemes/github.jpg")]
		private const Img:Class;
		
		private var _texture:Texture;
		private var _list:List;

		private var _layout:ILayout;
		
		public function Main()
		{
			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			else
				initialize();
		}
		
		private function initialize(e:Event=null):void
		{
			_texture = Texture.fromBitmap(new Img());
			new MetalWorksMobileTheme();
			
			this.width = stage.stageWidth;
			this.height = stage.stageHeight;
			
			initList();
			_layout = initLayout(0);
			_list.layout = _layout;
			
			_list.width = stage.stageWidth;
			_list.height = stage.stageHeight;
		}
		
		private function initList():void
		{
			var items:Array = [];
			for(var i:int = 0;i<60;i++)
			{
				items.push({texture: _texture});
//				items.push({text: "text_"+i.toString(), thumbnail:_texture});
			}
			
			_list = new List();
			_list.dataProvider = new ListCollection(items);
			_list.itemRendererFactory = listImageFactory;
//			_list.itemRendererFactory = imageSpriteFactory;
			
//			_list.itemRendererFactory = defaultFactory;
//			_list.itemRendererProperties.labelField = "text";
//			_list.itemRendererProperties.iconTextureField = "thumbnail";
			this.addChild( _list );
		}
		
		private function imageSpriteFactory():IListItemRenderer
		{
			var item:ImageSprite = new ImageSprite(_texture);
			return item;
		}
		private function listImageFactory():IListItemRenderer
		{
			var item:ListImage = new ListImage(_texture);
			return item;
		}
		private function defaultFactory():IListItemRenderer
		{
			var item:DefaultListItemRenderer = new DefaultListItemRenderer();
			item.labelField = "text";
			item.iconSourceField = "thumbnail";
			return item;
		}
		
		private function initLayout(i:int):ILayout
		{
			switch(i)
			{
				case 0:
					return RowsLayoutFac();
				case 1:
					return ColumnsLayoutFac();
				default:
					return null;
			}
		}
		
		private function RowsLayoutFac():TiledRowsLayout
		{
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.gap = 20;
			layout.padding = 20;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			return layout;
		}
		
		private function ColumnsLayoutFac():TiledColumnsLayout
		{
			var layout:TiledColumnsLayout = new TiledColumnsLayout();
			layout.gap = 20;
			layout.padding = 20;
			layout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.paging = TiledColumnsLayout.PAGING_HORIZONTAL;
			return layout;
		}
	}
}