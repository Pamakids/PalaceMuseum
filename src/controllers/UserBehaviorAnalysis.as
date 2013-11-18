package controllers
{
	import com.google.analytics.GATracker;
	import flash.display.DisplayObject;


	public class UserBehaviorAnalysis
	{
		public function UserBehaviorAnalysis()
		{
		}

		private static var tracker:GATracker;
		private static const GA_ID:String='UA-42208275-2';

		public static function init(stage:DisplayObject, debuge:Boolean=false):void
		{
			GATracker.autobuild=false;
			tracker=new GATracker(stage, GA_ID, 'AS3', debuge);
			GATracker(tracker).build();

//			UmengNativeExtension.manager.startWithAppKeyAndReportPolicyAndChannelId('51bd6e0e56240b684005468f', 0, '');
//			stage.addEventListener(MouseEvent.CLICK, clickHandler);

//			var o:Object=FileManager.readFile(Const.getPointsDataFilePath(DateUtil.getDateString()), false, false, true);
//			if (o)
//				cvo=CloneUtil.convertObject(o, ClickedPointsVO) as ClickedPointsVO;
//			else
//				cvo=new ClickedPointsVO();
//			UMeng.instance.init('51bd6e0e56240b684005468f', '91IOS');
//			UMSocial.instance.init('51bd6e0e56240b684005468f');
			UMeng.instance.init('52897e3b56240b9bf21d435e', '91');
			UMSocial.instance.init('52897e3b56240b9bf21d435e');
		}

//		protected static function clickHandler(event:MouseEvent):void
//		{
//			cvo.deviceID=DC.i.deviceID;
//			if (page)
//			{
//				var arr:Array=cvo.points[page];
//				if (!arr)
//				{
//					arr=[];
//					cvo.points[page]=arr;
//				}
//				var sn:Number=DPIUtil.getDPIScale();
//				arr.push([event.stageX / sn, event.stageY / sn]);
//			}
//		}

		private static var preTime:Number;
		private static var preHref:String;
//		private static var cvo:ClickedPointsVO;
		private static var page:String;

//		public static function trackPageview(href:String):void
//		{
//			page=href;
//			tracker.trackPageview(href);
//			if (!preTime)
//				preTime=getTimer();
//			preHref=href;
//			if (cvo)
//				FileManager.saveFile(Const.getPointsDataFilePath(DateUtil.getDateString()), cvo, true);
//		}

		public static function trackEvent(catetory:String, action:String, label:String='', value:int=0):void
		{
//			if (!PC.i.useByCreator)
//			{
			tracker.trackEvent(catetory, action, label, value);
//				UmengNativeExtension.manager.eventWithLabelAndAccumulation(catetory, action, value);
//			}
		}
	}
}
