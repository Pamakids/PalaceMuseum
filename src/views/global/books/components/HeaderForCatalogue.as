package views.global.books.components
{
	import feathers.controls.Button;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import views.global.books.BooksManager;
	
	public class HeaderForCatalogue extends Sprite
	{
		public function HeaderForCatalogue()
		{
			init();
		}
		
		private var textField:TextField;
		private var icon:Image;
		private var button:Button;

		public function set label(_label:String):void
		{
			textField.text = _label;
		}
		private function init():void
		{
			initBG();
			initLable();
			initIcon();
		}
		
		
		private function initIcon():void
		{
			icon = BooksManager.getImage("small_title_up");
			this.addChild( icon );
			icon.touchable = false;
			icon.pivotX = icon.width >> 1;
			icon.pivotY = icon.height >> 1;
			icon.x = 360;
			icon.y = 35;
		}
		
		private function initBG():void
		{
			
			button = new Button();
			button.defaultSkin = BooksManager.getImage("catalogue_bg_header");
			this.addChild( button );
			button.addEventListener(Event.TRIGGERED, ontriggered);
		}
		
		private function ontriggered():void
		{
			dispatchEvent( new Event( Event.TRIGGERED ) );
		}
		
		private function initLable():void
		{
			textField = new TextField(200, 40, "晨起", FontVo.PALACE_FONT, 32, 0x336699);
			this.addChild( textField );
			textField.touchable = false;
			textField.hAlign = "left";
			textField.x = 25;
			textField.y = 12;
		}
		
		override public function dispose():void
		{
			if(button)
				button.removeFromParent(true);
			if(textField)
				textField.removeFromParent(true);
			if(icon)
				icon.removeFromParent(true);
			super.dispose();
		}
		
		public function setSelected(boo:Boolean):void
		{
			icon.texture = boo ? BooksManager.getTexture("small_title_down") : BooksManager.getTexture("small_title_up");
		}
	}
}