package views.util{
	
	import mx.collections.XMLListCollection;
	import mx.containers.VDividedBox;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.events.DataGridEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	
	public class MultiGrid extends VDividedBox{
		private var upperGrid:DataGrid;
		private var lowerGrid:DataGrid;
		private var myXML:XML;
		private var listXML:XMLListCollection;
		private var columnIndex:int = 0;
		private var l1:Label = new Label;
		private var l2:Label = new Label;
		private var master:Boolean = true;
		private var upperVBox:VBox = new VBox;
		private var lowerVBox:VBox = new VBox;
		
		public function MultiGrid():void{
			super();
			initializeComponent();
		}
		
		private function initializeComponent():void{
			l2.text = "Detalle:";
			l2.setStyle("fontSize",12);			
			l2.setStyle("fontWeight", "bold");
			upperVBox.percentWidth = 100;
			upperVBox.percentHeight = 100;
			lowerVBox.percentWidth = 100;
			lowerVBox.percentHeight = 100;
			upperVBox.minHeight = 100;
			lowerVBox.minHeight = 100;			
			CursorManager.setBusyCursor();
		}
		
		public function initDescriber(xml:XML):void{
			try{
				lowerVBox.removeAllChildren();
			}catch(e:Error){}
			
			lowerGrid.dataProvider = null;
			
			if(!xml.hasComplexContent()) lowerGrid = new DataGrid;
			else lowerGrid = dataLoaded(xml);	 
						
			//removeChildAt(3);
			//removeChildAt(2);
			removeChildAt(1);
			lowerGrid.percentWidth = 100;
			lowerGrid.percentHeight = 100;
			lowerGrid.draggableColumns = false;
			lowerGrid.sortableColumns = false;
			//addChild(lowerGrid);
			lowerVBox.addChild(l2);
			lowerVBox.addChild(lowerGrid);
			addChild(lowerVBox);
		}
				
		public function init(xml:XML):void{
			myXML = xml;
			try{
				this.removeAllChildren();
				upperVBox.removeAllChildren();
				lowerVBox.removeAllChildren()
			}catch(e:Error){}
			upperGrid = new DataGrid;
			lowerGrid = new DataGrid;
			upperGrid = dataLoaded(myXML);
			upperGrid.doubleClickEnabled = true;
			upperGrid.addEventListener(IndexChangedEvent.HEADER_SHIFT, function show(evt:IndexChangedEvent):void{
																		var columns:Object = Application.application.parameters.columnDef;
																		var oldColumn:Object = columns[evt.oldIndex];
																		var newColumn:Object = columns[evt.newIndex];
																		columns[evt.newIndex] = oldColumn;
																		columns[evt.oldIndex] = newColumn; 
																		Application.application.parameters.columnDef = columns;
																		});
																	
			upperGrid.addEventListener(ListEvent.ITEM_CLICK, function findDetail1(event:ListEvent):void{ 
																dispatchEvent(event);
																});
			upperGrid.draggableColumns = false;
			upperGrid.sortableColumns = false;
			upperGrid.percentWidth = 100;
			upperGrid.percentHeight = 100;
			lowerGrid.percentWidth = 100;
			lowerGrid.percentHeight = 100;
			//addChild(l1);
			//addChild(upperGrid);
			//addChild(l2);
			//addChild(lowerGrid);
			upperVBox.addChild(upperGrid);
			addChild(upperVBox);
			lowerVBox.addChild(l2);
			lowerVBox.addChild(lowerGrid);
			addChild(lowerVBox);
		}

		public function dataLoaded(xml:XML):DataGrid{
			var grid:DataGrid = new DataGrid;
			myXML = new XML(xml);
			listXML = new XMLListCollection(myXML.data.row);
            var aColumnDef:Array = getColumnDefArray();  
			var oColumnDef:Object;
			var dgc:DataGridColumn
			var aColumnsNew:Array = grid.columns
						
			for (var i:int=0;i<aColumnDef.length;i++)  {                 
				oColumnDef = aColumnDef[i];
				dgc = new DataGridColumn();
				dgc.headerText = oColumnDef.headerText;                              
				dgc.dataField = oColumnDef.dataField;
				dgc.labelFunction = setData;                        		
				dgc.sortable = true;
				dgc.visible = true;
      			dgc.wordWrap = true;
      			aColumnsNew.push(dgc)                                        
			}
			
			grid.allowMultipleSelection = true;
	    	grid.columns = aColumnsNew;
	    	grid.selectable = true;    
			grid.dataProvider = listXML;
			
			if (master){
				parentDocument.setColumnsObject(aColumnDef);
				master = !master;
			}			
            return grid;
        }
        
        private function setColumnIndex(event:DataGridEvent):void{
 			columnIndex = event.columnIndex.valueOf();
 		}
 	
        private function setData(item:XML, column:DataGridColumn):String{
	 		var o:Object = new Object;
	 		var l:Label = new Label;
	 		for (var i:int=0;i<item.children().length();i++){
	 			if(item.value.@column[i] == column.dataField)
	 				return item.value[i];
	 		}
	 		return ""; 
	 	}
	 	
	 	private function getColumnDefArray():Array{
			var aColumns:Array = new Array();
			var node0:XML = myXML.properties[0];     
			var xlColumns:XMLList = node0.children();
			var xmlColumn:XML
			var oColumnDef:Object;
			for (var i:int=0;i<xlColumns.length();i++)  {                    
				xmlColumn = xlColumns[i];
				oColumnDef = new Object();
				oColumnDef.dataField = xmlColumn.@id;
				oColumnDef.headerText = xmlColumn.name;  
				aColumns.push(oColumnDef);				
			}	
			return aColumns;
		}	
	
	}
}