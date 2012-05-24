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

// All hacking is related to making the scrollbar thinner so that it fits on the
// Chart axis line.  This code has not been tested with the vertical axis, nor has 
// it been tested with an altered axis line.   


package com.connectedpixel.charts.skins
{
	import mx.skins.halo.ScrollTrackSkin;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	import flash.display.GradientType;

	public class AxisScrollTrackSkin extends ScrollTrackSkin
	{
		public function AxisScrollTrackSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
				
			graphics.clear();
			
			// Draw clickable region, but make it not visible (alpha = 0)
			graphics.beginFill(0xffffff,0.0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	
	}
}
