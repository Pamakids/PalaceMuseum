package views.global.books.handbook.screen
{
	import com.greensock.TweenLite;
	
	import controllers.MC;
	
	import starling.display.Image;
	
	import views.components.ElasticButton;
	import views.global.books.events.BookEvent;
	import views.global.map.Map;
	import views.global.books.BooksManager;
	import views.global.books.userCenter.screen.BaseScreen;
	
	public class MapScreen extends BaseScreen
	{
		public function MapScreen()
		{
		}
		override protected function initialize():void
		{
			initPages();
			initImage();
			initButton();
			TweenLite.delayedCall( 0.1, dispatchEventWith, [BookEvent.InitViewPlayed] );
		}
		override protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_1");
			this.addChild( image );
		}
		
		private var btn:ElasticButton;
		private function initButton():void
		{
			btn=new ElasticButton(BooksManager.getImage("button_map"));
//			btn.shadow=UserCenterManager.getImage("button_map");
			addChild(btn);
			btn.x=(viewWidth>>1) - 12;
			btn.y=viewHeight>>1;
			btn.addEventListener(ElasticButton.CLICK, onTriggered);
		}
		
		private function onTriggered():void
		{
			Map.show(null,-1,-1,true, true);
			MC.instance.switchLayer(true);
		}
		
		private function initImage():void
		{
			var image:Image = BooksManager.getImage( "userCenter_bg" );
			image.x=185;
			image.y=293;
			this.addChild(image);
			image.touchable=false;
		}
		
		override public function dispose():void
		{
			if(btn)
				btn.removeFromParent( true );
			super.dispose();
		}
	}
}