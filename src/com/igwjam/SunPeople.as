package com.igwjam
{
	import org.flixel.*;
	
	public class SunPeople extends FlxSprite
	{
		[Embed(source="../resources/walking_dude.png")] private var ImgSunDude:Class;
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
			
			super(0, 380);
			loadGraphic(ImgSunDude, true, true, 32, 64);
			
			tanText = new FlxText(0, 10,FlxG.width);
			tanText.setFormat(null, 8, 0x000000, "left");
			tanText.text = tan.toString();
			
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2], 4, true);
			addAnimation("leaveHappy", [0, 1, 2], 2, true);
			addAnimation("leaveAngry", [0, 1, 2], 8, true);
			
			scoreAtPosition = new ScoreText(1,0,0, 100, "");
			scoreAtPosition.setFormat(null,20,0x119900, "center");
			
			this.velocity.x = 200.0;
			this.beachState = walking;
			play("walk");
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
						this.x = this.targetPosition;
						this.y = 340;
						this.velocity.x = 0.0;
						
						play("idle");		//TODO: call the crouching and lying down animation here 
						this.beachState = tanning;
					}
					break;
				case tanning:
					this.timeTanning += FlxG.elapsed;
					
					if( timeToLeaveClock == null ) {
						timeToLeaveClock = new FlxSprite();
						timeToLeaveClock.loadGraphic(ImgClock, true, true, 16, 16);
						timeToLeaveClock.x = this.x + 8;
						timeToLeaveClock.y = this.y - 20;
						timeToLeaveClock.addAnimation( "clock_running", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], (17.0/untilPissOff), false);
					
						FlxG.state.add(timeToLeaveClock);
						
						trace(untilPissOff/17.0);
						
						timeToLeaveClock.play("clock_running");	
					}
										
					if( this.tan > 1.2 )
					{
						this.velocity.x = 250.0;
						this.y = 380;
						FlxG.score -= 10;
						showScore(-10);

						this.beachState = leaveAngry;
						//TODO: make an angry animation 
						play("leaveAngry");
						
					} else if(this.timeTanning >= untilPissOff)
					{
						if (this.tan > 0.7 && this.tan < 1.0)
						{
							this.velocity.x = 200.0;
							this.y = 380;
							
							FlxG.score += 10;
							showScore(10);
							
							this.beachState = leaveHappy;
							//TODO: make an happy animation 
							play("leaveHappy");
						}
						else
						{
							this.velocity.x = 250.0;
							this.y = 380;
							
							FlxG.score -= 10;
							
							showScore(-10);
							

							this.beachState = leaveAngry;
							//TODO: make an angry animation 
							play("leaveAngry");
							
						}
					}
					break;
				case leaveHappy:
				case leaveAngry:
					if( timeToLeaveClock != null ) {
						FlxG.state.defaultGroup.remove(timeToLeaveClock);
						timeToLeaveClock = null;
					}
					if(this.x > FlxG.width + 0.1 * FlxG.width)		//add a little extra buffer so we are sure he/she is out of screen
					{
						this.beachState = terminated;
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

	}
}