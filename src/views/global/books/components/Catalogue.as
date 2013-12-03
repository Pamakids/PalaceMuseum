package views.global.books.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.ProgressBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
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
			parseJson();
			initBG();
			initScroll();
			initProbar();
			initHeaders();
			initList();
			addToView(0);
		}
		
		private var probar:ProgressBar;
		private function initProbar():void
		{
			probar = new ProgressBar();
			probar.maximum = 100;
			probar.minimum = 0;
			probar.backgroundSkin = BooksManager.getImage("progress_bg");
			probar.fillSkin = BooksManager.getImage("progress_image");
			this.addChild( probar );
			probar.direction = ProgressBar.DIRECTION_VERTICAL;
			probar.x = 590;
			probar.y = 72;
			probar.touchable = false;
		}
		
		private var moving:Boolean  = false;
		private function addToView(index:int):void
		{
			if(index == crtIndex || moving)
				return;
			moving = true;
			if(crtIndex == -1)		//初始化
			{
				crtIndex = index;
				updateView();
			}else
			{
				crtIndex = index;
				delFromView();
			}
		}
		private function delFromView():void
		{
			var list:List;
			for(var i:int = 0;i<vecList.length;i++)
			{
				list = vecList[i];
				if(list.parent)
				{
					TweenLite.to(list, 0.5, {height: 0, alpha: 0, ease: Cubic.easeOut, onComplete: function():void{
						list.removeFromParent();
						updateView();
					}});
					break;
				}
			}
		}
		
		private function updateView():void
		{
			var list:List = vecList[crtIndex];
			list = vecList[crtIndex];
			list.height = 0;
			list.alpha = 0;
			scroll.addChildAt(list, crtIndex+1);
			TweenLite.delayedCall(0.05, function():void{
				TweenLite.to(list, 0.5, {height: list.maxVerticalScrollPosition, alpha: 1, ease: Cubic.easeIn, onComplete: function():void{
					moving = false;
				}});
			});
		}
		
		private var datas:Array;
		private function parseJson():void
		{
			datas = [];
			var data:Array;
			var obj:Object;
			var arr:Array;
			var source:Array = BooksManager.getAssetsManager().getObject("catalogue") as Array;
			for(var i:int = 0;i<source.length;i++)
			{
				data = source[i].items;
				arr = [];
				arr.name = source[i].name;
				for(var j:int = 0;j<data.length;j++)
				{
					obj = {
						text:	data[j].explain, 
						icon: 	BooksManager.getTexture("label_"+data[j].type),
						screen: data[j].type,
						page:	data[j].page
					};
					arr.push( obj );
				}
				datas.push( arr );
			}
		}
		
		private var vecHeader:Vector.<HeaderForCatalogue>;
		private function initHeaders():void
		{
			vecHeader = new Vector.<HeaderForCatalogue>();
			var header:HeaderForCatalogue;
			for(var i:int = 0;i<datas.length;i++)
			{
				header = new HeaderForCatalogue();
				header.label = datas[i].name;
				scroll.addChild( header );
				header.addEventListener(Event.TRIGGERED, onTriggered);
				vecHeader.push( header );
				
				if(i==0)	header.setSelected(true);
			}
		}
		
		private function onTriggered(e:Event):void
		{
			var index:int = vecHeader.indexOf( e.currentTarget as HeaderForCatalogue );
			var head:HeaderForCatalogue;
			for(var i:int = 0;i<vecHeader.length;i++)
			{
				head = vecHeader[i];
				head.setSelected(index == i);
			}
			addToView(index);
		}
		
		private var scroll:ScrollContainer;
		private var layoutForScroll:VerticalLayout;
		private function initScroll():void
		{
			layoutForScroll = new VerticalLayout();
			layoutForScroll.gap = 10;
			layoutForScroll.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT
			scroll = new ScrollContainer();
			this.addChild( scroll );
			scroll.x = 40;
			scroll.y = 70;
			scroll.width = 540;
			scroll.height = 530;
			scroll.layout = layoutForScroll;
			scroll.addEventListener(Event.SCROLL, onScroll);
		}
		
		private function onScroll():void
		{
			var i:int = 100*scroll.verticalScrollPosition/scroll.maxVerticalScrollPosition;
			i = Math.min( 100, Math.max( 0, i ) );
			probar.value = i;
		}
		
		private var crtIndex:int = -1;
		
		private var vecList:Vector.<List>;
		private function initList():void
		{
			vecList = new Vector.<List>(datas.length);
			for(var i:int = 0;i<datas.length;i++)
			{
				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
				layout.paddingLeft = 50;
				layout.gap = 10;
				
				var data:Array = datas[i];
				var list:List = new List();
				list.dataProvider = new ListCollection(data);
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.labelFactory = function():ITextRenderer{
						var render:TextFieldTextRenderer = new TextFieldTextRenderer();
						render.embedFonts = true;
						render.textFormat = new TextFormat(FontVo.PALACE_FONT, 24, 0x333333);
						return render;
					};
					renderer.iconSourceField = "icon";
					renderer.labelField = "text";
					return renderer;
				};
				list.layout = layout;
				list.addEventListener(Event.CHANGE, onChanged);
				vecList[i] = list;
			}
		}
		
		private function onChanged(e:Event):void
		{
			var list:List = vecList[crtIndex];
			var obj:Object = list.dataProvider.data[list.selectedIndex];
			dispatchEventWith(Event.CHANGE, false, [obj.screen, obj.page]);
		}
		
		private function initBG():void
		{
			var image:Image = BooksManager.getImage("catalogue_bg");
			this.addChild( image );
			image.touchable = false;
		}
	}
}