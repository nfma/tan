package com.igwjam
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import com.igwjam.Sun;
	import com.igwjam.SunPeople;
	
	
	public class PlayState extends FlxState
	{
		private var sun:Sun = new Sun;
		private var allPeople:Array;
		
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"Hello, World!")); //adds a 100px wide text field at position 0,0 (upper left)
			
			add(sun);
			FlxG.mouse.show();
			
			allPeople = new Array();
			var tempDude:SunPeople;
			
			tempDude = new SunPeople(100, 1, 100);
			add(tempDude);

//			for (var i:int = 0; i < 3; i++)
//			{
//				tempDude = new SunPeople(100 * i, 1 * i, 100 * i);
//				allPeople.push(tempDude);
//				add(tempDude);
//			}
			
		}

		override public function update():void
		{
			super.update();
			//TODO: update sun movement
			
			//TODO: calculate player sun distance & tan players
			
			//TODO: spawn and remove new players 
		}

	}
}