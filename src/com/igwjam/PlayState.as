package com.igwjam
{
	import com.igwjam.Sun;
	import com.igwjam.SunPeople;
	
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	
	public class PlayState extends FlxState
	{
		private var sun:Sun = new Sun;
		private var allPeople:Array;
		
		public var timeSinceStart:Number = 0.0;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"Hello, World!")); //adds a 100px wide text field at position 0,0 (upper left)
			
			add(sun);
			FlxG.mouse.show();
			
			var tempDude:SunPeople;
			
			tempDude = new SunPeople(10, 1, 100);
			add(tempDude);
			
			allPeople = new Array;
			allPeople.push(tempDude);
			
			
//			for (var i:int = 0; i < 3; i++)
//			{
//				tempDude = new SunPeople(100 * i, 1 * i, 100 * i);
//				allPeople.push(tempDude);
//				add(tempDude);
//			}
			
		}
		
		override public function update():void
		{
			this.timeSinceStart += FlxG.elapsed;
			
			super.update();

			//TODO: update sun movement
			sun.move();
			
			trace(allPeople.length);
			
			for each(var dude:SunPeople in allPeople) {
				dude.tanUsingThe(sun.xPos, sun.yPos);
			}

			trace("mouse: "+sun.xPos+" "+sun.yPos);
						
			//TODO: calculate player sun distance & tan players
			
			//TODO: spawn and remove new players 
		}
		
	}
}