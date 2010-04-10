package com.igwjam
{
	import flash.display.Sprite;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.data.FlxMouse;

	public class Sun extends FlxSprite
	{
		[Embed(source="../../../resources/sun.png")] private var ImgSun:Class;
		
		// mouse offsets
		private var mXOff:int = 0;
		private var mYOff:int = 0;
		
		private const radius:int = 32;
		
		public function Sun()
		{	
			super(0,0,ImgSun);		
		}
		
		public function get xPos():Number
		{
			return positionUnderBorder(this.x, FlxG.width);
		}

		public function get yPos():Number
		{
			return positionUnderBorder(this.y, FlxG.height);
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
				this.y = positionUnderBorder(newY, FlxG.height);
				
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
		
		
	}
}