////////////////////////////////////////////////////////////////////////////////
//
//  Author: Joel May
//  connectedpixel.com
//  All code here not owned by Adobe Systems Incorporated is in the public domain.
//
////////////////////////////////////////////////////////////////////////////////


package com.connectedpixel.charts
{
	import flash.geom.Rectangle;
	
	import mx.charts.AxisRenderer;
	import mx.charts.BarChart;
	import mx.charts.ColumnChart;
	import mx.charts.chartClasses.CartesianChart;
	import mx.controls.scrollClasses.ScrollBarDirection;
	import mx.graphics.IStroke;

	[Style(name="scrollBarThemeColor", type="uint", format="Color", inherit="yes")]
	
	[Style(name="scrollBarDownArrowDownSkin", type="Class", inherit="no")]
	[Style(name="scrollBarDownArrowOverSkin", type="Class", inherit="no")]
	[Style(name="scrollBarThumbIcon", type="Class", inherit="no")]
	[Style(name="scrollBarThumbDownSkin", type="Class", inherit="no")]
	[Style(name="scrollBarThumbOverSkin", type="Class", inherit="no")]
	[Style(name="scrollBarThumbUpSkin", type="Class", inherit="no")]
	[Style(name="scrollBarTrackColors", type="Array", arrayType="uint", format="Color", inherit="no")]
	[Style(name="scrollBarTrackSkin", type="Class", inherit="no")]
	[Style(name="scrollBarUpArrowDisabledSkin", type="Class", inherit="no")]
	[Style(name="scrollBarUpArrowDownSkin", type="Class", inherit="no")]
	[Style(name="scrollBarUpArrowOverSkin", type="Class", inherit="no")]
	[Style(name="scrollBarUpArrowUpSkin", type="Class", inherit="no")]

	public class ScrollableAxisRenderer extends AxisRenderer
	{
		// These styles will be passed to the contained scrollbar when this initializes.
		static private var styleArray:Array = [
			"scrollBarThumbDownSkin", 			
			"scrollBarThumbOverSkin", 			
			"scrollBarThumbUpSkin", 			
			"scrollBarThumbDownSkin", 			
			"scrollBarDownArrowDisabledSkin", 	
			"scrollBarDownArrowDownSkin", 		
			"scrollBarDownArrowOverSkin", 		
			"scrollBarDownArrowUpSkin", 		
			"scrollBarUpArrowDisabledSkin",		
			"scrollBarUpArrowDownSkin", 		
			"scrollBarUpArrowOverSkin", 		
			"scrollBarUpArrowUpSkin", 			
			"scrollBarTrackSkin" 				
		];
		
		/////////////////////////////////////////////////////////////////////////////	
		
		private var _scrollBar:ChartDataScrollBar;
		
		private var nColumns:int = 5;	
		private var bnColumnsChanged:Boolean = false;
		
		private var _alteredStyles:Object = new Object();
		
		public function ScrollableAxisRenderer()
		{
			super();
			initAlteredStyles();
		}
		
		private function initAlteredStyles():void
		{
  			for (var i:int = 0 ; i < styleArray.length ; i++){
				var styleName:String = styleArray[i];
				_alteredStyles[styleName] = true;
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			// If it starts with 'scrollBar', it is a style for the scroll
			// bar.  Log the change here and forward it in updateDisplayList().
			var prefix:String = "scrollBar";
			if (styleProp != null && styleProp.indexOf(prefix) == 0){
				_alteredStyles[styleProp] = true;
				invalidateDisplayList();
			}
			
		}
		
		/////////////////////////////////////////////
		[Bindable]
		public function set maxVisibleColumns(n:int):void
		{
			if (this.nColumns != n){
				this.nColumns = n;	
				this.bnColumnsChanged = true;
				this.invalidateProperties();
			}
		}
		public function get maxVisibleColumns():int
		{
			return this.nColumns;
		}
		
		[Bindable]
		public function set firstIndexOffset(iCol:int):void
		{
			_scrollBar.firstIndexOffset = iCol;
		}
		public function get firstIndexOffset():int
		{
			return _scrollBar.firstIndexOffset;
		}
		
		/////////////////////////////////////////////
		
		override protected function createChildren():void
		{
			if (this.chart is BarChart){
				if (horizontal){
					throw new Error("ScrollableAxisRenderer can only render the vertical axis on a BarChart");
				}
			}
			else if (this.chart is ColumnChart){
				if (!horizontal){
					throw new Error("ScrollableAxisRenderer can only render the horizontal axis on a ColumnChart");
				}
			}
			else{
				throw new Error("ScrollableAxisRenderer only works with ColumnCharts and BarCharts");
			}
			
			if (_scrollBar == null){
				var dir:String = horizontal ? ScrollBarDirection.HORIZONTAL : ScrollBarDirection.VERTICAL;
				_scrollBar = new ChartDataScrollBar(dir);
				
				// compensate for crazy rotation of a vertical axis renderer.
				_scrollBar.rotation = -this.rotation;	 
				
				addChild(_scrollBar);
				
				_scrollBar.chart = this.chart as CartesianChart;
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (bnColumnsChanged){
				bnColumnsChanged = false;
				_scrollBar.maxColumns = nColumns;
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
	
			drawScrollBar();
			
			updateScrollBarStyles();
		}
		
		
		private function updateScrollBarStyles():void
		{
			for (var styleProp:String in _alteredStyles){
				var prefix:String = "scrollBar";
				if (styleProp.indexOf(prefix) == 0){
					// Fix the name.  e.g. Change from scrollBarUpArrowSkin to upArrowSkin.
					var scrollStyleProp:String = styleProp.substr(prefix.length);
					// Fix the first letter capitalization.
					scrollStyleProp = scrollStyleProp.charAt(0).toLowerCase() + scrollStyleProp.substr(1);
					
					var propVal:* = this.getStyle(styleProp);		
					if (propVal != undefined){
						_scrollBar.setStyle(scrollStyleProp, propVal);		
					}
				}
			}
			_alteredStyles = new Object();
		}
		
		private var _bScrollBarNeedsDrawing:Boolean = true;
		private var _scrollX:Number;
		private var _scrollY:Number;
		private var _scrollW:Number;
		private var _scrollH:Number;
		
		private function drawScrollBar():void
		{
			var barRect:Rectangle = horizontal ? calcHorzScrollBarRect() : calcVertScrollBarRect();
			
			var scX:Number = barRect.left;
			var scY:Number = barRect.top;
			var scW:Number = barRect.width;
			var scH:Number = barRect.height;
			
			if (scX == _scrollX && scY == _scrollY && scW == _scrollW && scH == _scrollH){
				// Don't mess with the scroll bar unless necessary.
				// This function is called in response to moving the scroll bar.
				// Therefore, we would be redrawing the scrollbar like crazy unless
				// we prevent that here.
				return;
			}
			
			_scrollX = scX;
			_scrollY = scY;
			_scrollW = scW;
			_scrollH = scH;

			_scrollBar.move(scX,scY);
			
			_scrollBar.setActualSize(scW,scH);
		}
		
		// Figure out the rectangle that corresponds to the drawn axis.  
		// The scrollbar will overlay the axis.  
		
		private function calcHorzScrollBarRect():Rectangle
		{
			var axisStroke:IStroke = getStyle("axisStroke");
			
			var w:Number = Number(axisStroke.weight == 0 ? 1 : axisStroke.weight);
									  
			var bInverted:Boolean = this.placement == "top";
			
			// Prevent repeated function calls.
			var guts:Rectangle = gutters;
	
			var rectL:Number = guts.left;
			var rectT:Number = bInverted ? guts.top - w : unscaledHeight - guts.bottom ;
			rectT += w/2;
			var rectW:Number = unscaledWidth -guts.right - rectL;
			var rectH:Number = w;
			var r:Rectangle = new Rectangle(rectL, rectT, rectW, rectH);
			return r;
		}
		
		private function calcVertScrollBarRect():Rectangle
		{
			var axisStroke:IStroke = getStyle("axisStroke");
			
			var w:Number = Number(axisStroke.weight == 0 ? 1 : axisStroke.weight);
				
			var bInverted:Boolean = this.placement == "right";
			
			var guts:Rectangle = gutters;
	
			var rectL:Number = guts.top; 
			var rectT:Number = bInverted ? guts.right-w : unscaledHeight-guts.left;
			rectT += w/2;
			var rectW:Number = w;
			var rectH:Number = unscaledWidth-guts.bottom-guts.top;
			
			var r:Rectangle = new Rectangle(rectL,rectT,rectW,rectH);
			return r;
		}
	}
}