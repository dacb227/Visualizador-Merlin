////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

// Copied from mx.skins.halo.SliderThumbSkin and hacked by Joel May, connectedpixel.com, 
// as part of the scrolling charts feature.

// All hacking is related to making the thumb thinner so that it fits on the
// Chart axis line.  This code has not been tested with the vertical axis, nor has 
// it been tested with an altered axis line.   

package com.connectedpixel.charts.skins
{
	import mx.skins.halo.ScrollThumbSkin;
	import flash.display.GradientType;
	import mx.styles.StyleManager;
	import mx.skins.halo.HaloColors;
	import mx.utils.ColorUtil;

	public class AxisScrollThumbSkin extends ScrollThumbSkin
	{
		public function AxisScrollThumbSkin()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		private static var cache:Object = {};
	
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 *  Several colors used for drawing are calculated from the base colors
		 *  of the component (themeColor, borderColor and fillColors).
		 *  Since these calculations can be a bit expensive,
		 *  we calculate once per color set and cache the results.
		 */
		private static function calcDerivedStyles(themeColor:uint,
												  borderColor:uint,
												  fillColor0:uint,
												  fillColor1:uint):Object
		{
			var key:String = HaloColors.getCacheKey(themeColor, borderColor,
													fillColor0, fillColor1);
			
			if (!cache[key])
			{
				var o:Object = cache[key] = {}
				
				// Cross-component styles.
				HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);
				
				// ScrollArrowDown-specific styles.
				o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor, -50);
			}
			
			return cache[key];
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
	
			// User-defined styles.
			var backgroundColor:Number = getStyle("backgroundColor");
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var fillAlphas:Array = getStyle("fillAlphas");
			var fillColors:Array = getStyle("fillColors");
			StyleManager.getColorNames(fillColors);
			var highlightAlphas:Array = getStyle("highlightAlphas");				
			var themeColor:uint = getStyle("themeColor");
			
			// Placeholder styles stub.
			var gripColor:uint = 0x6F7777;
			
			// Derived styles.
			var derStyles:Object = calcDerivedStyles(themeColor, borderColor,
													 fillColors[0], fillColors[1]);
													 
			var radius:Number = Math.max(cornerRadius - 1, 0);
			radius /= 2;
			var cr:Object = { tl: 0, tr: radius, bl: 0, br: radius };
			radius = Math.max(radius - 1, 0);
			var cr1:Object = { tl: 0, tr: radius, bl: 0, br: radius };
	
			var horizontal:Boolean = parent &&
									 parent.parent &&
									 parent.parent.rotation != 0;
	
			if (isNaN(backgroundColor))
				backgroundColor = 0xFFFFFF;
			
			graphics.clear();
			
			graphics.beginFill(0xff0000,0.0);
			graphics.drawRect(-15,0,w,h);
			//graphics.drawRect(0,0,w,h);
			graphics.endFill();
			
			// Shrink the width to fit the thin axis line.
			w *= 0.7;
			
			// Opaque backing to force the scroll elements
			// to match other components by default.
			drawRoundRect(
				1, 0, w - 3, h, cr,
				backgroundColor, 0.2);                            
	
			switch (name)
			{
				default:
				case "thumbUpSkin":
				{
					fillColors[0] = ColorUtil.adjustBrightness(fillColors[0], 100.0);
	   				var upFillColors:Array = [ fillColors[0], fillColors[1] ];
	   				
					var upFillAlphas:Array = [ fillAlphas[0], fillAlphas[1] ];
	
					// positioning placeholder
					drawRoundRect(
						0, 0, w, h, 0,
						0xFFFFFF, 0); 
	
					// shadow
					if (horizontal)
					{
						drawRoundRect(
							1, 0, w - 2, h, cornerRadius,
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [ 1, 0 ],
							horizontalGradientMatrix(2, 0, w, h),
							GradientType.LINEAR, null, 
							{ x: 1, y: 1, w: w - 4, h: h - 2, r: cr1 });
					}
					else
					{
						drawRoundRect(
							1, h - radius, w - 3, radius + 4,
							{ tl: 0, tr: 0, bl: 0, br: radius },
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [ 1, 0 ],
							horizontal ?
							horizontalGradientMatrix(0, h - 4, w - 3, 8) :
							verticalGradientMatrix(0, h - 4, w - 3, 8),
							GradientType.LINEAR, null, 
							{ x: 1, y: h-radius, w: w - 4, h: radius,
							  r: { tl: 0, tr: 0, bl: 0, br: radius - 1 } }); 
					}
					// border
					drawRoundRect(
						1, 0, w - 3, h, cr,
						[ borderColor, derStyles.borderColorDrk1 ], 1,
						horizontal ?
						horizontalGradientMatrix(0, 0, w, h) :
						verticalGradientMatrix(0, 0, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 4, h: h - 2, r: cr1 });  
	
					// fill
					drawRoundRect(
						1, 1, w - 4, h - 2, cr1,
						upFillColors, upFillAlphas,
						horizontal ?
						horizontalGradientMatrix(1, 0, w - 2, h - 2) :
						verticalGradientMatrix(1, 0, w - 2, h - 2)); 
	
					// highlight
					if (horizontal)
					{
						drawRoundRect(
							1, 0, (w - 4) / 2, h - 2, 0,
							[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
							horizontalGradientMatrix(1, 1, w - 4, (h - 2) / 2)); 
					}
					else
					{
						drawRoundRect(
							1, 1, w - 4, (h - 2) / 2, cr1,
							[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
							horizontal ?
							horizontalGradientMatrix(1, 0, (w - 4) / 2, h - 2) :
							verticalGradientMatrix(1, 1, w - 4, (h - 2) / 2)); 
					}
					break;
				}
				
				case "thumbOverSkin":
				{
					var overFillColors:Array;
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
	
					var overFillAlphas:Array;
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
	  				else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
	
					// positioning placeholder
					drawRoundRect(
						0, 0, w, h, 0,
						0xFFFFFF, 0); 
	
					// shadow
					if (horizontal)
					{
						drawRoundRect(
							1, 0, w - 2, h, cornerRadius,
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [ 1, 0 ],
							horizontalGradientMatrix(2, 0, w, h),
							GradientType.LINEAR, null, 
							{ x: 1, y: 1, w: w - 4, h: h - 2, r: cr1 });
					}
					else
					{
						drawRoundRect(
							1, h - radius, w - 3, radius + 4,
							{ tl: 0, tr: 0, bl: 0, br: radius },
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [ 1, 0 ],
							horizontal ?
							horizontalGradientMatrix(0, h - 4, w - 3, 8) :
							verticalGradientMatrix(0, h - 4, w - 3, 8),
							GradientType.LINEAR, null, 
							{ x: 1, y: h-radius, w: w - 4, h: radius,
							  r: { tl: 0, tr: 0, bl: 0, br: radius - 1 } }); 
					}
									
					// border
					drawRoundRect(
						1, 0, w - 3, h, cr,
						[ themeColor, derStyles.themeColDrk1], 1,
						horizontal ?
						horizontalGradientMatrix(1, 0, w, h) :
						verticalGradientMatrix(0, 0, w, h),
						GradientType.LINEAR, null, 
	                    { x: 1, y: 1, w: w - 4, h: h - 2, r: cr1 });
	
					// fill
					drawRoundRect(
						1, 1, w - 3, h - 2, cr1,
						//1, 1, w - 2, h - 2, cr1,
						//1, 1, w - 4, h - 2, cr1,
						overFillColors, overFillAlphas,
						horizontal ?
						horizontalGradientMatrix(1, 0, w, h) :
						verticalGradientMatrix(1, 0, w, h)); 
					
					break;
				}
				
				case "thumbDownSkin":
				{				
					// shadow
					if (horizontal)
					{
						drawRoundRect(
							1, 0, w - 2, h, cr,
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [1, 0],
							horizontalGradientMatrix(2, 0, w, h),
							GradientType.LINEAR, null, 
							{ x: 1, y: 1, w: w - 4, h: h - 2, r: cr1 }); 
					}
					else
					{
						drawRoundRect(
							1, h - radius, w - 3, radius + 4,
							{ tl: 0, tr: 0, bl: 0, br: radius },
							[ derStyles.borderColorDrk1,
							  derStyles.borderColorDrk1 ], [ 1, 0 ],
							horizontal ?
							horizontalGradientMatrix(0, h - 4, w - 3, 8) :
							verticalGradientMatrix(0, h - 4, w - 3, 8),
							GradientType.LINEAR, null, 
							{ x: 1, y: h-radius, w: w - 4, h: radius,
							  r: { tl: 0, tr: 0, bl: 0, br: radius - 1 } }); 
					}
	
					// border
					drawRoundRect(
						1, 0, w - 3, h, cr,
						[ themeColor, derStyles.themeColDrk2], 1,
						horizontal ?
						horizontalGradientMatrix(1, 0, w, h) :
						verticalGradientMatrix(0, 0, w, h),
						GradientType.LINEAR, null, 
	                    { x: 1, y: 1, w: w - 4, h: h - 2, r: cr1});  
	
					// fill
					drawRoundRect(
						//0.5, 1, w - 1, h - 2, cr1,
						0.5, 1, w - 3, h - 2, cr1,
						//1, 1, w - 4, h - 2, cr1,
						[ derStyles.fillColorPress1, derStyles.fillColorPress2 ], 1,
						horizontal ?
						horizontalGradientMatrix(1, 0, w, h) :
						verticalGradientMatrix(1, 0, w, h)); 
										
					break;
				}
				
				case "thumbDisabledSkin":
				{
					// positioning placeholder
					drawRoundRect(
						0, 0, w, h, 0,
						0xFFFFFF, 0); 
					
					// border
					drawRoundRect(
						1, 0, w - 3, h, cr,
						0x999999, 0.5);
					
					// fill
					drawRoundRect(
						1, 1, w - 4, h - 2, cr1,
						0xFFFFFF, 0.5);
					
					break;
				}
			}
			
			// Draw grip.
			
			//var gripW:Number = Math.floor(w / 2 - 4);
			var gripW:Number = Math.floor(w / 2 - 3);
			
			var gripThick:Number = 5;
			
			drawRoundRect(
				gripW, Math.floor(h / 2 - 4), gripThick, 1, 0,
				0x000000, 0.4);
			
			drawRoundRect(
				gripW, Math.floor(h / 2 - 2), gripThick, 1, 0,
				0x000000, 0.4);
			
			drawRoundRect(
				gripW, Math.floor(h / 2), gripThick, 1, 0,
				0x000000, 0.4);
			
			drawRoundRect(
				gripW, Math.floor(h / 2 + 2), gripThick, 1, 0,
				0x000000, 0.4);
	
			drawRoundRect(
				gripW, Math.floor(h / 2 + 4), gripThick, 1, 0,
				0x000000, 0.4);
		}
	
	}
}
