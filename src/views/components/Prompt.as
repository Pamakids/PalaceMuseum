package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.utils.Dictionary;

	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 全局提示
	 * @author mani
	 */
	public class Prompt extends Sprite
	{
		private static var assetManagers:Array=[];
		public static var parent:Sprite;
		public static var promptDic:Dictionary=new Dictionary();

		public var callback:Function;

		public static function addAssetManager(am:AssetManager):void
		{
			if (am && assetManagers.indexOf(am) == -1)
				assetManagers.push(am);
		}

		public static function removeAssetManager(am:AssetManager):void
		{
			if (assetManagers.indexOf(am) != -1)
				assetManagers.splice(assetManagers.indexOf(am), 1);
		}

		public var id:String;

		private var label:TextField;

		public function Prompt(bg:String, content:String, algin:int=5, fontSize=20)
		{
			super();
			var bgImage:Image=getImage(bg);

			if (content)
			{
				var contentImage:Image=getImage(content);
				if (!contentImage)
				{
					var t:TextField=new TextField(bgImage.width - 30, bgImage.height - 10, content, FontVo.PALACE_FONT, fontSize, 0x561a1a, true);
					t.x=bgImage.x + 15;
					t.y=bgImage.y + 10;
					addChild(t);
					t.touchable=false;
					t.hAlign="center";
				}
				else
				{
					addChild(contentImage);
					contentImage.x=(bgImage.width - contentImage.width) / 2;
					contentImage.y=(bgImage.height - contentImage.height) / 2;
				}
			}

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

		public static function showTXT(_x:Number, _y:Number, _content:String, _size:int=20, callBack:Function=null, _parent:Sprite=null):Prompt
		{
			var bgSize:String=checkLength(_content.length)
			var bg:String="hint-bg" + bgSize;
			var delay:int=3 + Math.max(bgSize.length / 2 - 1, 0);
			return show(_x, _y, bg, _content, 1, delay, callBack, _parent, false, _size);
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
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
			{
				removeEventListener(TouchEvent.TOUCH, onTouch);
				playHide();
			}
		}

		private function get hideEffect():Object
		{
			return {scaleX: .1, scaleY: .1, alpha: 0, ease: Cubic.easeIn};
		}

		private function get showEffect():Object
		{
			return {scaleX: 1, scaleY: 1, ease: Elastic.easeOut};
		}

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

		public function playHide():void
		{
			if (!this.parent)
				return;
			TweenLite.killDelayedCallsTo(playHide);
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, hideEffect);
			TweenLite.killDelayedCallsTo(clearHandler);
			TweenLite.delayedCall(0.5, clearHandler, [this]);
		}

		private function clearHandler(p:Prompt):void
		{
			if (p.parent)
				p.parent.removeChild(p);
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
		public static function show(x:Number, y:Number, background:String, content:String='', position:int=5, hideAfter:Number=3, callback:Function=null, parentSprite:Sprite=null, forceShow:Boolean=false, fontSize:int=20):Prompt
		{
			var id:String=content ? content : background;
			var prompt:Prompt=promptDic[id + x + y];
//			if (prompt)
//				trace(id + x + y, prompt.x);
			if (prompt && (prompt.x == x && prompt.y == y))
			{
				if (forceShow)
					prompt.playShow(hideAfter);
				return null;
			}
			if (!background)
				background="hint-bg";
			prompt=new Prompt(background, content, position, fontSize);
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
			var texture:Texture;
			for each (var am:AssetManager in assetManagers)
			{
				texture=am.getTexture(name);
				if (texture)
					return new Image(texture);
			}
			return null;
		}

	}
}
