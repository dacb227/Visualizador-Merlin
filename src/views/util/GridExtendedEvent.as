package views.util{

	import flash.events.Event;
	/**
	 * Custom event dispatched by the extended DataGrid component.
	 */
	 
	public class GridExtendedEvent extends Event{
	
		public static const OUT_OF_RANGE:String = "out_of_range";
		public static const CURSOR_MAXED:String = "cursor_maxed";
		public static const SORT:String = "sort";
		public var data:Object = new Object();
		public function GridExtendedEvent (type:String, _data:Object){
			super(type);
			data = _data;
		}
		override public function clone():Event {
           return new GridExtendedEvent(type, data);
        }
	}
}