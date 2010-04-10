package com.igwjam
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.data.FlxMouse;

	public class Sun extends FlxSprite
	{
		// mouse offsets
		private var mXOff:int = 0;
		private var mYOff:int = 0;
		
		private const radius:int = 10;
		
		public function Sun()
		{			

		}
		
		public function move():void
		{
			var mouseX:int = org.flixel.FlxG.mouse.x;
			var mouseY:int = org.flixel.FlxG.mouse.y;
			
			var mouse:FlxMouse = org.flixel.FlxG.mouse;
			
			if(mouse.justPressed())
			{
				if(Math.abs(this.x-mouseX) < this.radius || Math.abs(this.y-mouseY) < this.radius)
				{
					// hide mouse
					FlxG.mouse.hide();
					
					// set mouse Offset
					this.mXOff = this.x-mouseX;
					this.mYOff = this.y-mouseY;
				}
			}
			else if(mouse.pressed())
			{														
				// move sun with mouse
				if(mouseX+this.mXOff > this.radius && mouseX+this.mXOff < FlxG.width-this.radius)
				{
					this.x = mouseX+this.mXOff;			
				}
				if(mouseY+this.mYOff > this.radius && mouseY+this.mYOff < FlxG.height-this.radius)
				{
					this.y = mouseY+this.mYOff;
				}
			}
			else if(mouse.justReleased())
			{
				// show mouse
				FlxG.mouse.show();
			}
			
		}
		
		
	}
}