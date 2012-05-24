package views.util{

	import flash.events.Event;
	 
	public class ReportManagerEvent extends Event{
	
		public static const UPDATE:String = "UPDATE";
		public static const SELECT_DATE:String = "SELECT_DATE";
		public var data:Object = new Object();
		
		public function ReportManagerEvent (type:String, _data:Object){
			super(type);
			data = _data;
		}
		override public function clone():Event {
           return new ReportManagerEvent(type, data);
        }
	}
}