package views.components.share
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;

	import starling.core.Starling;

	public class ShareView extends Sprite
	{
		public function ShareView()
		{
			UMSocial.instance.init(ShareVO.SINA_APPKEY,ShareVO.WEIXIN_APPKEY);
			for (var i:int = 0; i < typeArr.length; i++) 
			{
				var btnname:String=typeArr[i]
				var cls:Class=ShareAssets[btnname];
				var btn:Sprite=new Sprite();
				btn.addChild(new cls());
				btnArr.push(btn);
				addChild(btn)
				btn.addEventListener(MouseEvent.CLICK,onBtnClick);
				btn.x=posXArr[i];
				btn.y=posY;
			}
		}

		protected function onBtnClick(event:Event):void
		{
			var bp:Sprite=event.currentTarget as Sprite;
			var index:int=btnArr.indexOf(bp);

			type=typeArr[index];
			id=idArr[index];
			showConfirm();
		}

		private var id:String='';
		private var title:String='';
		private var content:String='';
		private var img:String='';
		private var type:String='';

		private var posXArr:Array=[358,435,522,600];
		private var typeArr:Array=['sina','tencent','weixin_chat','weixin_friend'];
		private var idArr:Array=[ShareVO.SINA_APPKEY,ShareVO.TENCENT_APPKEY,ShareVO.WEIXIN_APPKEY,ShareVO.WEIXIN_APPKEY];
		private var btnArr:Array=[];
		private var posY:Number=629;

		private static var _instance:ShareView;
		private var maskS:Sprite;
		private var hint:ConfirmView;

		public static function get instance():ShareView
		{
			if(!_instance)
				_instance=new ShareView();
			return _instance;
		}

		public function init(pr:Sprite):void
		{
			pr.addChild(this);
			visible=false;
		}

		public function show(_title:String,_content:String,_img:String):void
		{
			Starling.current.stage.touchable=true;
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;

			title=_title;
			content=_content;
			img=_img;

			this.parent.setChildIndex(this,this.parent.numChildren-1);
			this.visible=true;
		}

		public function hide():void
		{
			Starling.current.stage.touchable=true;
			this.visible=false;
		}

		private function showConfirm():void
		{

			Starling.current.stage.touchable=false;
			if (!hint)
			{
				maskS=new Sprite();
				maskS.graphics.beginFill(0, 0.5);
				maskS.graphics.drawRect(0, 0, 1024, 768);
				maskS.graphics.endFill()
				addChild(maskS);
				maskS.alpha=.6;
//				TweenLite.to(maskS, 0.5, {alpha: 1});

				hint=new ConfirmView();
				hint.init();
				addChild(hint);

				if (Capabilities.isDebugger)
				{
					addEventListener(MouseEvent.MIDDLE_CLICK, onClick);
				}

				addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			}
			hint.getRandomGesture();
		}

		protected function onClick(event:MouseEvent):void
		{
			clearHint();
			clearCheck();
			removeEventListener(MouseEvent.MIDDLE_CLICK, onClick);
		}

		protected function onTouchBegin(event:TouchEvent):void
		{
			count++;
			if (count <= 2)
				tcDic[event.touchPointID]=new Point(event.stageX, event.stageY);
		}

		protected function onTouchEnd(event:TouchEvent):void
		{
			if (!tcDic[event.touchPointID])
				return;
			var check:Boolean=false;
			switch (hint.getCurrentDir())
			{
				case "up":
				{
					if (event.stageY < tcDic[event.touchPointID].y)
						check=true;
					break;
				}
				case "down":
				{
					if (event.stageY > tcDic[event.touchPointID].y)
						check=true;
					break;
				}
				case "left":
				{
					if (event.stageX < tcDic[event.touchPointID].x)
						check=true;
					break;
				}
				case "right":
				{
					if (event.stageX > tcDic[event.touchPointID].x)
						check=true;
					break;
				}

				default:
				{
					break;
				}
			}

			delete tcDic[event.touchPointID];

			if (count < 2)
			{
				clearCheck();
				clearHint();
			}

			if (check)
			{
				if (!checkArr[0])
					checkArr[0]=true;
				else
				{
					doShare();
					clearHint();
					clearCheck();
				}

			}
			else
			{
				clearCheck();
				clearHint();
			}
		}

		private function doShare():void
		{
			if(type.indexOf('weixin')>=0)
			{
				content='';
				title='';
			}
			UMSocial.instance.share(id,content,img,title,type);
		}

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(2);
		private var count:int=0;
		private var tcDic:Dictionary=new Dictionary();

		private function clearCheck():void
		{
			count=0;
			for each (var i:int in tcDic)
			{
				delete tcDic[i];
			}

			checkArr[0]=false;
		}

		private function clearHint():void
		{
			Starling.current.stage.touchable=true;
			if (hint)
			{
				removeMask();
				if (contains(hint))
					removeChild(hint);
				hint=null;
			}
			removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);

		}

		private function removeMask():void
		{
			if (contains(maskS))
				removeChild(maskS);
		}
	}
}

