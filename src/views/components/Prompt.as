package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.utils.Dictionary;

	import controllers.MC;

	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	/**
	 * 全局提示
	 * @author mani
	 */
	public class Prompt extends Sprite
	{
		/**
		 *
		 * @default
		 */
		public static var parent:Sprite;
		/**
		 *
		 * @default
		 */
		public static var promptDic:Dictionary=new Dictionary();

		/**
		 *
		 * @default
		 */
		public var callback:Function;

		/**
		 *
		 * @default
		 */
		public var id:String;

		private var label:TextField;

		/**
		 *
		 * @param bg
		 * @param content
		 * @param algin
		 * @param fontSize
		 * @param bgAlign
		 */
		public function Prompt(bg:Object, content:String="", algin:int=1, fontSize=20, bgAlign:int=-1)
		{
			super();
			var bgImage:Image
			if (bg is Image)
			{
				bgImage=bg as Image;
				bgAlign=algin;
			}
			else if (bg is String)
				bgImage=getImage(bg as String);

			//t,f,1:左右翻转
			//f,f,1:non
			//f,t,1:平面翻转
			//t,t,1:non
			//t,f,-1:non
			//f,f,-1:平面翻转
			//f,t,-1:non
			//t,t,-1:non

			if (content)
			{
				var contentImage:Image=getImage(content);
				if (!contentImage)
				{
					var isK:Boolean=bg.indexOf("-k") < 0;
					var t:TextField=new TextField(isK ? bgImage.width - 30 : bgImage.width - 5, isK ? bgImage.height - 10 : bgImage.height - 20, content, FontVo.PALACE_FONT, fontSize, 0x561a1a, true);
					t.x=bgImage.x + isK ? 15 : 3;
					t.y=bgImage.y + isK ? 10 : 5;
					if (bgAlign == 7)
						t.y+=20;
					if (bg == "bg-task")
					{
						t.y+=10;
						t.fontSize=24 - int(content.length / 20);
						t.color=0xffffff;
						t.x+=12;
						t.width-=24;
//						algin=4
//						bgAlign=-1;
					}
					addChild(t);
					t.touchable=false;
				}
				else
				{
					addChild(contentImage);
					contentImage.x=(bgImage.width - contentImage.width) / 2;
					contentImage.y=(bgImage.height - contentImage.height) / 2;
				}
			}

			if (bgAlign > 0)
			{
				if (bgAlign == 3)
				{
					addChildAt(bgImage, 0);
					bgImage.x=bgImage.width;
					bgImage.scaleX=-1
				}
				else
				{
					addChildAt(bgImage, 0);
					if (bgAlign == 7)
					{
						bgImage.y=bgImage.height;
						bgImage.scaleY=-1
					}
				}
				algin=bgAlign;
			}
			else
				addChildAt(bgImage, 0);
			this.pivotX=(bgImage.width >> 1) * ((algin - 1) % 3);
			this.pivotY=(bgImage.height >> 1) * (2 - int((algin - 1) / 3));

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private static function checkLength(length:int):String
		{
			if (length < 20)
				return "";
			else if (length > 40)
				return "-large"
			return "-mid";
		}

		/**
		 *
		 * @param _x
		 * @param _y
		 * @param _content
		 * @param _size
		 * @param callBack
		 * @param _parent
		 * @param bgAlign
		 * @param isKnowledge 知识点背景
		 * @return
		 */
		public static function showTXT(_x:Number, _y:Number, _content:String, _size:int=20, callBack:Function=null, _parent:Sprite=null, bgAlign:int=1, isKnowledge:Boolean=false, hideDelay:Number=3, isTask:Boolean=false):Prompt
		{
			var bgSize:String=checkLength(_content.length)
			var bg:String="hint-bg" + (isKnowledge ? "-k" : "") + bgSize;
			bg=isTask ? "bg-task" : bg
			var delay:int=hideDelay == 0 ? 0 : hideDelay + Math.max(bgSize.length / 2 - 1, 0);
			return show(_x, _y, bg, _content, 1, delay + getDelay(_content.length), callBack, _parent, false, _size, bgAlign);
		}

		private static function getDelay(length:int):Number
		{
			if (length < 10)
				return .5;
			else if (length > 25)
				return 2.5
			return 1.5;
		}

		private function initLable(content:String):TextField
		{
			var length:int=content.length;
			var ta:TextField=new TextField(200, 100, content);
			ta.fontName="";
			return ta;
		}

		private function onTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (tc)
				playHide();
		}

		private function get hideEffect():Object
		{
			return {scaleX: .1, scaleY: .1, alpha: 0, ease: Cubic.easeIn};
		}

		private function get showEffect():Object
		{
			return {scaleX: 1, scaleY: 1, ease: Elastic.easeOut};
		}

		/**
		 *
		 * @param hideAfter
		 */
		public function playShow(hideAfter:Number):void
		{
			TweenLite.killDelayedCallsTo(playHide);
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(clearHandler);

			scaleX=scaleY=.1;
			TweenLite.to(this, 0.5, showEffect);
			if (hideAfter)
				TweenLite.delayedCall(hideAfter, playHide);
		}

		/**
		 *
		 */
		public function playHide():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
//			if (!this.parent)
//				return;
			TweenLite.killTweensOf(playHide);
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, hideEffect);
			TweenLite.killDelayedCallsTo(clearHandler);
			TweenLite.delayedCall(0.5, clearHandler, [this]);
		}

		private function clearHandler(p:Prompt):void
		{
			if (p.parent)
				p.removeFromParent(true);
			delete promptDic[p.id];
			if (p.callback != null)
				p.callback();
			p.callback=null;
		}

		/**
		 * 显示提示，可获取Prompt引用手动隐藏也可调用hide方法隐藏
		 * @param x
		 * @param y
		 * @param background 提示背景图
		 * @param content	 提示内容
		 * @param position 注册点位置，对应数字键盘方位，默认5居中, 1则是0，0
		 * @param hideAfter  自动消失时间
		 * @param parentSprite
		 * @return
		 *
		 */
		public static function show(x:Number, y:Number, background:String, content:String='', position:int=1, hideAfter:Number=3, callback:Function=null, parentSprite:Sprite=null, forceShow:Boolean=false, fontSize:int=20, bgAlign:int=-1):Prompt
		{
			var id:String=content ? content : background;
			var prompt:Prompt=promptDic[id + x + y];
			if (prompt && (prompt.x == x && prompt.y == y))
			{
				if (forceShow)
					prompt.playShow(hideAfter);
				return null;
			}
			if (!background)
				background="hint-bg";
			prompt=new Prompt(background, content, position, fontSize, bgAlign);
			prompt.callback=callback;
			prompt.x=x;
			prompt.y=y;
			prompt.id=id + x + y;
			var p:Sprite=parentSprite ? parentSprite : parent;
			p.addChild(prompt);
			promptDic[id + x + y]=prompt;
			prompt.playShow(hideAfter);
			return prompt;
		}

		/**
		 * 静态方法隐藏提示
		 * @param id 内容 ? 内容 : 背景
		 */
		public static function hide(id:String):void
		{
			var prompt:Prompt=promptDic[id];
			if (prompt)
				prompt.playHide();
		}

		private function getImage(name:String):Image
		{
			var t:Texture
			if (MC.assetManager)
				t=MC.assetManager.getTexture(name);
			if (t)
				return new Image(t);
			else
				return null;
		}

		public static function showIMG(_x:Number, _y:Number, _bg:Image, callback=null, parentSprite:Sprite=null):Prompt
		{
			var id:String="img";
			var prompt:Prompt=promptDic[id + _x + _y];
			if (prompt && (prompt.x == _x && prompt.y == _y))
				return null;
			prompt=new Prompt(_bg);
			prompt.callback=callback;
			prompt.x=_x;
			prompt.y=_y;
			prompt.id=id + _x + _y;
			var p:Sprite=parentSprite ? parentSprite : parent;
			p.addChild(prompt);
			promptDic[id + _x + _y]=prompt;
			prompt.playShow(3);
			return prompt;
		}
	}
}
