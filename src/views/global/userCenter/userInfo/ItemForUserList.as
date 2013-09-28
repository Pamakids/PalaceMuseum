package views.global.userCenter.userInfo
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.events.FeathersEventType;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import views.global.userCenter.UserCenterManager;
	
	/**
	 * 用户信息：头像，名称
	 * @author Administrator
	 * 
	 */	
	public class ItemForUserList extends Sprite
	{
		private var head:HeadIcon;
		private var textInput:TextInput;
		
		/**
		 * @param data
		 * { username: "name", iconIndex: 0, birthday: "2013-01-11"}
		 * @param touchable
		 * 头像交互
		 * @param editable
		 * 用户名编辑
		 */
		public function ItemForUserList(data:Object, touchable:Boolean=false, editable:Boolean=false)
		{
			_data = data;
			_touchable = touchable;
			_editable = editable;
			init();
		}
		private function init():void
		{
			initBackImages();
			initHeadIcon();
			initTextInput();
		}
		
		private function initBackImages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("background_nameboard"));
			this.addChild( image );
			image.x = 50;
			image.y = 27;
			image.touchable = false;
			
			image = new Image(UserCenterManager.getTexture("background_headicon"));
			this.addChild( image );
			image.touchable = false;
		}
		
		public var editIconFactory:Function;
		
		private function initTextInput():void
		{
			textInput = new TextInput();
			textInput.textEditorFactory = function stepperTextEditorFactory():TextFieldTextEditor{
				return new TextFieldTextEditor();
			};
			textInput.textEditorProperties.textFormat = new TextFormat(FontVo.PALACE_FONT, 26, 0xfeffcf, null, null, null, null, null, TextFormatAlign.CENTER);
			textInput.textEditorProperties.embedFonts = true;
			textInput.text = this._data.username;
			textInput.text = "我是小皇帝";
			textInput.maxChars = 5;
			this.addChild( textInput );
			textInput.width = 140;
			textInput.height = 30;
			textInput.x = 100;
			textInput.y = 35;
			textInput.touchable = this._editable;
			if(_editable)
			{
				textInput.addEventListener( FeathersEventType.FOCUS_OUT, input_focusOutHandler )
			}
		}
		
		private function input_focusOutHandler():void
		{
			if(textInput.text.length > 0)
				this._data.username = textInput.text;
		}
		
		private function initHeadIcon():void
		{
			head = new HeadIcon(_data.iconIndex);
			this.addChild( head );
			head.x = head.y = 50;
			head.scaleX = head.scaleY = 0.7;
			head.touchable = _touchable;
			if(_touchable)
				head.addEventListener(Event.TRIGGERED, onTriggered);
		}
		private function onTriggered(e:Event):void
		{
			editIconFactory( this._data );
		}
		
		private var _editable:Boolean = false;
		private var _touchable:Boolean = false;
		
		/**
		 * 角色信息
		 * { username: "name", iconIndex: 0, birthday: "2013-01-11"}
		 */		
		private var _data:Object;
		
		override public function dispose():void
		{
			_data = null;
			if(head)
			{
				if(head.hasEventListener(Event.TRIGGERED))
					head.removeEventListener(Event.TRIGGERED, onTriggered);
				this.removeChild(head);
				head.dispose();
				head=null;
			}
			if(textInput)
			{
				if(_editable)
				{
					textInput.removeEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
				}
				this.removeChild( textInput );
				textInput.dispose();
				textInput = null;
			}
			super.dispose();
		}
		
		public function updateView():void
		{
			head.resetIcon(_data.iconIndex);
			textInput.text = _data.username;
		}
	}
}