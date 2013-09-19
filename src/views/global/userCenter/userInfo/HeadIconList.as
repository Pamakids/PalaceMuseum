package views.global.userCenter.userInfo
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;
	
	/**
	 * 头像列表
	 * @author Administrator
	 */	
	public class HeadIconList extends Sprite
	{
		public function HeadIconList()
		{
			initialize();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var X:Number = stage.stageWidth - this.width >> 1;
			var Y:Number = stage.stageHeight;
			
			var point:Point = this.parent.globalToLocal(new Point(X, Y));
			this.x = point.x;
			this.y = point.y;
			var target:Number = point.y + this.height;
			TweenLite.to(this, 0.8, {y:target, ease: Cubic.easeOut});
		}
		
		private var ts:Vector.<Texture>;			//头像纹理集
		private var icons:Vector.<HeadIcon>;		//头像集合
		private var background:Image;				//背景图片
		private var scroll:ScrollContainer;			//头像容器
		
		private function initialize():void
		{
			initBackground();
			initLayout();
			initScroll();
			initHeadicons();
		}
		
		private function initScroll():void
		{
			scroll = new ScrollContainer();
			this.addChild( scroll );
			scroll.width = 300;
			scroll.height = 80;
			scroll.x = 40;
			scroll.y = 40;
			scroll.layout = layout;
			scroll.clipContent = true;
		}
		
		private function initBackground():void
		{
			background = new Image(UserCenterManager.getTexture(""));
			this.addChild( background );
			background.touchable = false;
		}
		
		private function initHeadicons():void
		{
			var head:HeadIcon;
			var bgTexture:Texture = UserCenterManager.getTexture("");
			ts = UserCenterManager.getAssetsManager().getTextures("icon_head_");
			var max:int = ts.length;
			icons = new Vector.<HeadIcon>(max);
			
			for(var i:int = 0; i<max; i++)
			{
				head = new HeadIcon(80,80);
				head.id = String(i+1);
				head.icon = ts[i];
				head.background = new Scale9Textures(bgTexture, new Rectangle());
				head.touchable = true;
				head.addEventListener(HeadIcon.SECLECTED, changeIcon);
				
				scroll.addChild( head );
				icons[i] = head;
			}
		}
		
		private function changeIcon(e:Event):void
		{
			trace(e.data);
		}
		
		private var layout:HorizontalLayout;
		private function initLayout():void
		{
			layout = new HorizontalLayout();
//			layout.paddingTop = 90;
//			layout.paddingLeft = 10;
			layout.useVirtualLayout = true;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
		}
		
		override public function dispose():void
		{
			background.dispose();
			background = null;
			scroll.removeChildren();
			for each(var head:HeadIcon in icons)
			{
				head.removeEventListener(HeadIcon.SECLECTED, changeIcon);
				head.dispose();
			}
			icons = null;
			ts = null;
			super.dispose();
		}
	}
}