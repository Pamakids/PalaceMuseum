package controls
{
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
		private static var _instance:Alert;
		
		public static function getInstance():Alert
		{
			if(!_instance)	_instance = new Alert();
			return _instance;
		}
		
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
		public function Alert()
		{
			super();
		}
		
		
		private var _type:String;
		private function set type(value:String):void
		{
			if(_type == value)
				return;
			_type = value;
			invalidate( INVALIDATION_FLAG_TYPE );
			invalidate( INVALIDATION_FLAG_STYLES );
		}
		private function get type():String
		{
			return _type;
		}
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
		}
		
		override protected function draw():void
		{
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
		}
		
		private function updateFromContent():void
		{
			this._label.text = this._viewData;
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
		}
		
	}
}