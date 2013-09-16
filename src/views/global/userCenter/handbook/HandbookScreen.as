package views.global.userCenter.handbook
{
	import flash.geom.Rectangle;

	import feathers.controls.Screen;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	import views.components.SoftPageAnimation;
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenter;
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
			leftBack=new Image(UserCenterManager.getTexture("page_left"));
			rightBack=new Image(UserCenterManager.getTexture("page_right"));
			leftBack.width=rightBack.width=width / 2;
			initUserInfo();
			initAnimation();
		}

		/**
		 * 获取用户数据
		 */
		private function initUserInfo():void
		{
		}
		private var userinfo:Object;
		private var leftBack:Image;
		private var rightBack:Image;

		override public function dispose():void
		{
			if (animation)
			{
				animation.removeEventListener(SoftPageAnimation.PAGE_UP, turnPage);
				animation.removeEventListener(SoftPageAnimation.PAGE_DOWN, turnPage);
				animation.dispose();
			}
			if (leftBack)
				leftBack.dispose();
			if (rightBack)
				rightBack.dispose();
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
//			trace(animation.currentPage);
		}

		private var vecTextures:Vector.<Texture>=UserCenterManager.getHandbookTextures();

		/**
		 * 获取该场景纹理
		 */
		public function getScreenTexture():Vector.<Texture>
		{
			initScreenTexture();
			return UserCenterManager.getScreenTexture(UserCenter.HANDBOOK);
		}

		private function initScreenTexture():void
		{
			//			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			//			render.draw( this );
			//			ts[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			//			ts[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			var ts:Vector.<Texture>=new Vector.<Texture>(2);
			var textL:Texture;
			var textR:Texture;
			if (animation)
			{
				textL=vecTextures[this.animation.currentPage * 2];
				textR=vecTextures[this.animation.currentPage * 2 + 1];
			}
			else
			{
				textL=vecTextures[0];
				textR=vecTextures[1];
			}
			ts[0]=Texture.fromTexture(textL, new Rectangle(0, 0, textL.width, textL.height));
			ts[1]=Texture.fromTexture(textR, new Rectangle(0, 0, textR.width, textR.height));
			UserCenterManager.setScreenTextures(UserCenter.HANDBOOK, ts);
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
