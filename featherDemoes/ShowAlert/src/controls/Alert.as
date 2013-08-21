package controls
{
<<<<<<< HEAD
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Alert extends FeathersControl
	{
		/*
		 * change flag
		 */		
		private static const INVALIDATION_FLAG_DEFAULT_SKIN:String = "default_skin";
		private static const INVALIDATION_FLAG_CONTENT_SKIN:String = "content_skin";
		private static const INVALIDATION_FLAG_TYPE:String = "flag_type";
		private static const INVALIDATION_FLAG_TEXT:String = "flag_text";
		/*
		 * for themes
		 */		
		public static const DEFAULT_CHILD_NAME_BUTTONGROUP:String = "feathers-button-alert-button";
		public static const DEFAULT_CHILD_NAME_LABEL:String = "feathers-label-alert-label";
		public static const DEFAULT_CHILD_GROUP_BUTTON:String = "feathers-button-alert-buttonGroup";
=======
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class Alert extends FeathersControl
	{
		public static const INVALIDATION_FLAG_TITLE_CHANGED:String = "alert_title_changed";
		/*
		 * for themes
		 */		
		public static const DEFAULT_CHILD_NAME_BUTTONGROUP:String = "feathers-alert-buttonGroup";
		public static const DEFAULT_CHILD_TITLE_LABEL:String = "feathers-label-alert-title-label";
		public static const DEFAULT_CHILD_CONTENT_LABEL:String = "feathers-label-alert-content-label";
>>>>>>> temp
		/*
		 * type
		 */		
		public static const OK:String = "ok";
		public static const OK_CANCLE:String = "ok_cancle";
		
		/**
		 * @param view_		显示内容，可以是String，Texture，或FeathersControl
		 * @param type_		"ok"/"ok_cancle"
		 * @param returnFunctionArr_	按钮回调函数数组[okFunc, cancleFunc]
		 * @param returnDataArr_		参数[okParam, cancleParam]
		 */	
		/*public function Alert(view_:Object,type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null)
		{
			super();
			this._viewData = view_;
			this._type = type_;
			this._callBackFuncs = returnFunctionArr_;
			this._callBackParams = returnDataArr_;
		}*/
		/*public function Alert(content_:String,type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null)
		{
			super();
			this._viewData = content_;
			this._type = type_;
			this._callBackFuncs = returnFunctionArr_;
			this._callBackParams = returnDataArr_;
		}*/
<<<<<<< HEAD
		private static var _instance:Alert;
		
=======
		
		
		private static var _instance:Alert;
>>>>>>> temp
		public static function getInstance():Alert
		{
			if(!_instance)	_instance = new Alert();
			return _instance;
		}
		
<<<<<<< HEAD
//		public static function ShowAlert(viewData_:String,type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null):void
//		{
//			getInstance.viewData = viewData_;
//			getInstance.type = type_;
//			getInstance._callBackFuncs = returnFunctionArr_;
//			getInstance._callBackParams = returnDataArr_;
//		}
		
		public function showAlert(viewData_:String,type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null):void
		{
			this.viewData = viewData_;
=======
		/**
		 * @param content_		显示内容
		 * @param content_		标题（默认值为无标题栏）
		 * @param type_			"ok"/"ok_cancle"
		 * @param returnFunctionArr_	按钮回调函数数组[okFunc, cancleFunc]
		 * @param returnDataArr_		参数[okParam, cancleParam]
		 */
		public function showAlert(content_:String,title_:String="",type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null):void
		{
			this.content = content_;
			this.title = title_;
>>>>>>> temp
			this.type = type_;
			this._callBackFuncs = returnFunctionArr_;
			this._callBackParams = returnDataArr_;
		}
		
		public function close():void
		{
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		/**
		 * Alert.getInstance();
		 */		
<<<<<<< HEAD
		public function Alert()
		{
			super();
		}
		
		
		private var _type:String;
=======
		public function Alert(){	super();		}
		
		/*Data*/
		private var _type:String = "ok";
>>>>>>> temp
		private function set type(value:String):void
		{
			if(_type == value)
				return;
			_type = value;
<<<<<<< HEAD
			invalidate( INVALIDATION_FLAG_TYPE );
			invalidate( INVALIDATION_FLAG_STYLES );
=======
			invalidate(INVALIDATION_FLAG_DATA);
>>>>>>> temp
		}
		private function get type():String
		{
			return _type;
		}
<<<<<<< HEAD
//		private var _viewData:Object;
		private var _viewData:String;
		private function set viewData(value:String):void
		{
			if(_viewData == value)
				return;
			_viewData = value;
			invalidate( INVALIDATION_FLAG_TEXT );
			invalidate( INVALIDATION_FLAG_STYLES );
		}
		private function get viewData():String
		{
			return _viewData;
		}
		private var _callBackFuncs:Array;
		private var _callBackParams:Array;
		
//		private var _view:DisplayObject;
		private var _label:Label;
		private function initView():void
		{
			/*if(_viewData is String)
			{
				_view = new Label;
				(_view as Label).text = String(_viewData);
				(_view as Label).textRendererProperties.textFormat = new TextFormat( "Arial", 24, 0x323232 );
				(_view as Label).textRendererProperties.embedFonts = true;
				(_view as Label).textRendererProperties.wordWrap = true;
			}else if(_viewData is Texture)
			{
				_view = new Image(_viewData as Texture);
			}else if(_viewData is FeathersControl)
			{
				var reanderTexture:RenderTexture = new RenderTexture(_viewData.width, _viewData.height);
				reanderTexture.draw(_viewData as DisplayObject);
				_view = new Image(reanderTexture);
			}
			_viewData = null;
			_view.touchable = false;
			this._viewContainer.addChild(_view);*/
			_label = new Label();
			_label.nameList.add(DEFAULT_CHILD_NAME_LABEL);
			this._labelContainer.addChild(_label);
		}
		
		/**
		 * 显示对象容器，包含一张内同背景以及显示内容
		 */		
		private var _labelContainer:FeathersControl;
		
		override protected function initialize():void
		{
			initBackGroundView();
			initViewContainer();
			initContentSkin();
			initView();
			initButtonGroup();
		}
		
		private function initBackGroundView():void
		{
			this._defaultImageLoader = new ImageLoader();
			this._defaultImageLoader.maxWidth = this.maxWidth;
			this._defaultImageLoader.maxHeight = this.maxHeight;
			this.addChild(_defaultImageLoader);
		}
		
		private function initContentSkin():void
		{
			this._contentImageLoader = new ImageLoader();
			this._contentImageLoader.maxWidth = this.maxWidth - this._padding*2;
			this._labelContainer.addChild( this._contentImageLoader );
		}
		
		private function initViewContainer():void
		{
			_labelContainer = new FeathersControl();
			_labelContainer.maxWidth = this.maxHeight - this.padding*2;
			addChild(_labelContainer);
=======
		
		private var _content:String = "";
		public function set content(value:String):void
		{
			if(_content == value)
				return;
			_content = value;
			invalidate(INVALIDATION_FLAG_STYLES);
			invalidate(INVALIDATION_FLAG_DATA);
		}
		public function get content():String
		{
			return _content;
		}
		private var _titleVisble:Boolean;
		private function set titleVisble(value:Boolean):void
		{
			if(_titleVisble == value)	return;
			_titleVisble = value;
			invalidate(INVALIDATION_FLAG_TITLE_CHANGED);
		}
		private var _title:String = "";
		public function set title(value:String):void
		{
			if(_title == value)
				return;
			_title = value;
			if(_title.length == 0)
				titleVisble = false;
			else
				titleVisble = true;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		public function get title():String
		{
			return _title;
		}
		
		/*SKIN*/
		private var _selectedStyles:Object = {};
		private var _defaultSkin:DisplayObject;
		private var _contentSkin:DisplayObject;
		private var _titleSkin:DisplayObject;
		
		public function set defaultSkin(value:DisplayObject):void
		{
			if(_defaultSkin == value)	return;
			_selectedStyles.defaultSkin = value;
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		public function set contentSkin(value:DisplayObject):void
		{
			if(_contentSkin == value)	return;
			_selectedStyles.contentSkin = value;
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		public function set titleSkin(value:DisplayObject):void
		{
			if(_contentSkin == value)	return;
			_selectedStyles.titleSkin = value;
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/*Styles*/
		private var _gap:Number = 10;
		public function get gap():Number
		{
			return this._gap;
		}
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		private var _padding:Number = 20;
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(_padding == value)
				return;
			_padding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		override public function set width(value:Number):void
		{
			this.actualWidth = value;
		}
		override public function get width():Number
		{
			return this.actualWidth;
		}
		
		private var _callBackFuncs:Array;
		private var _callBackParams:Array;
		
		/*view*/
		private var _contentLabel:Label;
		private var _titleLabel:Label;
		private var _buttonGroup:ButtonGroup;
		private var _titleLabelContainer:FeathersControl;
		private var _contentLabelContainer:FeathersControl;
		
		override protected function initialize():void
		{
			_titleLabelContainer = new FeathersControl();
			addChild(_titleLabelContainer);
			
			_contentLabelContainer = new FeathersControl();
			addChild(_contentLabelContainer);
			
			_contentLabel = new Label();
			this._contentLabelContainer.addChild(_contentLabel);
			_contentLabel.nameList.add(DEFAULT_CHILD_CONTENT_LABEL);
			
			_titleLabel = new Label();
			this._titleLabelContainer.addChild(_titleLabel);
			_titleLabel.nameList.add(DEFAULT_CHILD_TITLE_LABEL);
			
			_buttonGroup = new ButtonGroup();
			_buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			this.addChild(_buttonGroup);
			_buttonGroup.nameList.add(DEFAULT_CHILD_NAME_BUTTONGROUP);
>>>>>>> temp
		}
		
		override protected function draw():void
		{
<<<<<<< HEAD
			const defaultSkinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DEFAULT_SKIN);
			const contentSkinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CONTENT_SKIN);
			const dataTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TYPE);
			const contentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			
			if(contentInvalid)
				updateFromContent();
			if(dataTypeInvalid)
				updateGroupData();
			if(stylesInvalid)
				updateStyles();
			if(defaultSkinInvalid)
				updateDefaultSkin();
			if(contentSkinInvalid)
				updateContentSkin();
		}
		
		private function updateStyles():void
		{
			this.width = this.maxWidth;
			
			this._labelContainer.width = this._maxWidth - this._padding*2;
			this._labelContainer.height = this._label.height;
			this._labelContainer.x = this._labelContainer.y = this._padding;
			
			this._buttonGroup.x = this.width - this._buttonGroup.width >> 1;
			this._buttonGroup.y = this._labelContainer.y + this._labelContainer.height + this.gap;
			
			this.height = this._buttonGroup.y + this._buttonGroup.height + this._padding;
		}
		
		private function updateGroupSize():void
		{
			this._buttonGroup.y = this._labelContainer.y + this._labelContainer.height + this._gap;
=======
			if(!_selectedStyles.defaultSkin)
				throw new Error("The defaultSkin is UnDefined!");
			
			const skinTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			const dataTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const titleChangeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TITLE_CHANGED);
			
			
			if(skinTypeInvalid)
				createDefaultSkin();
			if(dataTypeInvalid)
				updateViewContent();
			if(titleChangeInvalid || skinTypeInvalid || stylesTypeInvalid )
				updateStyles();
		}
		
		private function createTitleSkin():void
		{
			if(_selectedStyles.titleSkin)
			{
				if(this._titleSkin)
				{
					if(this._titleSkin != _selectedStyles.titleSkin)
					{
						this._titleSkin.removeFromParent();
						this._titleSkin = _selectedStyles.titleSkin;
						this._titleLabelContainer.addChildAt(_titleSkin, 0);
					}
				}else
				{
					this._titleSkin = _selectedStyles.titleSkin;
					this._titleLabelContainer.addChildAt(_titleSkin, 0);
					
				}
				this._titleSkin.width = this._titleLabelContainer.width;
				this._titleSkin.height = this._titleLabelContainer.height;
//				this._titleSkin.x = this._titleLabelContainer.width - this._titleSkin.width >> 1;
//				this._titleSkin.y = this._titleLabelContainer.height - this._titleSkin.height >> 1;
			}
		}
		private function createContentSkin():void
		{
			if(_selectedStyles.contentSkin)
			{
				if(this._contentSkin)
				{
					if(this._contentSkin != _selectedStyles.contentSkin)
					{
						this._contentSkin.removeFromParent();
						this._contentSkin = _selectedStyles.contentSkin;
						this._contentLabelContainer.addChildAt(_contentSkin, 0);
					}
				}else
				{
					this._contentSkin = _selectedStyles.contentSkin;
					this._contentLabelContainer.addChildAt(_contentSkin, 0);
				}
				this._contentSkin.width = this._contentLabelContainer.width;
				this._contentSkin.height = this._contentLabelContainer.height;
				//this._contentSkin.x = this._contentLabelContainer.width - this._contentSkin.width >> 1;
				//this._contentSkin.y = this._contentLabelContainer.height - this._contentSkin.height >> 1;
			}
		}
		private function createDefaultSkin():void
		{
			if(_selectedStyles.defaultSkin)
			{
				if(this._defaultSkin)
				{
					if(this._defaultSkin != _selectedStyles.defaultSkin)
					{
						this._defaultSkin.removeFromParent();
						this._defaultSkin = _selectedStyles.defaultSkin;
						this.addChildAt(_defaultSkin, 0);
					}
				}else
				{
					this._defaultSkin = _selectedStyles.defaultSkin;
					this.addChildAt(_defaultSkin, 0);
				}
				this._defaultSkin.width = this.actualWidth;
				this._defaultSkin.height = this.actualHeight;
			}
		}
		
		private function updateViewContent():void
		{
			//更新buttonGroup的data
			updateGroupData();
			//更新title内容
			this._titleLabel.text = this._title;
			this._titleLabel.validate();
			//更新content内容
			this._contentLabel.text = this._content;
			this._contentLabel.validate();
			
			trace(_titleLabel.height);
			trace(_contentLabel.height);
		}
		
		private function updateStyles():void
		{
			const contentWidth:Number = this.actualWidth - this._padding*2;
			/*w*/
			this._titleLabelContainer.width = this._contentLabelContainer.width
				= this._buttonGroup.width
				= this._titleLabel.width = this._contentLabel.width = contentWidth;
			/*h*/
			this._titleLabelContainer.height = this._titleLabel.height;
			this._contentLabelContainer.height = this.actualHeight - this.padding*2 - this._gap*2 - this._titleLabelContainer.height - this._buttonGroup.height;
			/*x*/
			this._titleLabelContainer.x = this._contentLabelContainer.x = this._buttonGroup.x = this._padding;
			/*y*/
			this._titleLabelContainer.y = this._padding;
			this._buttonGroup.y = this.actualHeight - _buttonGroup.height - this._padding;
			this._contentLabelContainer.y = actualHeight - this._contentLabelContainer.height >> 1;
			
			createContentSkin();
			createTitleSkin();
>>>>>>> temp
		}
		
		private function updateFromContent():void
		{
<<<<<<< HEAD
			this._label.text = this._viewData;
=======
			this._contentLabel.text = this._content;
>>>>>>> temp
		}
		
		private function updateGroupData():void
		{
			var datas:Array = [];
			switch(this._type)
			{
				case OK_CANCLE:
					datas.unshift({ label: "CANCLE", triggered: onTriggered });
				case OK:
					datas.unshift({ label: "OK", triggered: onTriggered });
					break;
			}
			_buttonGroup.dataProvider = new ListCollection(datas);
		}
<<<<<<< HEAD
		private function updateDefaultSkin():void
		{
			var scale9Image:Scale9Textures = new Scale9Textures(this._defaultSkin, new Rectangle(13, 0, 2, 82));
			this._defaultImageLoader.source = scale9Image;
			this._defaultImageLoader.width = this.width;
			this._defaultImageLoader.height = this.height;
		}
		private function updateContentSkin():void
		{
			var scale9Image:Scale9Textures = new Scale9Textures(this._defaultSkin, new Rectangle(13, 0, 2, 82));
			this._contentImageLoader.source = scale9Image;
			this._contentImageLoader.width = this._labelContainer.width;
			this._contentImageLoader.height = this._labelContainer.height;
		}
		
		private var _buttonGroup:ButtonGroup;
		private function initButtonGroup():void
		{
			_buttonGroup = new ButtonGroup();
			_buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			addChild(_buttonGroup);
			
			_buttonGroup.name = DEFAULT_CHILD_NAME_BUTTONGROUP;
//			_buttonGroup.nameList.add(DEFAULT_CHILD_NAME_BUTTONGROUP);
		}
=======
		
>>>>>>> temp
		private function onTriggered(e:Event):void
		{
			var func:Function;
			var button:Button;
			if(_callBackFuncs && _callBackFuncs.length>0 )
			{
				button = e.currentTarget as Button;
				switch(button.label)
				{
					case "OK":
						if( _callBackFuncs[0]!=null )
						{
							func = _callBackFuncs[0];
							((!_callBackParams) || !(_callBackParams[0])) ? func() : func(_callBackParams[0])
						}
						break;
					case "CANCLE":
						if( _callBackFuncs[1]!=null )
						{
							func = _callBackFuncs[1];
							((!_callBackParams) || !(_callBackParams[1])) ? func() : func(_callBackParams[1])
						}
						break;
				}
			}
			this.close();
		}
		
<<<<<<< HEAD
		/**
		 * 提示框背景皮肤
		 */		
		private var _defaultImageLoader:ImageLoader;
		private var _defaultSkin:Texture;
		public function set defaultSkin(value:Texture):void
		{
			if(_defaultSkin == value)	return;
			_defaultSkin = value;
			invalidate(INVALIDATION_FLAG_DEFAULT_SKIN);
		}
		
		/**
		 * 显示内容背景皮肤
		 */		
		private var _contentImageLoader:ImageLoader;
		private var _contentBackgroudSkin:Texture;
		public function set contentBackgroudSkin(value:Texture):void
		{
			if(_contentBackgroudSkin == value)	return;
			_contentBackgroudSkin = value;
			invalidate(INVALIDATION_FLAG_CONTENT_SKIN);
		}
		
		override public function dispose():void
		{
			if(_callBackFuncs)
				_callBackFuncs = null;
			if(_callBackParams)
				_callBackParams = null;
			if(_labelContainer)
				_labelContainer.dispose();
			if(_buttonGroup)
				_buttonGroup.dispose();
			
			super.dispose();
		}
		
		/**
		 * 显示框与按钮间距
		 */		
		private var _gap:Number = 10;
		public function get gap():Number
		{
			return this._gap;
		}
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		/**
		 * 边距
		 */		
		private var _padding:Number = 20;
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(_padding == value)
				return;
			_padding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
=======
		override public function dispose():void
		{
			/*if(_callBackFuncs)
				_callBackFuncs = null;
			if(_callBackParams)
				_callBackParams = null;
			if(_contentLabelContainer)
				_contentLabelContainer.dispose();
			if(_buttonGroup)
				_buttonGroup.dispose();
			
			super.dispose();*/
>>>>>>> temp
		}
		
	}
}