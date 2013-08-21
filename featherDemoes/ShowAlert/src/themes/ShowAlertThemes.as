package themes
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.TiledImage;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import screens.MainMenuScreen;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ShowAlertThemes extends DisplayListWatcher
	{
		[Embed(source="/../assets/images/ShowAlert.png")]
		protected static const ATLAS_IMAGE:Class;
		
		[Embed(source="/../assets/images/ShowAlert.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;
		
		[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontName="SourceSansPro",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_REGULAR:Class;
		
		[Embed(source="/../assets/fonts/SourceSansPro-Bold.ttf",fontName="SourceSansProBold",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_BOLD:Class;
		
		[Embed(source="/../assets/fonts/SourceSansPro-BoldIt.ttf",fontName="SourceSansProBoldItalic",fontWeight="bold",fontStyle="italic",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_BOLD_ITALIC:Class;
		
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		
		protected static const HEADER_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 4, 5);
		protected static const SCROLL_BAR_THUMB_REGION1:int = 5;
		protected static const SCROLL_BAR_THUMB_REGION2:int = 14;
		
		protected static const PRIMARY_TEXT_COLOR:uint = 0xe8caa4;
		protected static const DETAIL_TEXT_COLOR:uint = 0x64908a;
		
		protected static function textRendererFactory():ITextRenderer
		{
			const renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
			renderer.embedFonts = true;
			return renderer;
		}
		
		protected static function textEditorFactory():ITextEditor
		{
			return new StageTextTextEditor();
		}
		
		protected static function popUpOverlayFactory():DisplayObject
		{
			const quad:Quad = new Quad(100, 100, 0x1a1a1a);
			quad.alpha = 0.85;
			return quad;
		}
		
		public function ShowAlertThemes(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			if(!container)
			{
				container = Starling.current.stage;
			}
			super(container);
			this._scaleToDPI = scaleToDPI;
			this.initialize();
		}
		
		protected var _originalDPI:int;
		
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		protected var _scaleToDPI:Boolean;
		
		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}
		
		protected var scale:Number = 1;
		
		protected var primaryBackground:TiledImage;
		
		protected var defaultTextFormat:TextFormat;
		protected var selectedTextFormat:TextFormat;
		protected var headerTitleTextFormat:TextFormat;
		protected var stationListNameTextFormat:TextFormat;
		protected var stationListDetailTextFormat:TextFormat;
		
		protected var atlas:TextureAtlas;
		protected var atlasBitmapData:BitmapData;
		protected var mainBackgroundTexture:Texture;
		protected var headerBackgroundTextures:Scale9Textures;
		protected var backIconTexture:Texture;
		protected var verticalScrollBarThumbSkinTextures:Scale3Textures;
		protected var horizontalScrollBarThumbSkinTextures:Scale3Textures;
		protected var alertDefaultBackgroundTextrue:Scale9Textures;
		
		
		override public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
				if(this.primaryBackground)
				{
					this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
					this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
					this.root.removeChild(this.primaryBackground, true);
					this.primaryBackground = null;
				}
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
			}
			if(this.atlasBitmapData)
			{
				this.atlasBitmapData.dispose();
				this.atlasBitmapData = null;
			}
			super.dispose();
		}
		
		protected function initializeRoot():void
		{
			this.primaryBackground = new TiledImage(this.mainBackgroundTexture);
			this.primaryBackground.width = root.stage.stageWidth;
			this.primaryBackground.height = root.stage.stageHeight;
			this.root.addChildAt(this.primaryBackground, 0);
			this.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		}
		
		protected function initialize():void
		{
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			
			this.scale = scaledDPI / this._originalDPI;
			
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
			
			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
				Callout.stagePaddingLeft = 16 * this.scale;
			
			//主题基础资源
			const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
			this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));
			
			if(Starling.handleLostContext)
			{
				this.atlasBitmapData = atlasBitmapData;
			}
			else
			{
				atlasBitmapData.dispose();
			}
			
			this.mainBackgroundTexture = this.atlas.getTexture("screen_background");
			this.headerBackgroundTextures = new Scale9Textures(this.atlas.getTexture("screen_background"), HEADER_SCALE9_GRID);
			this.alertDefaultBackgroundTextrue = new Scale9Textures( this.atlas.getTexture("screen_background"), HEADER_SCALE9_GRID);
			this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("screen_background"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
			this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("screen_background"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);
//			this.stationListNormalIconTexture = this.atlas.getTexture("station-list-normal-icon");
//			this.stationListFirstNormalIconTexture = this.atlas.getTexture("station-list-first-normal-icon");
//			this.stationListLastNormalIconTexture = this.atlas.getTexture("station-list-last-normal-icon");
//			this.stationListSelectedIconTexture = this.atlas.getTexture("station-list-selected-icon");
//			this.stationListFirstSelectedIconTexture = this.atlas.getTexture("station-list-first-selected-icon");
//			this.stationListLastSelectedIconTexture = this.atlas.getTexture("station-list-last-selected-icon");
//			this.confirmIconTexture = this.atlas.getTexture("confirm-icon");
//			this.cancelIconTexture = this.atlas.getTexture("cancel-icon");
//			this.backIconTexture = this.atlas.getTexture("back-icon");
			
			//we need to use different font names because Flash runtimes seem to
			//have a bug where setting defaultTextFormat on a TextField with a
			//different TextFormat that has the same font name as the existing
			//defaultTextFormat value causes the new TextFormat to be ignored,
			//even if the new TextFormat has different bold or italic values.
			//wtf, right?
			const regularFontName:String = "SourceSansPro";
			const boldFontName:String = "SourceSansProBold";
			const boldItalicFontName:String = "SourceSansProBoldItalic";
			this.defaultTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
			this.selectedTextFormat = new TextFormat(boldFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR, true);
			this.headerTitleTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
			this.stationListNameTextFormat = new TextFormat(boldItalicFontName, Math.round(48 * this.scale), PRIMARY_TEXT_COLOR, true, true);
			this.stationListDetailTextFormat = new TextFormat(boldFontName, Math.round(24 * this.scale), DETAIL_TEXT_COLOR, true);
			this.stationListDetailTextFormat.letterSpacing = 6 * this.scale;
			
			if(this.root.stage)
			{
				this.initializeRoot();
			}
			else
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			
			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(Header, headerInitializer);
			this.setInitializerForClass(Button, mainMenuShowInitializer, MainMenuScreen.DEFAULT_NAME_SHOW_BUTTON)
			this.setInitializerForClass(Button, mainMenuHideInitializer, MainMenuScreen.DEFAULT_NAME_HIDE_BUTTON)
		}
		
		protected function imageLoaderFactory():ImageLoader
		{
			const image:ImageLoader = new ImageLoader();
			image.textureScale = this.scale;
			return image;
		}
		
		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			const defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.width = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * this.scale;
			return scrollBar;
		}
		
		protected function verticalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			const defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
			defaultSkin.height = 10 * this.scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * this.scale;
			return scrollBar;
		}
		
		protected function nothingInitializer(target:DisplayObject):void {}
		
		protected function screenInitializer(screen:Screen):void
		{
			screen.originalDPI = this._originalDPI;
		}
		
		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.defaultTextFormat;
		}
		
		protected function buttonInitializer(button:Button):void
		{
			const defaultIcon:ImageLoader = new ImageLoader();
			defaultIcon.source = this.backIconTexture;
			defaultIcon.textureScale = this.scale;
			defaultIcon.snapToPixels = true;
			button.defaultIcon = defaultIcon;
			button.minWidth = button.minHeight = 44 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}
		
		protected function mainMenuShowInitializer(button:Button):void
		{
			
		}
		protected function mainMenuHideInitializer(button:Button):void
		{
			
		}
		
		protected function headerInitializer(header:Header):void
		{
//			header.minWidth = 88 * this.scale;
//			header.minHeight = 88 * this.scale;
//			header.paddingTop = header.paddingRight = header.paddingBottom =
//				header.paddingLeft = 14 * this.scale;
//			header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;
//			
//			const backgroundSkin:Scale9Image = new Scale9Image(this.headerBackgroundTextures, this.scale);
//			header.backgroundSkin = backgroundSkin;
//			header.titleProperties.textFormat = this.headerTitleTextFormat;
		}
		
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.primaryBackground.width = event.width;
			this.primaryBackground.height = event.height;
		}
		
		protected function root_addedToStageHandler(event:Event):void
		{
			this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			this.initializeRoot();
		}
		
		protected function root_removedFromStageHandler(event:Event):void
		{
			this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
			this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.removeChild(this.primaryBackground, true);
			this.primaryBackground = null;
		}
	}
}


