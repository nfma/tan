package com.igwjam
{
	import org.flixel.*;
	
	public class SunPeople extends FlxSprite
	{
		[Embed(source="../resources/lying_body.png")] private var ImgLyingBody:Class;
		[Embed(source="../resources/lying_skin.png")] private var ImgLyingSkin:Class;
		[Embed(source="../resources/walk_skin.png")] private var ImgWalkSkin:Class;
		[Embed(source="../resources/walk_body.png")] private var ImgWalkBody:Class;
		
		[Embed(source="../resources/lying_body_man.png")] private var ImgLyingBodyMan:Class;
		[Embed(source="../resources/lying_skin_man.png")] private var ImgLyingSkinMan:Class;
		[Embed(source="../resources/walk_skin_man.png")] private var ImgWalkSkinMan:Class;
		[Embed(source="../resources/walk_body_man.png")] private var ImgWalkBodyMan:Class;
		[Embed(source="../resources/angry.png")] private var ImgAngryBalloon:Class;
		[Embed(source="../resources/happy.png")] private var ImgHappyBalloon:Class;
		
		[Embed(source="../resources/clock.png")] private var ImgClock:Class;
		
		[Embed(source="../resources/Sniglet.ttf",fontFamily="score")] protected var scoreFont:String;

		
		private var timeToLeave:Number = 0;
		private var timeTanning:Number = 0;
		private var untilPissOff:Number;
		private var tan:Number;
		private var beachState:int;
		private var tanMultiplier:Number;
		private var targetPosition:int;

		private var timeToLeaveClock:FlxSprite;
		private var scoreAtPosition:ScoreText;
		
		private var angryBalloon:FlxSprite;
		private var happyBalloon:FlxSprite;

		private var lyingBodySprite:FlxSprite;
		private var lyingSkinSprite:FlxSprite;
		
		private var walkSkinSprite:FlxSprite;

		private var difficultyLevel:Number;
		
		
		public static const walking:int = 0;
		public static const tanning:int = 1;
		public static const leaveHappy:int = 2;
		public static const leaveAngry:int = 3;
		public static const terminated:int = 4;
		
		private var gender:Boolean;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int, difficultyLevel:Number)
		{
			this.difficultyLevel = difficultyLevel; 
			tan = 0;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 300);
		
			gender = ( Math.round(Math.random()*100) % 2 == 0 )
				
			loadGraphic(ImgWalkBody, true, true, 65, 140);
			
			walkSkinSprite = new FlxSprite(0,300);
			if (gender) {
				loadGraphic(ImgWalkBodyMan, true, true, 65, 140);
				walkSkinSprite.loadGraphic(ImgWalkSkinMan, true, true, 65, 140);
			} else {
				loadGraphic(ImgWalkBody, true, true, 65, 140);
				walkSkinSprite.loadGraphic(ImgWalkSkin, true, true, 65, 140);
			}
			FlxG.state.add(walkSkinSprite);
			walkSkinSprite.color = this.calculateTanColor();

			angryBalloon = new FlxSprite(0, 0, ImgAngryBalloon);
			angryBalloon.alpha = 0;
			angryBalloon.centerY = top - 20;
			FlxG.state.add(angryBalloon);
			happyBalloon = new FlxSprite(0, 0, ImgHappyBalloon);
			happyBalloon.alpha = 0;
			happyBalloon.centerY = top - 20;
			FlxG.state.add(happyBalloon);

			addAnimation("walk", [0, 1, 2,3], 4, true);
			addAnimation("leaveHappy", [0, 1, 2,3], 2, true);
			addAnimation("leaveAngry", [0, 1, 2,3], 8, true);
			
			walkSkinSprite.addAnimation("walk", [0, 1, 2,3], 4, true);
			walkSkinSprite.addAnimation("leaveHappy", [0, 1, 2,3], 2, true);
			walkSkinSprite.addAnimation("leaveAngry", [0, 1, 2,3], 8, true);
			
			scoreAtPosition = new ScoreText(1,0,0, 200, "");
			scoreAtPosition.setFormat("score", 80, 0x119900, "center");
			
			this.velocity.x = 200.0;
			walkSkinSprite.velocity.x = 200.0;
			
			this.beachState = walking;
			play("walk");
			walkSkinSprite.play("walk");
		}
		

		public function tanUsingThe(sun:Sun):void
		{
			if(this.beachState != tanning)
				return;
				
			//if the sun is below the horizon, which means it's night we go home
			if (sun.top >= 240)
			{
				untilPissOff = timeTanning;
			}	
				
			tan += calculateIntensityWith(sun) * tanMultiplier;
			
		}
		
		private function calculateIntensityWith(sun:Sun):Number
		{
			return calculateIntensityForX(sun) * calculateIntensityForY(sun) * difficultyLevel;
		}
		
		private function calculateIntensityForX(sun:Sun):Number
		{
			return Math.max(0, 0.025 - (distanceBetween(sun.centerX, centerX) / 19200));
		}
		
		private function calculateIntensityForY(sun:Sun):Number
		{
			return 0.025 - sun.centerY * 0.025 / 272;
		}
		
		private function distanceBetween(sun:Number, dude:Number):Number
		{
			return Math.abs(sun - dude);
		}
		
		private function square(number:Number):Number 
		{
			return number * number;
		}		
		
		private function showScore(score:Number): void
		{
			if(score > 0)
			{
				scoreAtPosition.text = "+" + score;
				scoreAtPosition.color = 0x119900;
			}
			else
			{
				scoreAtPosition.text = score.toString();
				scoreAtPosition.color = 0x991100;
			}
			scoreAtPosition.centerX = centerX;
			scoreAtPosition.centerY = centerY;
			scoreAtPosition.revive();
		}
		
		override public function update():void
		{
			happyBalloon.centerX = centerX + 40;
			angryBalloon.centerX = centerX + 40;

			switch(this.beachState)
			{
				case walking:
					if( this.x >= this.targetPosition ) {
					
						this.velocity.x = 0.0;
						walkSkinSprite.velocity.x = 0.0;
						
						this.beachState = tanning;
						
						this.alpha = 0.0;
						walkSkinSprite.alpha = 0.0;
						
						if (gender) {
							lyingBodySprite = new FlxSprite(this.targetPosition-70,340,ImgLyingBodyMan);
							lyingSkinSprite = new FlxSprite(this.targetPosition-70,340,ImgLyingSkinMan);
						} else {
							lyingBodySprite = new FlxSprite(this.targetPosition-70,340,ImgLyingBody);
							lyingSkinSprite = new FlxSprite(this.targetPosition-70,340,ImgLyingSkin);	
						}

						
						//add it to the front of the array, so it is rendered in the background
						FlxG.state.defaultGroup.members.splice(10,0,lyingSkinSprite,lyingBodySprite);
					}
					break;
				case tanning:
					this.timeTanning += FlxG.elapsed;
					
					var red:int = 200 - Math.min(200, 200*tan) / 2;
					
					lyingSkinSprite.color = calculateTanColor();
					
					
					if( timeToLeaveClock == null ) {
						timeToLeaveClock = new FlxSprite();
						timeToLeaveClock.loadGraphic(ImgClock, true, true, 16, 16);
						timeToLeaveClock.x = this.x + 8;
						timeToLeaveClock.y = this.y;
						timeToLeaveClock.addAnimation( "clock_running", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], (17.0/untilPissOff), false);
					
						FlxG.state.add(timeToLeaveClock);
						
						timeToLeaveClock.play("clock_running");	
					}
										
					if( this.tan > 1.2 )
					{
						this.velocity.x = 250.0;
						walkSkinSprite.velocity.x = 250.0;
						
						FlxG.score -= 10;
						showScore(-10);
						
						walkSkinSprite.color = this.calculateTanColor();

						this.tanToLeave();
						this.beachState = leaveAngry;
						
						angryBalloon.alpha = 1;

						play("leaveAngry");
						walkSkinSprite.play("leaveAngry");
						
					} 
					else if(this.timeTanning >= untilPissOff)
					{
						if (this.tan >= 0.0 && this.tan < 1.01)
						{
							this.velocity.x = 200.0;
							walkSkinSprite.velocity.x = 200.0;
							
							var thisScore:int = FlxU.mapValues(this.tan, 0, 1.01, -5, 10, true);
							
							if(tan >= 0.9)
							{
								thisScore *= 2;
								(FlxG.state as PlayState).peoplePerLevel += 2;
							}
								
							FlxG.score += thisScore;
							showScore(thisScore);
							
							walkSkinSprite.color = this.calculateTanColor();
							
							this.tanToLeave();
							this.beachState = leaveHappy;

							if(tan >= 0.7)
							{
								happyBalloon.alpha = 1;
								play("leaveHappy");
								walkSkinSprite.play("leaveHappy");
							} else {
								play("walk");
								walkSkinSprite.play("walk");
							}
						}
						else
						{
							this.velocity.x = 250.0;
							walkSkinSprite.velocity.x = 250.0;
							
							var thisScore:int = FlxU.mapValues(this.tan, 1.01, 1.2, 0, 10, true);
							FlxG.score -= thisScore;
							
							showScore(-thisScore);
							
							walkSkinSprite.color = this.calculateTanColor();
							
							this.tanToLeave();
							this.beachState = leaveAngry;

							angryBalloon.alpha = 1;
							
							play("leaveAngry");
							walkSkinSprite.play("leaveAngry");
						}
					}
					break;
				case leaveHappy:
				case leaveAngry:
				default:
					if(this.x > FlxG.width + 0.1 * FlxG.width)		//add a little extra buffer so we are sure he/she is out of screen
					{
						this.beachState = terminated;
						FlxG.state.defaultGroup.remove(walkSkinSprite);
					}
					break;
			}
			
			super.update();
			
			scoreAtPosition.update();
		}
		
		override public function render():void
		{
			super.render();
			
			scoreAtPosition.render();
		}	


		public function getState():int
		{
			return this.beachState;
		}
		
		public function setState(state:int): void
		{
			this.beachState = state;
		}
		
      	public function calculateTanColor(): int
		{
			var red:int = 200 - Math.min(200, 200*tan) / 2;
			
			if( tan < 0.7 ) {
				return FlxU.RGBtoHEX(255,red,red);
			} else if ( tan > 1.0 ) {
				return FlxU.RGBtoHEX(255,red-50,red-20);
			} 
			else {
				return FlxU.RGBtoHEX(210, red * 0.8, red *0.7 );
			}	
		}
		
		private function tanToLeave() :void {
			
			this.alpha = 1.0; //ned schön
			walkSkinSprite.alpha = 1.0;
			
			//quick and dirty zorder hack
			FlxG.state.defaultGroup.remove(this);
			FlxG.state.defaultGroup.remove(walkSkinSprite);
			FlxG.state.defaultGroup.add(walkSkinSprite);
			FlxG.state.defaultGroup.add(this);
			
			if( timeToLeaveClock != null ) {
				FlxG.state.defaultGroup.remove(timeToLeaveClock);
				timeToLeaveClock = null;
			}
			if( lyingBodySprite != null ) {
				FlxG.state.defaultGroup.remove(lyingBodySprite);
				lyingBodySprite = null;
			}
			if( lyingSkinSprite != null ) {
				FlxG.state.defaultGroup.remove(lyingSkinSprite);
				lyingSkinSprite = null;
			}
		}

	}
}