package com.igwjam
{
	import org.flixel.*;
	
	public class SunPeople extends FlxSprite
	{
		[Embed(source="../resources/lying_body.png")] private var ImgLyingBody:Class;
		[Embed(source="../resources/lying_skin.png")] private var ImgLyingSkin:Class;
		
		[Embed(source="../resources/walk_skin.png")] private var ImgWalkSkin:Class;
		[Embed(source="../resources/walk_body.png")] private var ImgWalkBody:Class;
		
		[Embed(source="../resources/clock.png")] private var ImgClock:Class;

		
		private var timeToLeave:Number = 0;
		private var timeTanning:Number = 0;
		private var untilPissOff:Number;
		private var tan:Number;
		private var beachState:int;
		private var tanMultiplier:Number;
		private var targetPosition:int;
		
		private var tanText:FlxText;
		private var timeToLeaveClock:FlxSprite = null;
		private var scoreAtPosition:ScoreText;
		

		private var lyingBodySprite:FlxSprite = null;
		private var lyingSkinSprite:FlxSprite = null;
		
		private var walkSkinSprite:FlxSprite = null;

		private var difficultyLevel:Number;
		
		
		public static const walking:int = 0;
		public static const tanning:int = 1;
		public static const leaveHappy:int = 2;
		public static const leaveAngry:int = 3;
		public static const terminated:int = 4;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int, difficultyLevel:Number)
		{
			this.difficultyLevel = difficultyLevel; 
			tan = 0;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 300);
			loadGraphic(ImgWalkBody, true, true, 65, 140);
			
			walkSkinSprite = new FlxSprite(0,300);
			walkSkinSprite.loadGraphic(ImgWalkSkin, true, true, 65, 140);
			FlxG.state.add(walkSkinSprite);
			walkSkinSprite.color = this.calculateTanColor();
			
			tanText = new FlxText(0, 10,FlxG.width);
			tanText.setFormat(null, 8, 0x000000, "left");
			tanText.text = tan.toString();
			

			addAnimation("walk", [0, 1, 2,3], 4, true);
			addAnimation("leaveHappy", [0, 1, 2,3], 2, true);
			addAnimation("leaveAngry", [0, 1, 2,3], 8, true);
			
			walkSkinSprite.addAnimation("walk", [0, 1, 2,3], 4, true);
			walkSkinSprite.addAnimation("leaveHappy", [0, 1, 2,3], 2, true);
			walkSkinSprite.addAnimation("leaveAngry", [0, 1, 2,3], 8, true);
			
			scoreAtPosition = new ScoreText(1,0,0, 100, "");
			scoreAtPosition.setFormat(null,20,0x119900, "center");
			
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
			
			tanText.text = (Math.round(tan*100)/100).toString();
		}
		
		private function calculateIntensityWith(sun:Sun):Number
		{
			var xDistance:Number = Math.max(distanceBetween(this.centerX, sun.centerX), 10);	//now we have a area of 20 pixel around the center where the intensity is max!
			var yDistance:Number = distanceBetween(240, sun.top);		//sun.y because that's the top left corner...and we want the top!
			
			var intensity:Number = (1/(xDistance*50)) * yDistance/240;
//			return intensity;
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
			scoreAtPosition.centerY = centerY - height;
			scoreAtPosition.revive();
		}
		
		override public function update():void
		{
			//TODO: update statemachine			
			tanText.x = this.x;
			tanText.y = this.y + this.height;
			
			//timeToLeaveText.x = this.x;
			//timeToLeaveText.y = this.y + this.height + 20;
			
			switch(this.beachState)
			{
				case walking:
					if( this.x >= this.targetPosition ) {
					
						this.velocity.x = 0.0;
						walkSkinSprite.velocity.x = 0.0;
						
						this.beachState = tanning;
						
						this.alpha = 0.0;
						walkSkinSprite.alpha = 0.0;
						
						lyingBodySprite = new FlxSprite(this.targetPosition-70,340,ImgLyingBody);
						lyingSkinSprite = new FlxSprite(this.targetPosition-70,340,ImgLyingSkin);
						
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
						timeToLeaveClock.y = this.y - 60;
						timeToLeaveClock.addAnimation( "clock_running", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], (17.0/untilPissOff), false);
					
						FlxG.state.add(timeToLeaveClock);
						
						trace(untilPissOff/17.0);
						
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
						//TODO: make an angry animation 
						play("leaveAngry");
						walkSkinSprite.play("leaveAngry");
						
					} else if(this.timeTanning >= untilPissOff)
					{
						if (this.tan >= 0.0 && this.tan < 1.01)
						{
							this.velocity.x = 200.0;
							walkSkinSprite.velocity.x = 200.0;
							
							var thisScore:int = FlxU.mapValues(this.tan, 0, 1.01, 0, 10, true);
							
							if(tan >= 1)
								thisScore *= 2;
								
							FlxG.score += thisScore;
							showScore(thisScore);
							
							walkSkinSprite.color = this.calculateTanColor();
							
							this.tanToLeave();
							this.beachState = leaveHappy;
							//TODO: make an happy animation 
							play("leaveHappy");
							walkSkinSprite.play("leaveHappy");
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
							//TODO: make an angry animation 
							play("leaveAngry");
							walkSkinSprite.play("leaveAngry");
							
						}
					}
					break;
				case leaveHappy:
				case leaveAngry:
					
					
					if(this.x > FlxG.width + 0.1 * FlxG.width)		//add a little extra buffer so we are sure he/she is out of screen
					{
						this.beachState = terminated;
						FlxG.state.defaultGroup.remove(walkSkinSprite);
					}
					break;
					
//				default:
//					break;
			}
			
			super.update();
			
			scoreAtPosition.update();
		}
		
		override public function render():void
		{
			super.render();
			
			tanText.render();
			
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
				return FlxU.RGBtoHEX(210,red / 2+40, red/2+10 );
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