package views.util{
	
	import mx.charts.HitData;
	import mx.charts.Legend;
	import mx.charts.PieChart;
	import mx.charts.effects.SeriesInterpolate;
	import mx.charts.series.PieSeries;
	import mx.charts.series.items.PieSeriesItem;
	import mx.collections.XMLListCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.effects.easing.Elastic;
	import mx.managers.CursorManager;
	
	public class PieExtended extends VBox{
		
		private var initial:Boolean = true;
		private var listXML:XMLListCollection;
		private var piechart:PieChart = new PieChart;
		private var legend:Legend = new Legend;
		private var text:Text = new Text;
		private var myXML:XML;
		private var hBox:HBox = new HBox;
		[Bindable]private var total:int = 0;
		
		public function PieExtended(){
			super();
			
			this.percentHeight = 100;
			this.percentWidth = 100;
			this.setStyle("verticalAlign", "middle");
			this.setStyle("horizontalAlign", "center");
			hBox.percentHeight = 100;
			hBox.percentWidth = 100;
			hBox.setStyle("verticalAlign", "middle");
			hBox.setStyle("horizontalAlign", "center");
			
			text.setStyle("color", "#0B438E");
			text.setStyle("fontSize", "14");
			text.setStyle("fontWeight", "bold");
			this.addChild(text);
			
			piechart.percentHeight=100;		
			piechart.percentWidth=100;
			hBox.addChild(piechart);

			legend.width=200;
			legend.dataProvider=piechart;
			hBox.addChild(legend);
			
			this.addChild(hBox);
			CursorManager.setBusyCursor();		
		}
		
		public function dataLoaded(xml:XML):void{
			var mySeries:Array = new Array;
			var pieSeries:PieSeries = new PieSeries;
			myXML = new XML(xml);
            listXML = new XMLListCollection(myXML.data.row);
			total=0;
			
	        pieSeries.dataFunction = setData;
	        pieSeries.labelFunction = setLabelFunc;
	       	pieSeries.setStyle("labelPosition", "callout");
	       	pieSeries.nameField="*";
	       	
			var rotate:SeriesInterpolate = new SeriesInterpolate;
			rotate.duration = 1500;
			rotate.easingFunction = Elastic.easeOut;
			
			pieSeries.setStyle("showDataEffect", rotate);
	        piechart.dataTipFunction = setDataTip;
	        piechart.series = [pieSeries];     
			piechart.showDataTips = true;
            piechart.dataProvider = listXML;
        	CursorManager.removeBusyCursor();
  		}
    	
  		private function setDataTip(item:HitData):String {
        	var pSI:PieSeriesItem = item.chartItem as PieSeriesItem;
        	return  "Numero : "+pSI.item.value.@count;
        }
        
        private function setLabelFunc(item:Object, field:String, index:Number, percentValue:Number):String {
	       	return item.value.@count + " (" + percentValue.toFixed(1) + "%)";
        }
  		  		
        private function setData(series:PieSeries, item:Object, fieldName:String):Object{
        	this.total += int(item.value.@count);
        	text.text = myXML.data.@title+" : Total Registros "+int(this.total);
	 		return item.value.@count; 
	 	}
		
	}
}