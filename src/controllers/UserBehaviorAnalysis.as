package controllers
{
	import flash.system.Capabilities;

	import eu.alebianco.air.extensions.analytics.Analytics;
	import eu.alebianco.air.extensions.analytics.api.ITracker;


	public class UserBehaviorAnalysis
	{
		public function UserBehaviorAnalysis()
		{
		}

		public static var tracker:ITracker;
		public static var UID:String;
		private static const GA_ID:String='UA-46023848-1';

		public static function init():void
		{
			UMeng.instance.init("52897e3b56240b9bf21d435e", "Appstore", Capabilities.isDebugger);
			UID=UMeng.instance.getUDID();
			var analytics:Analytics=Analytics.getInstance();
			tracker=analytics.getTracker(GA_ID);
			trackEvent("login", "user", UID);
		}

		public static function trackEvent(catetory:String, action:String, label:String='', value:int=0):void
		{
			if (!label)
				tracker.buildEvent(catetory, action).track();
			else if (!value)
				tracker.buildEvent(catetory, action).withValue(value).track();
			else
				tracker.buildEvent(catetory, action).withLabel(label).withValue(value).track();
		}
	}
}
