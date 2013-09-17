package views.global.userCenter.handbook
{
	import feathers.controls.Screen;

	import starling.events.Event;
	import starling.textures.Texture;

	import views.components.SoftPageAnimation;
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 */
	public class HandbookScreen extends Screen implements IUserCenterScreen
	{
		public static const SCREEN_TEXTURES_CHENGED:String="screen_textures_changed";

		public function HandbookScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			initAnimation();
		}


		override public function dispose():void
		{
			if (animation)
			{
				animation.removeEventListener(SoftPageAnimation.PAGE_UP, turnPage);
				animation.removeEventListener(SoftPageAnimation.PAGE_DOWN, turnPage);
				animation.dispose();
			}
			super.dispose();
		}


		private var animation:SoftPageAnimation;

		private function initAnimation():void
		{
			animation=new SoftPageAnimation(width, height, vecTextures, 0, false, 0.5);
			this.addChild(animation);

			animation.addEventListener(SoftPageAnimation.PAGE_UP, turnPage);
			animation.addEventListener(SoftPageAnimation.PAGE_DOWN, turnPage);
		}


		private function turnPage(e:Event):void
		{
		}

		private const vecTextures:Vector.<Texture>=UserCenterManager.getHandbookTextures();

		/**
		 * 获取该场景纹理
		 */
		public function getScreenTexture():Vector.<Texture>
		{
			var ts:Vector.<Texture>=new Vector.<Texture>(2);
			if (animation)
				ts=UserCenterManager.getHandbookTextures().slice(animation.currentPage * 2, (animation.currentPage + 1) * 2);
			else
				ts=UserCenterManager.getHandbookTextures().slice(0, 2);
			return ts;
		}

		public var viewWidth:Number;
		public var viewHeight:Number;

		public function turnToPage(index:int):void
		{
			this.animation.buttonCallBackMode=true;
			this.animation.addEventListener(SoftPageAnimation.ANIMATION_COMPLETED, onComplete);
			this.animation.turnToPage(index);
		}

		private function onComplete():void
		{
			trace(animation.currentPage);
			this.animation.buttonCallBackMode=false;
			this.animation.removeEventListener(Event.COMPLETE, onComplete);
		}

	}
}
