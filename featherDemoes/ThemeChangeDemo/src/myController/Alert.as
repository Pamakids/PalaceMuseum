package myController
{
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class Alert extends FeathersControl
	{
		/**
		 * 默认皮肤
		 */		
//		[Embed(source="source")]	private static const DEFAULT_IMAGE:Class;
//		public static var DEFAULT_SKIN:Texture = Texture.fromBitmap(new DEFAULT_IMAGE());
		
		/**
		 * 用于Themes
		 */		
		public static const DEFAULT_CHILD_NAME_BUTTONGROUP:String = "feathers-button-group-button";
		
		public static const OK:String = "ok";
		public static const OK_CANCLE:String = "ok_cancle";
		
		/**
		 * @param view_		显示内容，可以是String，Texture，或FeathersControl
		 * @param type_		"ok"/"ok_cancle"
		 * @param returnFunctionArr_	按钮回调函数数组[okFunc, cancleFunc]
		 * @param returnDataArr_		参数[okParam, cancleParam]
		 */	
		public function Alert(view_:Object,type_:String="ok",returnFunctionArr_:Array=null,returnDataArr_:Array=null)
		{
			super();
			this._viewData = view_;
			this._type = type_;
			this._callBackFuncs = returnFunctionArr_;
			this._callBackParams = returnDataArr_;
		}
		
		private var _type:String;
		private var _viewData:Object;
		private var _callBackFuncs:Array;
		private var _callBackParams:Array;
		private var _backgroundView:DisplayObject;
		
		private var _view:DisplayObject;
		private function initView():void
		{
			if(_viewData is String)
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
			this._viewContainer.addChild(_view);
		}
		
		/**
		 * 显示对象容器
		 */		
		private var _viewContainer:FeathersControl;
		
		override protected function initialize():void
		{
			initBackGroundView();
			initViewContainer();
			initSkin();
			initView();
			initButtonGroup();
		}
		
		private function initBackGroundView():void
		{
//			if(!_defaultSkin)
//				_defaultSkin = new Image(DEFAULT_SKIN);
//			this.addChild( _defaultSkin );
		}
		
		private function initSkin():void
		{
			if(_contentBackgroudSkin)
				this._viewContainer.addChild( _contentBackgroudSkin );
		}
		
		private function initViewContainer():void
		{
			_viewContainer = new FeathersControl();
			addChild(_viewContainer);
		}
		
		override protected function draw():void
		{
//			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
//			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
//			const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
//			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
//			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
//			const selectedInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
//			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
//			const focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
			
//			if(stylesInvalid)
//			if(skinInvalid)
			
			this._viewContainer.x = this._viewContainer.y = this._padding;
			this._viewContainer.width = this.width - this._padding*2;
			this._view.x = this._viewContainer.width - this._view.width >> 1;
			this._view.y = this._viewContainer.height - this._view.height >> 1;
			this._buttonGroup.x = this.width - this._buttonGroup.width >> 1;
			this._buttonGroup.y = this._viewContainer.y + this._viewContainer.height + this._gap;
		}
		
		private var _buttonGroup:ButtonGroup;
		private function initButtonGroup():void
		{
			_buttonGroup = new ButtonGroup();
			
			var datas:Array = [];
			switch(this._type)
			{
				case OK_CANCLE:
					datas.push({ label: "CANCLE", triggered: onTriggered });
				case OK:
					datas.push({ label: "OK", triggered: onTriggered });
					break;
			}
			_buttonGroup.dataProvider = new ListCollection(datas);
			_buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			_buttonGroup.nameList.add( DEFAULT_CHILD_NAME_BUTTONGROUP );
//			_buttonGroup.name = Alert.DEFAULT_CHILD_NAME_BUTTONGROUP;
			addChild(_buttonGroup);
		}
		private function onTriggered(e:Event):void
		{
			var func:Function;
			var button:Button;
			if(!_callBackFuncs || _callBackFuncs.length==0)
			{
				return;
			}else
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
			this.dispose();
		}
		
		/**
		 * 提示框背景皮肤
		 */		
		private var _defaultSkin:DisplayObject;
		public function set defaultSkin(value:DisplayObject):void
		{
			if(_contentBackgroudSkin == value)	return;
			_defaultSkin = value;
			invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 * 显示内容背景皮肤
		 */		
		private var _contentBackgroudSkin:DisplayObject;
		public function set contentBackgroudSkin(value:DisplayObject):void
		{
			if(_contentBackgroudSkin == value)	return;
			_contentBackgroudSkin = value;
			invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		}
		
		override public function dispose():void
		{
			if(_callBackFuncs)
				_callBackFuncs = null;
			if(_callBackParams)
				_callBackParams = null;
			if(_viewContainer)
				_viewContainer.dispose();
			if(_buttonGroup)
				_buttonGroup.dispose();
			
			super.dispose();
		}
		
		/**
		 * 显示框与按钮间距
		 */		
		private var _gap:Number;
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
		private var _padding:Number;
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