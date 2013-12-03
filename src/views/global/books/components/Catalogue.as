package views.global.books.components
{
	import controllers.MC;
	
	import feathers.controls.List;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import views.components.ElasticButton;
	import views.global.books.BooksManager;

	/**
	 * 目录
	 * @author Administrator
	 */	
	public class Catalogue extends Sprite
	{
		public function Catalogue()
		{
			parseJson();
			init();
		}
		
		private var crtIndex:uint = 0;
		private function parseJson():void
		{
			var obj:Object = BooksManager.getAssetsManager().getObject("catalogue");
			trace(obj);
		}
		private var list:List;
		
		private function init():void
		{
			initBG();
			initBackButton();
		}
		
		private var backBtn:ElasticButton;
		private function initBackButton():void
		{
			backBtn=new ElasticButton(new Image(MC.assetManager.getTexture("button_close")));
			backBtn.shadow=new Image(MC.assetManager.getTexture("button_close_down"));
			addChild(backBtn);
			backBtn.x=660;
			backBtn.y=30;
			backBtn.addEventListener(ElasticButton.CLICK, onTriggered);
		}
		
		private function onTriggered():void
		{
		}
		
		private function initBG():void
		{
			var image:Image = BooksManager.getImage("catalogue_bg");
			this.addChild( image );
			image.touchable = false;
		}
	}
}