package com.igwjam
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	
	public class PlayState extends FlxState
	{
		private var sun:Sun = new Sun;
		private var allPeople:Array;
		private var numberOfPeople:Number;
		
		private var peopleCount:int = 0;
		public var peoplePerLevel:int = 10;
		
		private var levelFinished:Boolean = false;
		private var finishTime:Number = 0;
		
		public var timeSinceStart:Number = 0.0;
		private var timestampLastSpawn:Number = -10.0;	//so they start spawning right away
		
		private var eveSky:FlxSprite;
		private var nightSky:FlxSprite;
		
		private var difficultyLevel:Number;

		[Embed(source="../../../resources/midsky.png")] private var ImgMidSky:Class;
		[Embed(source="../../../resources/nightSky.jpg")] private var ImgNightSky:Class;
		[Embed(source="../../../resources/evesky.png")] private var ImgEveSky:Class;
		[Embed(source="../../../resources/beach.png")] private var ImgBeach:Class;
		[Embed(source="../../../resources/water.png")] private var ImgWater:Class;
		
		[Embed(source="../resources/Sniglet.ttf",fontFamily="score")] protected var scoreFont:String;
		
		[Embed(source="../resources/music.mp3")] private var BgMusic:Class;
		
		
		protected var score:FlxText;
		protected var finalScore:FlxText;

		public function PlayState(difficultyLevel:Number)
		{
			super();
			this.difficultyLevel = difficultyLevel;
		}
		
		override public function create():void
		{		
			
			var midsky:FlxSprite = new FlxSprite(0,0,ImgMidSky);
			add(midsky);
			
			eveSky = new FlxSprite(0,0,ImgEveSky);
			eveSky.alpha = 0.0;
			add(eveSky)
			
			sun.centerX = FlxG.width/2;
			
			add(sun);
			FlxG.mouse.show();
			
			var water:FlxSprite = new FlxSprite(0,0,ImgWater);
			add(water);
			
			var beach:FlxSprite = new FlxSprite(0,0,ImgBeach);
			add(beach);			
			
			nightSky = new FlxSprite(0,0,ImgNightSky);
			nightSky.alpha = 0.0;
			add(nightSky)

			numberOfPeople = 3;
			
			allPeople = new Array();
			for (var i:int = 0; i < numberOfPeople; i++)
			{
				allPeople.push(null);
			}
			
			FlxG.score = 0;
			
			score = new FlxText(FlxG.width-120, 10,100);
			score.setFormat("score", 46, 0x000000, "right");
			score.text = FlxG.score.toString();
			add(score);
			
			finalScore = new FlxText(0, FlxG.height/2 - 100, FlxG.width);
			finalScore.setFormat("score", 80, 0x009900, "center");
			
			//play some bg music
			FlxG.playMusic(BgMusic);
		}
		
		override public function update():void
		{
			this.timeSinceStart += FlxG.elapsed;
			
			super.update();
			
			if(levelFinished)
			{
				if (this.timeSinceStart > finishTime + 5)
					FlxG.state = new MenuState();
				return;
			}
			
			//remove player who has left		
			var nullCount:int = 0;	
			for ( var i:int = 0; i < numberOfPeople; i++)	{
				if( allPeople[i] != null ) {
					if( (allPeople[i] as SunPeople).getState() == SunPeople.terminated ) {
						delete allPeople[i];
						allPeople[i] = null;
					}
				}
				else if (peopleCount > peoplePerLevel)
				{
					nullCount++;
				}
			}
			
			if(peopleCount > peoplePerLevel && nullCount == numberOfPeople)
			{
				levelFinished = true;
				finishTime = timeSinceStart;
				finalScore.text = "Final Score:\n" + FlxG.score.toString();
				add(finalScore);
			}

			//spawn new player
			if(sun.top < 220 && peopleCount <= peoplePerLevel)		//no people will come when it's evening!
			{
				for ( i = 0; i < numberOfPeople; i++)	{
					if( allPeople[i] == null && timeSinceStart - timestampLastSpawn > (5.0 /this.difficultyLevel) ) {
						timestampLastSpawn = timeSinceStart;
						allPeople[i] = new SunPeople(((FlxU.random() * 20) + 7) * (1 / this.difficultyLevel), 5, 160*(i+1), this.difficultyLevel);
						add(allPeople[i]);
						peopleCount++;
					}
				}
			}
			
			//TODO: update sun movement
			sun.move();
			
			eveSky.alpha = Math.sin(sun.y/208.0*(Math.PI/2.0));
			
			if(sun.top >= 240)
			{				
				//it's night so make it dark
				if(nightSky.alpha < 0.6)
					nightSky.alpha += 0.01;
			}
			else if(nightSky.alpha > 0.0)
			{
				//it's day so make it light again
				nightSky.alpha -= 0.01;
			}
									
			//tan players
			for each(var dude:SunPeople in allPeople) {
				if(dude != null)
					dude.tanUsingThe(sun);
			}
						

			score.text = FlxG.score.toString();
			
		}
		
		public function startNightFade():void
		{
			
		}
		
	}
}