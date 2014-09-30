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
			initButton();
			TweenLite.delayedCall( 0.1, dispatchEventWith, [BookEvent.InitViewPlayed] );
		}
		override protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_0");
			image.scaleX=image.scaleY=2;
			this.addChild( image );
			image.height += 6;
		}

		private var btn:ElasticButton;
		private function initButton():void
		{
			btn=new ElasticButton(BooksManager.getImage("button_map"));
			addChild(btn);
			btn.x=(viewWidth>>1) - 12;
			btn.y=viewHeight>>1;
			btn.addEventListener(ElasticButton.CLICK, onTriggered);
		}

		private function onTriggered():void
		{
			Map.loadMapAssets(function():void{
				Map.show(-1,-1,true, true);
			},false,true);
//			Map.show(null,-1,-1,true, true);
//			MC.instance.switchLayer(true);
		}

		override public function dispose():void
		{
			if(btn)
				btn.removeFromParent( true );
			super.dispose();
		}
	}
}

