package views.global.books.userCenter.screen
{
	import com.greensock.TweenLite;
	
	import views.global.books.userCenter.UserCenter;

	public class DeveloperScreen extends BaseScreen
	{
		public function DeveloperScreen()
		{
			super();
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			
			
			TweenLite.delayedCall(0.1, dispatchEventWith, [UserCenter.Initialized]);
		}
	}
}