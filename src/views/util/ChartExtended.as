package views.util{
	
	import mx.charts.CategoryAxis;
	import mx.charts.ColumnChart;
	import mx.charts.chartClasses.Series;
	import mx.collections.XMLListCollection;
	import mx.managers.CursorManager;
	
	public class ChartExtended extends ColumnChart{
		
		private var initial:Boolean = true;
		private var listXML:XMLListCollection;
		private var myXML:XML;
		public var total:Number = 0;
		
		public function ChartExtended(){
			super();
			CursorManager.setBusyCursor();
		}
		
		public function dataLoaded(xml:XML):void{
            myXML = new XML(xml);
			listXML = new XMLListCollection(myXML.data.row);
			
			dataProvider(listXML);
			var ca:CategoryAxis = new CategoryAxis();
			ca.categoryField= "@id";
			ca.dataProvider(listXML);
			
			
			//this.horizontalAxis 
			
            
            /*if(initial){
                initial = true;
                var mySeries:Array = new Array;
                var hAxis:CategoryAxis = new CategoryAxis;
                var vAxis:CategoryAxis = new CategoryAxis;  
                var seriesNew:Array = new Array; 
		         
		      	mySeries = getSeriesDefArray();
		      
		        hAxis.title = mySeries[1].displayName;
		        hAxis.displayName = mySeries[1].labelField;
                hAxis.dataFunction = setLabel;
		        hAxis.dataProvider = listXML;
		        
		        var columnS:ColumnSeries = new ColumnSeries;
		        
		        columnS.id = mySeries[0].labelField;
		        //columnS.xField = mySeries[0].labelField;
		        columnS.displayName = mySeries[0].displayName;
				columnS.dataFunction = setData;		        

		        horizontalAxis = hAxis;
		     
		        seriesNew.push(columnS);
		        this.series = seriesNew;    
				showDataTips = true;
                dataProvider = listXML; 
               
        	}*/
        	CursorManager.removeBusyCursor();
  		}
  		
  		private function setLabel(axis:CategoryAxis, item:Object):Object{
  			for (var i:int=0;i<item.children().length();i++){
  				if(item.value.@column[i] == axis.displayName){	 			
	 				return item.value[i];
	 			}
	 		}
  			return null;
  		}
  		
        private function setData(series:Series, item:Object, fieldName:String):Object{
	 		
	 		for (var i:int=0;i<item.children().length();i++){
	 			if(fieldName == "xValue"){
	 				if(series.id != item.value.@column[i]){
	 					return item.value[i];
	 				}
	 			}
	 			
	 			if(fieldName == "yValue"){
	 				if(series.id == item.value.@column[i]){
	 					return item.value[i];
	 				}
	 			}
	 		}
	 		return null; 
	 	}
	 	
        private function getSeriesDefArray():Array{
			var mySeries:Array = new Array();
			var node0:XML = myXML.properties[0];     
			var xlSeries:XMLList = node0.children();
			var xmlSeries:XML
			var seriesDef:Object;
			for (var i:int=0; i<xlSeries.length(); i++)  {                    
				xmlSeries = xlSeries[i];
				seriesDef = new Object();
				seriesDef.labelField = xmlSeries.@id;
				seriesDef.displayName = xmlSeries.name;  
				mySeries.push(seriesDef);
			}
			return mySeries;                                                    
		}		
        
	
		
	}
}