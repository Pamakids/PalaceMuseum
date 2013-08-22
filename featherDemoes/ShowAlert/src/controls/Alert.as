package controls
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class Alert extends FeathersControl
	{
		private static const INVALIDATION_FLAG_PADDING:String = "feather-alert-padding";
		private static const INVALIDATION_FLAG_GAP:String = "feather-alert-gap";
		private static const INVALIDATION_FLAG_TITLE:String = "feather-alert-title";
		private static const INVALIDATION_FLAG_CONTENT:String = "feather-alert-content";
		private static const INVALIDATION_FLAG_TITLELABEL_STYLES:String = "feather-alert-title-factory";
		private static const INVALIDATION_FLAG_CONTENTLABEL_STYLES:String = "feather-alert-content-factory";
		private static const INVALIDATION_FLAG_BUTTONGROUP_STYLES:String = "feather-alert-buttonGroup-factory";
		/*
		 * for themes
		 */		
		public static const DEFAULT_CHILD_NAME_BUTTONGROUP:String = "feathers-alert-buttonGroup";
		public static const DEFAULT_CHILD_TITLE_LABEL:String = "feathers-label-alert-title-label";
		public static const DEFAULT_CHILD_CONTENT_LABEL:String = "feathers-label-alert-content-label";
		/*
		 * type
		 */		
		public static const OK:String = "ok";
		public static const OK_CANCLE:String = "ok_cancle";
		
		private static var _instance:Alert;
		public static function getInstance():Alert
		{
			if(!_instance)	_instance = new Alert(new PrivateClass());
			return _instance;
		}
		
		public function Alert(obj:PrivateClass){}
		
		private var _starling:Starling;
		public function showAlert(content_:String,title_:String="",type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null):void
		{
			this.content = content_;
			this.title = title_;
			this.type = type_;
			this._callBackFuncs = returnFunctionArr_;
			this._callBackParams = returnDataArr_;
			
			_starling = Starling.current;
			_starling.stage.addChild( Alert.getInstance() );
		}
		
		private function close():void
		{
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		/*Data*/
		private var _type:String;
		private function set type(value:String):void
		{
			if(_type && _type == value)
				return;
			_type = value;
			invalidate(INVALIDATION_FLAG_STATE);
		}
		private function get type():String
		{
			return _type;
		}
		
		private var _content:String;
		public function set content(value:String):void
		{
			if(_content && _content == value)
				return;
			_content = value;
			invalidate(INVALIDATION_FLAG_CONTENT);
		}
		public function get content():String
		{
			return _content;
		}
		private var _titleVisble:Boolean = false;
		private var _title:String = "";
		public function set title(value:String):void
		{
			if(_title && _title == value)
				return;
			_title = value;
			_titleVisble = (_title.length > 0);
			invalidate(INVALIDATION_FLAG_TITLE);
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
			this.invalidate(INVALIDATION_FLAG_GAP);
		}
		private var _padding:Number = 10;
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(_padding == value)
				return;
			_padding = value;
			this.invalidate(INVALIDATION_FLAG_PADDING);
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
			
			titleInitializer();
			contentInitializer();
			buttonGrouInitializer();
		}
		
		override protected function draw():void
		{
			const titleFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TITLELABEL_STYLES);
			const contentFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CONTENTLABEL_STYLES);
			const buttonGroupFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_BUTTONGROUP_STYLES);
			
			const paddingTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PADDING);
			const gapTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_GAP);
			const contentTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CONTENT);
			const titleTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TITLE);
			const skinTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			const stateTypeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(titleFactoryInvalid)
				titleInitializer();
			if(contentFactoryInvalid)
				contentInitializer();
			if(buttonGroupFactoryInvalid)
				buttonGrouInitializer();
			if(stateTypeInvalid)
				updateGroupData();
			if(skinTypeInvalid)
				renderSkin();
			if(titleTypeInvalid || titleFactoryInvalid)
				renderTitleText();
			if(contentTypeInvalid || contentFactoryInvalid)
				rederContentText();
			if(titleTypeInvalid || paddingTypeInvalid || titleFactoryInvalid)
				resizeWidth();
			if(titleTypeInvalid || contentTypeInvalid || gapTypeInvalid || titleFactoryInvalid || contentFactoryInvalid)
				resizeHeight();
			if(paddingTypeInvalid || gapTypeInvalid || contentTypeInvalid || titleTypeInvalid || skinTypeInvalid || titleFactoryInvalid || contentFactoryInvalid)
				resizeSkin();
			
			//定位
			this.x = _starling.stage.stageWidth - this.actualWidth >> 1;
			this.y = _starling.stage.stageHeight - this.actualHeight >> 1;
		}
		
		private function contentInitializer():void
		{
			if(_contentLabel)
				_contentLabel.removeFromParent(true);
			if(_contentLabelFactory)
			{
				_contentLabel = _contentLabelFactory();
			}else
			{
				_contentLabel = new Label();
				_contentLabel.nameList.add(DEFAULT_CHILD_CONTENT_LABEL);
			}
			this._contentLabelContainer.addChild(_contentLabel);
		}
		
		private function buttonGrouInitializer():void
		{
			if(_buttonGroup)
				_buttonGroup.removeFromParent(true);
			if(_buttonGroupFactory)
			{
				_buttonGroup = _buttonGroupFactory();
			}else
			{
				_buttonGroup = new ButtonGroup();
				_buttonGroup.nameList.add(DEFAULT_CHILD_NAME_BUTTONGROUP);
			}
			this.addChild(_buttonGroup);
		}
		
		private function titleInitializer():void
		{
			if(_titleLabel)
				_titleLabel.removeFromParent(true);
			if(_titlelabelFactory)
			{
				_titleLabel = _titlelabelFactory();
			}else
			{
				_titleLabel = new Label();
				_titleLabel.nameList.add(DEFAULT_CHILD_TITLE_LABEL);
			}
			this._titleLabelContainer.addChild(_titleLabel);
		}
		
		private function renderSkin():void
		{
			this.createDefaultSkin();
			this.createTitleSkin();
			this.createContentSkin();
		}
		
		private function rederContentText():void
		{
			_contentLabel.text = _content;
			_contentLabel.width = this.actualWidth - this._padding*2;
			_contentLabel.validate();
		}
		
		private function renderTitleText():void
		{
			this._titleLabel.textRendererProperties.wordWorp = false;
			this._titleLabel.text = this._title;
			this._titleLabel.validate();
			trace(this._titleLabel.width);
			if(this.maxWidth - this._padding*2 < this._titleLabel.width)
			{
				this._titleLabel.width = this.maxWidth - this._padding*2;
				this._titleLabel.textRendererProperties.wordWorp = true;
				this._titleLabel.invalidate();
				this._titleLabel.validate();
//				trace(_titleLabel.width);
				trace(this._titleLabel.textRendererProperties.wordWorp);
			}
			//确定alert宽度
			this.width = Math.min(this.maxWidth, Math.max( this._titleLabel.width + this.padding*2, this.minWidth));
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
			}
		}
		
		private function resizeWidth():void
		{
			const W:Number = this.actualWidth - this._padding*2;
			this._titleLabelContainer.width = this._contentLabelContainer.width = this._buttonGroup.width = W;
			
			repositionX();
		}
		private function resizeHeight():void
		{
			this._titleLabelContainer.visible = this._titleVisble;
			this._titleLabelContainer.height = (this._titleVisble)?this._titleLabel.height:0;
			this._contentLabelContainer.height = this._contentLabel.height;
			this.height = this._titleLabelContainer.height + this._contentLabelContainer.height + this._buttonGroup.height
							+ this._padding*2 + ((this._titleVisble)?this._gap*2:this._gap);
			
			repositionY();
		}
		private function resizeSkin():void
		{
			if(this._defaultSkin)
				resizeSkinFunc(this._defaultSkin);
			if(this._contentSkin)
				resizeSkinFunc(this._contentSkin);
			if(this._titleSkin)
				resizeSkinFunc(this._titleSkin);
		}
		
		private function resizeSkinFunc(skin:DisplayObject):void
		{
			skin.width = skin.parent.width;
			skin.height = skin.parent.height;
		}
		private function repositionX():void
		{
			this._titleLabelContainer.x = this._contentLabelContainer.x = this._buttonGroup.x = this._padding;
			this._titleLabel.x = this._titleLabelContainer.width - this._titleLabel.width >> 1;
			this._contentLabel.x = this._contentLabelContainer.width - this._contentLabel.width >> 1;
		}
		private function repositionY():void
		{
			this._titleLabelContainer.y = this._padding;
			this._contentLabelContainer.y = _titleLabelContainer.y + this._titleLabelContainer.height + this._gap;
			this._buttonGroup.y = this._contentLabelContainer.y + this._contentLabelContainer.height + this._gap;
		}
		
		private var _datas:Array;
		private function updateGroupData():void
		{
			_datas = [];
			switch(this._type)
			{
				case OK_CANCLE:
					_datas.unshift({ label: "CANCLE", triggered: onTriggered });
				case OK:
					_datas.unshift({ label: "OK", triggered: onTriggered });
					break;
			}
			_buttonGroup.dataProvider = new ListCollection(_datas);
			if(_buttonGroup.height == 0)
				_buttonGroup.validate();
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
		
		override public function dispose():void
		{
			//
			//	...
			//
			super.dispose();
		}
		
		
		/*Factory*/
		
		/*Label Title Factory*/
		private var _titlelabelFactory:Function;
		/**
		 * return Label
		 */		
		public function set titleLabelFactory(value:Function):void
		{
			if(_titlelabelFactory && _titlelabelFactory == value)
				return;
			_titlelabelFactory = value;
			invalidate(INVALIDATION_FLAG_TITLELABEL_STYLES);
		}
		public function get titleLabelFactory():Function
		{
			return _titlelabelFactory;
		}
		/*Label Content Factory*/	
		private var _contentLabelFactory:Function;
		/**
		 * return Label
		 */		
		public function set contentLabelFactory(value:Function):void
		{
			if(_contentLabelFactory && _contentLabelFactory == value)
				return;
			_contentLabelFactory = value;
			invalidate(INVALIDATION_FLAG_CONTENTLABEL_STYLES);
		}
		public function get contentLabelFactory():Function
		{
			return _contentLabelFactory;
		}
		/*ButtonGroup Factory*/
		private var _buttonGroupFactory:Function;
		/**
		 * return ButtonGroup
		 */		
		public function set buttonGroupFactory(value:Function):void
		{
			if(_buttonGroupFactory && _buttonGroupFactory == value)
				return;
			_buttonGroupFactory = value;
			invalidate(INVALIDATION_FLAG_BUTTONGROUP_STYLES);
		}
		public function get buttonGroupFactory():Function
		{
			return _buttonGroupFactory;
		}
		/*OKButton Factory*/		
		private var _okButtonFactory:Function;
		public function set okButtonFactory(value:Function):void
		{
			if(_okButtonFactory && _okButtonFactory == value)
				return;
			_okButtonFactory = this._buttonGroup.firstButtonFactory = value;
		}
		public function get okButtonFactory():Function
		{
			return _okButtonFactory;
		}
		/*CancleButton Factory*/		
		private var _cancleButtonFactory:Function;
		public function set cancleButtonFactory(value:Function):void
		{
			if(_cancleButtonFactory && _cancleButtonFactory == value)
				return;
			_cancleButtonFactory = this._buttonGroup.lastButtonFactory = value;
		}
		public function get cancleButtonFactory():Function
		{
			return _cancleButtonFactory;
		}
	}
}

class PrivateClass{}