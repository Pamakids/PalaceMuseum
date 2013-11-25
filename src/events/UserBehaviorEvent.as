package events
{
	import starling.events.Event;

	public class UserBehaviorEvent extends Event
	{
		public static const USERBEHAVIOR:String="USERBEHAVIOR";

		public function UserBehaviorEvent(data:Object)
		{
			super(USERBEHAVIOR, true, data);
		}
	}
}

