package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.data.FlxMouse;

	public class Sun extends FlxSprite
	{
		// mouse offsets
		private var mXOff:int = 0;
		private var mYOff:int = 0;
		
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
				if(Math.abs(this.x-mouseX) < 10 || Math.abs(this.y-mouseY) < 10)
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
				if(mouseX+this.mXOff > 10 && mouseX+this.mXOff < 300)
				{
					this.x = mouseX+this.mXOff;			
				}
				if(mouseY+this.mYOff > 10 && mouseY+this.mYOff < 200)
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