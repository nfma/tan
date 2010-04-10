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
		private var timestampLastSpawn:Number = 0.0;

		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"Hello, World!")); //adds a 100px wide text field at position 0,0 (upper left)
			
			add(sun);
			FlxG.mouse.show();
			
			allPeople = new Array(null, null, null)
		}
		
		override public function update():void
		{
			this.timeSinceStart += FlxG.elapsed;
			
			super.update();
			
			//remove player who has left			
			for ( var i:int = 0; i < 3; i++)	{
				if( allPeople[i] != null ) {
					if( (allPeople[i] as SunPeople).getState() == SunPeople.terminated ) {
						delete allPeople[i];
						allPeople[i] = null;
					}
				}
			}

			//spawn new player
			for ( i = 0; i < 3; i++)	{
				if( allPeople[i] == null && timeSinceStart - timestampLastSpawn > 5.0 ) {
					timestampLastSpawn = timeSinceStart;
					allPeople[i] = new SunPeople(100, 1, 160*(i+1) );
					add(allPeople[i]);
				}
			}
		
			
			//TODO: update sun movement
			sun.move();
			
			trace(allPeople.length);
			
			//tan players
			for each(var dude:SunPeople in allPeople) {
				if(dude != null)
					dude.tanUsingThe(sun.xPos, sun.yPos);
			}

			trace("mouse: "+sun.xPos+" "+sun.yPos);
						


			
		}
		
	}
}