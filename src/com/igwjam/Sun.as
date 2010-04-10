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
			FlxG.mouse.cursor = new Sprite();
		}
		
		public function getXPos():int
		{
			return this.x + this.radius;
		}

		public function getYPos():int
		{
			return this.y + this.radius;
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
				this.x = Math.max(0,Math.min(newX,FlxG.width-64));
				
				var newY:int = mouseY-this.mYOff;
				this.y = Math.max(0,Math.min(newY,FlxG.height-64));
				
			}
			else if(mouse.justReleased())
			{
				// show mouse
				FlxG.mouse.show();
			}
			
		}
		
		
	}
}