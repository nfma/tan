package com.igwjam
{
	import org.flixel.*;
	
	public class SunPeople extends FlxSprite
	{
		[Embed(source="../resources/walking_dude.png")] private var ImgSunDude:Class;
		
		
		private var timeToLeave:Number = 0;
		private var timeSinceTanning:Number = 0;
		private var untilPissOff:Number;
		private var tan:Number;
		private var beachState:int;
		private var tanMultiplier:Number;
		private var targetPosition:int;
		
		
		public const walking:int = 0;
		public const tanning:int = 1;
		public const leaveHappy:int = 2;
		public const leaveAngry:int = 3;
		public const terminated:int = 4;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int)
		{
			tan = 0;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 150);
			loadGraphic(ImgSunDude, true, true, 32, 64);
			
			
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2], 4, true);
			addAnimation("leaveHappy", [0, 1, 2], 2, true);
			addAnimation("leaveAngry", [0, 1, 2], 8, true);
			
			this.velocity.x = 50.0;
			this.beachState = walking;
			play("walk");
		}
		
		public function tanUsingThe(sunXPosition:Number, sunYPosition:Number)
		{
			tan += calculateIntensityWith(sunXPosition, sunXPosition) * tanMultiplier;
		}
		
		private function calculateIntensityWith(sunXPosition:Number, sunYPosition:Number):Number
		{
			var intensity:Number = 1 / Math.sqrt(square(distanceBetween(this.x, sunXPosition)) + square(distanceBetween(this.y, sunYPosition)));
			trace("intensity: " + intensity);
			return intensity; 
		}
		
		private function distanceBetween(sun:Number, dude:Number):Number
		{
			return Math.abs(sun - dude);
		}
		
		private function square(number:Number):Number 
		{
			return number * number;
		}
		
		override public function update():void
		{
			//TODO: update statemachine
			var timeSinceStart = (FlxG.state as PlayState).timeSinceStart;
			
			switch(this.beachState)
			{
				case walking:
					if( this.x >= this.targetPosition ) {
						this.x = this.targetPosition;
						this.velocity.x = 0.0;
						
						this.timeToLeave = timeSinceStart + this.untilPissOff;
						this.timeSinceTanning = 0;
						
						play("idle");		//TODO: call the crouching and lying down animation here 
						this.beachState = tanning;
					}
					break;
				case tanning:
					this.timeSinceTanning += FlxG.elapsed;
					if(this.timeSinceTanning >= this.timeToLeave)
					{
						if (this.tan > 0.7 && this.tan < 1.0)
						{
							this.velocity.x = 50.0;
							this.beachState = leaveHappy;
							//TODO: make an happy animation 
							play("leaveHappy");
						}
						else
						{
							this.velocity.x = 100.0;
							this.beachState = leaveAngry;
							//TODO: make an angry animation 
							play("leaveAngry");
							
						}
					}
					break;
				case leaveHappy:
				case leaveAngry:
					if(this.x > FlxG.width + 0.1 * FlxG.width)		//add a little extra buffer so we are sure he/she is out of screen
					{
						this.beachState = terminated;
					}
					break;
					
//				default:
//					break;
			}
			
			super.update();
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