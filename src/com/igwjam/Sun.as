package com.igwjam
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.data.FlxMouse;

	public class Sun extends FlxSprite
	{
		[Embed(source="../../../resources/sun.png")] private var ImgSun:Class;
			[Embed(source="../../../resources/sunEyes.png")] private var ImgSunEyes:Class;
		
		// mouse offsets
		private var mXOff:int = 0;
		private var mYOff:int = 0;
		
		private const radius:int = 32;
		
		private var originalExtents:FlxPoint;
		
		private var eyes:FlxSprite;
		
		public function Sun()
		{	
			super(0,0,ImgSun);	

			eyes = new FlxSprite(0,0,ImgSunEyes);
			
			originalExtents = new FlxPoint(width, height);
			
			antialiasing = true;	
		}
		
		public function move():void
		{
			var mouseX:int = org.flixel.FlxG.mouse.x;
			var mouseY:int = org.flixel.FlxG.mouse.y;
			
			var mouse:FlxMouse = org.flixel.FlxG.mouse;
			
			if(mouse.justPressed())
			{
				if(this.x < mouseX && mouseX < this.x+64 && this.y < mouseY && mouseY < this.y+64)  
				{
					// hide mouse
					FlxG.mouse.hide();
					
					// set mouse Offset
					this.mXOff = mouseX-this.x;
					this.mYOff = mouseY-this.y;
				}
			}
			else if(mouse.pressed())
			{			
				var newX:int = mouseX-this.mXOff;
				this.x = positionUnderBorder(newX, FlxG.width);
				
				var newY:int = mouseY-this.mYOff;
				this.y = positionUnderBorder(newY, 240 + height);
				
			}
			else if(mouse.justReleased())
			{
				// show mouse
				FlxG.mouse.show();
			}
			
		}
		
		private function positionUnderBorder(pos:Number, axis:Number):Number
		{
			return Math.max(0,Math.min(pos, axis - this.radius * 2));
		}
		
		override public function update():void
		{
			var sunHeight:Number = Math.min(top, 240)/240;
			
			//scale the sun itself
			var scaleFactor:Number = FlxU.mapValues(sunHeight, 0, 1, 1, 1.7, true);
			scaleAndUpdate(scaleFactor, scaleFactor);
			
			//and color it
			var greenNBlue:int = FlxU.mapValues(sunHeight, 0, 1, 255, 0, true);
			trace("greenNBlue: " + greenNBlue);
			var sunColors:Array = FlxU.HEXtoRGB(color);
			color = FlxU.RGBtoHEX(sunColors[0], greenNBlue, greenNBlue);
			
			//trace("scalefactor: " + scaleFactor);
			
			eyes.scaleAndUpdate(scaleFactor, scaleFactor);
			eyes.x = x;
			eyes.y = y;
			
		}
		
		override public function render():void
		{
			super.render();
			
			eyes.render();
		}
		
	}
}