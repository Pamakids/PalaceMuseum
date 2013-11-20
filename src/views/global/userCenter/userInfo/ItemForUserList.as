package views.global.userCenter.userInfo
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.events.FeathersEventType;
	
	import models.FontVo;
	import models.SOService;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
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
		 * { username: "name", avatarIndex: 0, birthday: "2013-01-11"}
		 * @param editable
		 * 用户名编辑
		 */
		public function ItemForUserList(data:Object=null, editable:Boolean=false)
		{
			_data = data;
			_editable = editable;
			init();
		}
		private function init():void
		{
			initBackImages();
			initHeadIcon();
			initTextInput();
		}
		
		/**
		 * 暂时存储变更，若确定变更则存入本地缓存
		 */		
		private var cacheData:Object;
		
		private var nameBoard:Image;
		private function initBackImages():void
		{
			nameBoard = UserCenterManager.getImage("background_nameboard");
			this.addChild( nameBoard );
			nameBoard.x = 50;
			nameBoard.y = 27;
			if(!_data)
				nameBoard.alpha = .6;
			var image:Image = UserCenterManager.getImage("background_headicon");
			this.addChild( image );
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
			textInput.text = _data?_data.username:"";
			textInput.maxChars = 5;
			this.addChild( textInput );
			textInput.width = 140;
			textInput.height = 30;
			textInput.x = 100;
			textInput.y = 35;
			textInput.addEventListener( FeathersEventType.FOCUS_OUT, input_focusOutHandler )
			textInput.touchable = this._editable;
		}
		
		private function input_focusOutHandler():void
		{
			if(textInput.text.length > 0)
				this._data.username = textInput.text;
		}
		
		private function initHeadIcon():void
		{
			head = new HeadIcon(_data?_data.avatarIndex:null);
			this.addChild( head );
			head.x = head.y = 50;
			head.scaleX = head.scaleY = 0.7;
			head.addEventListener(Event.TRIGGERED, onTriggered);
			head.touchable = _editable;
		}
		private function onTriggered(e:Event):void
		{
			editIconFactory( this._data );
		}
		
		private var _editable:Boolean = false;
		
		public function resetData(userData:Object):void
		{
			this._data = userData;
			if(this)
			if(this._editable)		//能编辑
			{
				if(!_data)
					_data = {
						username:		"请输入",
						avatarIndex:	0,
						birthday:		SOService.dateToString(new Date())
					};
				this.head.resetIcon(_data.avatarIndex);
				this.textInput.text = _data.username;
			}
			else			//不能编辑
			{
				if(_data)
				{
					this.head.resetIcon(_data.avatarIndex);
					this.textInput.text = _data.username;
					this.nameBoard.alpha = 1;
				}
				else
				{
					this.head.resetIcon(null);
					this.textInput.text = "";
					this.nameBoard.alpha = 0.6;
				}
			}
		}
		
		/**
		 * 角色信息
		 * { username: "name", avatarIndex: 0, birthday: "2013-01-11"}
		 */		
		private var _data:Object;
		
		override public function set touchable(value:Boolean):void
		{
			if(value && !this.hasEventListener(TouchEvent.TOUCH))
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			else if(!value && this.hasEventListener(TouchEvent.TOUCH))
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
			super.touchable = value;
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
				dispatchEventWith(Event.TRIGGERED, false, _data);
		}
		
		override public function dispose():void
		{
			_data = null;
			editIconFactory = null;
			if(nameBoard)
				nameBoard.removeFromParent(true);
			if(head)
			{
				if(head.hasEventListener(Event.TRIGGERED))
					head.removeEventListener(Event.TRIGGERED, onTriggered);
				head.removeFromParent(true);
			}
			if(textInput)
			{
				if(_editable)
					textInput.removeEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
				textInput.removeFromParent(true)
			}
			super.dispose();
		}
	}
}