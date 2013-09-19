package views.global.userCenter.userInfo
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale3Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import models.FontVo;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;
	
	/**
	 * 用户信息：头像，名称
	 * @author Administrator
	 * 
	 */	
	public class ItemUserData extends Sprite
	{
		private var head:HeadIcon;
		private var nameBoard:Scale3Image;
		private var textInput:TextInput;
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param data
		 * @param touchable
		 * @param editable
		 * 
		 */		
		public function ItemUserData(width:Number, height:Number, data:Object, touchable:Boolean=false, editable:Boolean=false)
		{
			_width = width;
			_height = height;
			/* 
				username
				iconIndex
				birthday
			*/
			_data = data;
			_touchable = touchable;
			_editable = editable;
			init();
		}
		private function init():void
		{
			initHeadIcon();
			initNameBoard();
			initTextInput();
		}
		
		private function initTextInput():void
		{
			textInput = new TextInput();
//			textInput.textEditorProperties.fontName = FontVo.PALACE_FONT;
//			textInput.textEditorProperties.fontSize = 32;
			textInput.textEditorFactory = function():ITextEditor{
				var textField:TextFieldTextEditor = new TextFieldTextEditor();
				textField.textFormat = new TextFormat(FontVo.PALACE_FONT, 32, 0x5e6911);
				return new TextFieldTextEditor();
			};
			textInput.maxChars = 5;
			textInput.isEditable = _editable;
//			textInput.prompt = "你的名字？";
			
			const inputLayoutData:AnchorLayoutData = new AnchorLayoutData();
			inputLayoutData.horizontalCenter = 0;
			inputLayoutData.verticalCenter = 0;
			textInput.layoutData = inputLayoutData;

			textInput.width = nameBoard.width - 40;
			textInput.height = this.nameBoard.height;
			textInput.x = head.width;
			textInput.y = this.nameBoard.y;
			this.addChild( textInput );
			
			if(_editable)
			{
				textInput.addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
				textInput.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
			}
		}
		
		private function onFocusOut():void
		{
			
		}
		
		private function onFocusIn():void
		{
		}		
		
		private function initNameBoard():void
		{
			var t:Texture = UserCenterManager.getTexture("");
			this.nameBoard = new Scale3Image(new Scale3Textures(t, 74, 83));
			this.nameBoard.width = _width - head.width + 40;
			this.nameBoard.height = t.height;
			this.nameBoard.x = head.width - 40;
			this.nameBoard.y = _height - nameBoard.height >> 1;
			this.addChild( nameBoard );
			nameBoard.touchable = false;
		}
		
		private function initHeadIcon():void
		{
			head = new HeadIcon(_height, _height);
			head.id = _data.iconIndex;
			head.background = new Scale9Textures(UserCenterManager.getTexture(""), new Rectangle(1,1,20,20));
			head.icon = UserCenterManager.getTexture(_data.iconIndex);
			this.addChild( head );
			
			head.touchable = _touchable;
			if(_touchable)
				head.addEventListener(HeadIcon.SECLECTED, onTouch);
		}
		private function onTouch(e:Event):void
		{
			trace(e.data);
		}
		
		private var _editable:Boolean = false;
		private var _touchable:Boolean = false;
		
		private var _width:Number;
		override public function set width(value:Number):void
		{
			this._width = value;
			this.nameBoard.width = this._width - nameBoard.x;
		}
		private var _height:Number;
		override public function set height(value:Number):void
		{
			this._height = this.head.width = this.head.height = value;
			this.nameBoard.x = head.width - 40;
			this.textInput.y = this.nameBoard.y = _height - this.nameBoard.height >> 1;
		}
		private var _data:Object;
		
		
		override public function dispose():void
		{
			_data = null;
			if(head)
			{
				if(head.hasEventListener(TouchEvent.TOUCH))
					head.removeEventListener(TouchEvent.TOUCH, onTouch);
				this.removeChild(head);
				head.dispose();
				head=null;
			}
			if(nameBoard)
			{
				this.removeChild( nameBoard );
				nameBoard.dispose();
				nameBoard = null;
			}
			if(textInput)
			{
				if(_editable)
				{
					textInput.removeEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
					textInput.removeEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
				}
				this.removeChild( textInput );
				textInput.dispose();
				textInput = null;
			}
			super.dispose();
		}
	}
}