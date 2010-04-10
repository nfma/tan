package com.igwjam
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import com.igwjam.Sun;
	
	
	public class PlayState extends FlxState
	{
		private var sun:Sun = new Sun;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"Hello, World!")); //adds a 100px wide text field at position 0,0 (upper left)
			
			add(sun);
			FlxG.mouse.show();
		}

	}
}