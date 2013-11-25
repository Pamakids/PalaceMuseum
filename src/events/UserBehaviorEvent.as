package events
{
	import starling.events.Event;

	public class UserBehaviorEvent extends Event
	{
		public static const USERBEHAVIOR:String="USERBEHAVIOR";

		public function UserBehaviorEvent(catetory:String, action:String, label:String='', value:int=0)
		{
			super(USERBEHAVIOR, true, {"catetory": catetory, "action": action, "label": label, "value": value});
		}
	}
}

