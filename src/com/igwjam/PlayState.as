package com.igwjam
{
	import com.igwjam.Sun;
	import com.igwjam.SunPeople;
	
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	
	public class PlayState extends FlxState
	{
		private var sun:Sun = new Sun;
		private var allPeople:Array;
		
		public var timeSinceStart:Number = 0.0;
		private var timestampLastSpawn:Number = 0.0;
		
		private var eveSky:FlxSprite;

		[Embed(source="../../../resources/midsky.png")] private var ImgMidSky:Class;
		[Embed(source="../../../resources/evesky.png")] private var ImgEveSky:Class;
		[Embed(source="../../../resources/beach.png")] private var ImgBeach:Class;
		[Embed(source="../../../resources/water.png")] private var ImgWater:Class;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void
		{		
			
			var midsky:FlxSprite = new FlxSprite(0,0,ImgMidSky);
			add(midsky);
			
			eveSky = new FlxSprite(0,0,ImgEveSky);
			eveSky.alpha = 0.0;
			add(eveSky)
			
			add(sun);
			FlxG.mouse.show();
			
			var water:FlxSprite = new FlxSprite(0,0,ImgWater);
			add(water);
			
			var beach:FlxSprite = new FlxSprite(0,0,ImgBeach);
			add(beach);			

			
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
					allPeople[i] = new SunPeople(10, 1, 160*(i+1) );
					add(allPeople[i]);
				}
			}
		
			
			//TODO: update sun movement
			sun.move();
			
			eveSky.alpha = Math.sin(sun.y/208.0*(Math.PI/2.0));
			trace(eveSky.alpha);
						
			//tan players
			for each(var dude:SunPeople in allPeople) {
				if(dude != null)
					dude.tanUsingThe(sun.xPos, sun.yPos);
			}
						
			
		}
		
	}
}