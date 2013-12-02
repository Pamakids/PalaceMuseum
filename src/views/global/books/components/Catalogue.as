package views.global.books.components
{
	import flash.text.TextFormat;
	
	import feathers.controls.GroupedList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.HierarchicalCollection;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import views.global.books.BooksManager;

	/**
	 * 目录
	 * @author Administrator
	 */	
	public class Catalogue extends Sprite
	{
		public function Catalogue()
		{
			init();
		}
		
		private function init():void
		{
			initGroup();
//			var c:ScrollContainer = new ScrollContainer();
//			c.setSize(960, 640);
//			this.addChild( c );
//			
//			var image:Image;
//			for(var i:int = 0;i<20;i++)
//			{
//				image = BooksManager.getImage("achievement_card_finish");
//				c.addChild( image );
//				image.x = 150;
//				image.y = i*(10+image.height);
//			}
		}
		
		private var list:GroupedList;
		private function initGroup():void
		{
			list = new GroupedList();
			list.dataProvider = new HierarchicalCollection(
				[
					{
						header: "晨起",
						children:
						[
							{ text: "Milk", thumbnail: BooksManager.getTexture("achievement_card_finish") },
							{ text: "Cheese", thumbnail: BooksManager.getTexture( "achievement_card_finish" ) },
						]
					},
					{
						header: "Bakery",
						children:
						[
							{ text: "Bread", thumbnail: BooksManager.getTexture( "achievement_card_finish" ) },
						]
					},
					{
						header: "Produce",
						children:
						[
							{ text: "Bananas", thumbnail: BooksManager.getTexture( "achievement_card_finish" ) },
							{ text: "Lettuce", thumbnail: BooksManager.getTexture( "achievement_card_finish" ) },
							{ text: "Onion", thumbnail: BooksManager.getTexture( "achievement_card_finish" ) },
						]
					},
				]);
			list.itemRendererFactory = function():IGroupedListItemRenderer
			{
				var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				renderer.labelField = "text";
				renderer.labelFactory = function():ITextRenderer{
					var render:TextFieldTextRenderer = new TextFieldTextRenderer();
					render.textFormat = new TextFormat(FontVo.PALACE_FONT, 24, 0x333333);
					return render;
				}
				renderer.iconSourceField = "thumbnail";
				return renderer;
			};
//			list.headerRendererProperties(
			list.backgroundSkin = BooksManager.getImage("background_win_1");
			list.width = 480;
			list.height = 422;
			list.addEventListener( Event.CHANGE, list_changeHandler );
			this.addChild( list );
		}
		
		private function list_changeHandler(e:Event):void
		{
		}
	}
}