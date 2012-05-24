package views.util{	

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.core.EventPriority;
	import mx.core.FlexSprite;
	import mx.core.IFactory;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	import mx.managers.CursorManager;
	
	import views.LinkItemRenderer;
	import views.MusicPlayerRenderer;
	
	/**
	 * Extended DataGrid control that allows front loading of data making it 
	 * possible to do implicit data scrolling without using Flex Data Services.
	 * <p>
	 * The extension's main purpose is to handle the indexing of missing data by using 
	 * a wrapped and manipulated dataProvider object.
	 * </p>
	 * This class keeps track of empty row elements details such as the row index, content
	 * and dataType.
	 * <p>
	 * It also doesn't get in the way of the original functionality  of the Flex DataGrid.
	 * </p>
	 */
	public class GridPlayerExtended extends DataGrid{
	
		/**
		 * A copy of the sortArrow object being used by the DataGrid header
		 * for displaying the asc/desc arrow when sorting
		 */
		 
		private var sortArrow:IFlexDisplayObject;
		private var sortIndex:Number = -1;
		private var lastSortIndex:Number = -1;
		private var viewCount:Number;
		private var currentScrollPos:Number;
		protected var collectionMirror:ValueListHandler;
		private var cTotal:Number = 0;
		private var appendResolved:Boolean = true;
		private var lastScrollPosition:Number = 0;
		private var accurateScrollPosition:Number = 0;
		private var data_complete:Boolean = false;
		private var lastValidRendererIndex:Number;
		private var currentSort:String = "ASC";
		private var scrollInter:Number;
		private var currentField:String = "";
		private var fromSort:Boolean = false;
		private var _delay:Number = 300;
		private var columnID:String;
		
		private var columnIndex:int = 0;
		private var initial:Boolean = true;
		private var listXML:XMLListCollection;
		private var myXML:XML;
		private var link:LinkItemRenderer;
		
		private var copyContextItem:ContextMenuItem;
		private var headerString : String = '';
		private var dataToCopy:String = '';
		private var idTable:String = '';
		private var player:MusicPlayerRenderer;
		
		//public var TotalWidth:int;
		
		function GridPlayerExtended():void{
			super();
			initializeComponent();			
		}
		/** Initialize events to listen to and create the 
		 * dataProvider wrapper object.
		 */
		 
		private function initializeComponent():void{
			player = new MusicPlayerRenderer;	
			
			addEventListener(ScrollEvent.SCROLL, scrollListener);
			addEventListener(DataGridEvent.HEADER_RELEASE, gridHeaderReleased);
			//addEventListener(ListEvent.ITEM_CLICK, openURL);
			//addEventListener(ListEvent.ITEM_FOCUS_IN, showLink);

			contextMenu = new ContextMenu();
			initContextMenu();
			addEventListener(ListEvent.ITEM_CLICK, itemClickHandler, false, EventPriority.DEFAULT_HANDLER);

			
			CursorManager.setBusyCursor();		
            //addEventListener(GridExtendedEvent.SORT, dataSort);
			addEventListener(IndexChangedEvent.HEADER_SHIFT, gridColumnShift);
			collectionMirror = new ValueListHandler();
			
		}
		
		/*
        private function dataSort(evt:GridExtendedEvent):void{
			loadRecords({startindex:evt.data.start, size:recordSize, field:evt.data.field});
			CursorManager.setBusyCursor(); 
		}
		*/
		
		private function initContextMenu():void{
			copyContextItem = new ContextMenuItem("Copiar");
			copyContextItem.enabled = false;
			//copyContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,copyDataHandler);
			copyContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function dispatch():void{ 
				parentDocument.dispatchEvent(new ContextMenuEvent(ContextMenuEvent.MENU_ITEM_SELECT, true, false));
			});
			contextMenu.customItems.push(copyContextItem);
			// comment the following line if you want default items in context menu.
			contextMenu.hideBuiltInItems();									
		}
		
		
		private function copyDataHandler(event:Event):void{
			dataToCopy = '';
			if(selectedItems != null){
				 dataToCopy = getSelectedRowsData();
				 dataToCopy = ((headerString == '') ? getHeaderData() : headerString)+"\n" + dataToCopy;				
				 copyContextItem.enabled = true;
				 System.setClipboard(dataToCopy);
			}  			
		}
		
		private function handleAlertClose(event:CloseEvent):void{
			//trace("handling .. the event");
			if(event.detail == 1)
			{		
			  	 
			}
			 
		}
		private function getHeaderData():String{		 
			   headerString = '';		
					for(var j:int = 0; j< columnCount; j++){
						if((columns[j] as DataGridColumn).visible)
							headerString += (columns[j] as DataGridColumn).headerText +"\t";
					}
		 		return headerString;	 	
		}	
		
		private function getSelectedRowsData():String{
			var rowsData : String = '';
			var tempxml:XML;
			var tempxmllist:XMLListCollection;
			//for(var i:int =0;i<selectedItems.length;i++) {
			for(var i:int = selectedItems.length-1 ;i>=0;i--) {
				//Alert.show(selectedItems[i].toString());
				for(var j:int = 0; j< columnCount; j++){
					if((columns[j] as DataGridColumn).visible)
						
						tempxml = new XML(selectedItems[i]);
						 
						//Alert.show("tempxml\n"+tempxml.value.@column[(columns[j] as DataGridColumn).dataField]);
						tempxmllist = new XMLListCollection(tempxml.children());
						//Alert.show("tempxmllist\n"+tempxmllist.toString());
						
						
						//tempxmllist = new XMLListCollection(tempxml);
						//Alert.show(tempxmllist.toXMLString());
						
						//rowsData += selectedItems[i][(columns[j] as DataGridColumn).dataField] +"\t";
						if( (columns[j] as DataGridColumn).dataField ==  tempxml.value.@column[j] )
						rowsData += tempxml.value[j] +"\t";
				}
				rowsData+= "\n";							 
			}
			return rowsData;
		}
		
		private function itemClickHandler(event:ListEvent):void
	    {
	    	copyContextItem.enabled = true;
	    }	
		
		public function openURL(event:ListEvent):void{
			var row:int = event.rowIndex;
			var col:int = event.columnIndex;
			var address:String = listXML[row].value[col].toString();
			//cambiar para la columna id de la tabla
			idTable = listXML[row].value[10].toString();
			Application.application.parameters.idTable = idTable; 
			if(address.substring(0,4) == "http"){
				var url:URLRequest = new URLRequest(address);
				navigateToURL(url,"_bank");		
				dispatchEvent(new Event(Event.SOUND_COMPLETE, true, false));
			}
		}
		
        public function dataLoaded(xml:XML):void{
			myXML = new XML(xml);
			listXML = new XMLListCollection(myXML.data.row);
			
            if(initial){
                initial = false;                   
                var aColumnDef:Array = getColumnDefArray();                  
				var oColumnDef:Object;
				var dgc:DataGridColumn;
				var aColumnsNew:Array = columns
				
				for (var i:int=0;i<aColumnDef.length;i++)  {                 
					oColumnDef = aColumnDef[i];
					dgc = new DataGridColumn();
					dgc.headerText = oColumnDef.headerText;
					if(oColumnDef.headerText.toString() === "ESCUCHAR"){
						dgc.itemRenderer = new ClassFactory(MusicPlayerRenderer);
					}					
					dgc.dataField = oColumnDef.dataField;
					dgc.labelFunction = setData;                        
					//dgc.width = oColumnDef.width;
					
					dgc.visible = true;
	      			dgc.wordWrap = true;
	      			aColumnsNew.push(dgc)                                        
				}
				allowMultipleSelection = false;
		    	columns = aColumnsNew;
		    	selectable = true;    
		    	//addEventListener("headerRelease", setColumnIndex); 
				//width = TotalWidth;
				dataProvider = listXML;
				draggableColumns = false;
				sortableColumns = false;
				//parentDocument.resizeDataGridColumns(new DataGridEvent("COLUMN_STRECH"));
            }else{
            	//Alert.show(listXML.toXMLString());
                dataProvider = listXML;
                appendData(listXML);
            }
            CursorManager.removeBusyCursor();
        }
        
       
        
        private function setColumnIndex(event:DataGridEvent):void{
 			columnIndex = event.columnIndex.valueOf();
 		}
 	
        private function setData(item:XML, column:DataGridColumn):String{
	 		var o:Object = new Object;
	 		for (var i:int=0;i<item.children().length();i++){
	 			if(item.value.@column[i] == column.dataField){
	 				if(item.value[i].toString().substring(0,4) == "http"){
	 					return "ESCUCHAR";
	 				}
	 				return item.value[i];
	 			}
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
				//oColumnDef.width = TotalWidth/xlColumns.length();
				aColumns.push(oColumnDef);
			}
			
			return aColumns;                                                    
		}		
		
		
		/**
		 * Checks the collectionMirror object if the rows being displayed contains empty or null values.
		 * If the rows are empty it will dispatch and "out_of_range" event to its listener crying for help to 
		 * populate its empty rows.
		 * <p>
		 * Event details (GridExtendedEvent) contains the following data:
		 * <ul>
		 * <li>start - the current top row being displayed by the DataGrid.</li>
		 * <li>sortType - if "ASC" or "DESC"</li>
		 * <li>field - the dataField being sorted</li>
		 * </ul>
		 * </p>
		 */
		private function handleScrollRange(range:Number, down:Boolean):void{
			clearInterval(scrollInter);
			var realIndex:Number;
			try{
				realIndex = collectionMirror.rangeIsValid(range, rowCount)
				if(realIndex != -1){
					if(appendResolved){
						appendResolved = false;
						lastScrollPosition = realIndex;
						
						dispatchEvent(new GridExtendedEvent(GridExtendedEvent.OUT_OF_RANGE, {start:realIndex, field:currentField}));
					}
				}
			}catch(e:Error){
				//now what?
			}

		}
		/** 
		 * GridHeader release/click listener. If the DataGrid is set for implicit scrolling
		 * (determined by the value of cTotal), it will handle the event and dispatches a new event that notifies
		 * the listeners that it needs to be sorted.
		 * <p>
		 * Event details (GridExtendedEvent) contains the following data:
		 * <ul>
		 * <li>start - the current top row being displayed by the DataGrid.</li>
		 * <li>sortType - if "ASC" or "DESC"</li>
		 * <li>field - the dataField being sorted</li>
		 * </ul>
		 * </p>
		 */
		private var sortColumn:DataGridColumn;
		private var sortDirection:String;
		 
		private function gridHeaderReleased(evt:DataGridEvent):void{
			columnID = evt.dataField;
			if(cTotal != 0){
				evt.preventDefault();
				
				fromSort = true;
				currentSort = (currentSort == "ASC") ? "DESC" : "ASC";
				currentField = evt.dataField;		
				var actColumn:DataGridColumn = columns[evt.columnIndex];				
				lastSortIndex = sortIndex;
				sortIndex = evt.columnIndex;
				cheatSortArrow(actColumn, sortIndex);							
				dispatchEvent(new GridExtendedEvent(GridExtendedEvent.SORT, {start:accurateScrollPosition, sortType:currentSort, field:currentField}));
				if(appendResolved){
					appendResolved = false;
				}
			}
		}
		
		
		/**
		 * Repositions that damn sortArrow display when moving columns around.
		 */

		private function gridColumnShift(evt:IndexChangedEvent):void{
			sortIndex = evt.newIndex;
			lastSortIndex = evt.oldIndex;
			cheatSortArrow(evt.target as DataGridColumn, sortIndex);
		} 
		
		/**
		 * The function that handles the delay when calling the handleScrollRange which checks 
		 * if there are empty rows currently displayed.
		 * It also tracks the current scroll position of the scrollbar.
		 * 
		 */
		private function scrollListener(evt:ScrollEvent):void{
			if(cTotal){
				if(collectionMirror.length < cTotal){
					clearInterval(scrollInter);
					scrollInter = setInterval(handleScrollRange, _delay, evt.position, evt.delta > 0);
				}
			}
			accurateScrollPosition = evt.position;
		}
		/**
		* Sets the targetted total number of records to be displayed by the DataGrid. This number is 
		* used by the collectionMirror object to determine the total number of record to frontload and fill up
		* with null values to cheat the DataGrid that he needs to scroll the specified number of data.
		* 
		*
		*/
		public function set collectionLength(n:Number):void{
			cTotal = n;
		}
		public function get collectionLength():Number{
			return cTotal;
		}
		/**
		 * Appends data to the collectionMirror object based on the last row index 
		 * detected to have null value.
		 * If the DataGrid previously dispatched a "sort" event, it will pass thru a different function
		 * which calls the collectionMirror method for appending data after a sort procedure.
		 */
		public function appendData(value:Object):void{
			appendResolved = true;
			
				collectionMirror.updateCollectionElements(value, lastScrollPosition);
				/**
				 * Check again if there are empty rows left.
				 */
				clearInterval(scrollInter);
				scrollInter = setInterval(handleScrollRange, _delay, accurateScrollPosition, false);
				
		
		}
		/**
		 * Appends the data to the collectionMirror object after a sort process.
		 */

		/**
		 * Overrides the setting of the dataProvider being used and copied into the 
		 * collectionMirror object.
		*/
		
		override public function set dataProvider(value:Object):void{
			super.dataProvider = collectionMirror.setReference(value, cTotal);
		}
		
		/** 
		 * Overrides that damn arrow display being used when sorting 
		 * a column in the DataGrid.
		 */
		private function cheatSortArrow(activeColumn:DataGridColumn, activeIndex:Number):void{
			var sortArrowHitArea:Sprite =
            Sprite(listContent.getChildByName("sortArrowHitArea"));

	        if (!sortArrow){
	            var sortArrowClass:Class = getStyle("sortArrowSkin");
	            sortArrow = new sortArrowClass();
	            DisplayObject(sortArrow).name = "sortArrow";
	            listContent.addChild(DisplayObject(sortArrow));
	        }
	        
	        var xx:Number;
	        var n:int;
	        var i:int;
	        if (listItems && listItems.length && listItems[0]){
	            n = listItems[0].length;
	            for (i = 0; i < n; i++){
	                if (i == sortIndex){
	                    xx = listItems[0][i].x + columns[i].width;
	                    listItems[0][i].setActualSize(columns[i].width - sortArrow.measuredWidth - 8, listItems[0][i].height);
	
	                    if (!isNaN(listItems[0][i].explicitWidth)){
	                        listItems[0][i].explicitWidth = listItems[0][i].width;
	                    }
	
	                    // Create hit area to capture mouse clicks behind arrow.
	                    if (!sortArrowHitArea){
	                        sortArrowHitArea = new FlexSprite();
	                        sortArrowHitArea.name = "sortArrowHitArea";
	                        listContent.addChild(sortArrowHitArea);
	                    }else{
	                        sortArrowHitArea.visible = true;
	                    }
	
	                    sortArrowHitArea.x = listItems[0][i].x + listItems[0][i].width;
	                    sortArrowHitArea.y = listItems[0][i].y;
	
	                    var g:Graphics = sortArrowHitArea.graphics;
	                    g.clear();
	                    g.beginFill(0, 0);
	                    g.drawRect(0, 0, sortArrow.measuredWidth + 8,
	                            listItems[0][i].height);
	                    g.endFill();
	
	                    break;
	                }
	            }
	        }
	        if (isNaN(xx)){
	            sortArrow.visible = false;
	            return;
	        }
	        sortArrow.visible = true;
	        if (lastSortIndex >= 0 && lastSortIndex != sortIndex){
	            if (activeIndex <= lastSortIndex && lastSortIndex <= columns.length - 1){
	                n = listItems[0].length;
	                for (var j:int = 0; j < n ; j++){
	                    if (j == lastSortIndex){
	                        listItems[0][j].setActualSize(columns[j].width, listItems[0][j].height);
	                        break;
	                    }
	                }
	            }
	        }
	        var d:Boolean = (currentSort == "ASC");
	        sortArrow.width = sortArrow.measuredWidth;
	        sortArrow.height = sortArrow.measuredHeight;
	        DisplayObject(sortArrow).scaleY = (d) ? -1.0 : 1.0;
	        sortArrow.x = xx - sortArrow.measuredWidth - 8;
	        var hh:Number = rowInfo.length ? rowInfo[0].height : headerHeight
	        sortArrow.y = (hh - sortArrow.measuredHeight) / 2 + ((d) ? sortArrow.measuredHeight: 0);
	
	        if (sortArrow.x < listItems[0][i].x){
	            sortArrow.visible = false;
	        }
	
	        if (!sortArrow.visible && sortArrowHitArea){
	            sortArrowHitArea.visible = false;
	        }
	
		}
	}
}
