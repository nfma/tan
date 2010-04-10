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
		
		private var tanText:FlxText;
		private var timeToLeaveText:FlxText;
		
		
		public static const walking:int = 0;
		public static const tanning:int = 1;
		public static const leaveHappy:int = 2;
		public static const leaveAngry:int = 3;
		public static const terminated:int = 4;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int)
		{
			tan = 0;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 380);
			loadGraphic(ImgSunDude, true, true, 32, 64);
			
			tanText = new FlxText(0, 10,FlxG.width);
			tanText.setFormat(null, 8, 0x000000, "left");
			tanText.text = tan.toString();
			
			timeToLeaveText = new FlxText(0, 10,FlxG.width);
			timeToLeaveText.setFormat(null, 8, 0x000000, "left");
			timeToLeaveText.text = timeToLeave.toString();
			
			
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2], 4, true);
			addAnimation("leaveHappy", [0, 1, 2], 2, true);
			addAnimation("leaveAngry", [0, 1, 2], 8, true);
			
			this.velocity.x = 200.0;
			this.beachState = walking;
			play("walk");
		}
		

		public function tanUsingThe(sunXPosition:Number, sunYPosition:Number):void
		{
			if(this.beachState != tanning)
				return;
				
			tan += calculateIntensityWith(sunXPosition, sunYPosition) * tanMultiplier;
			
			tanText.text = (Math.round(tan*100)/100).toString();
		}
		
		private function calculateIntensityWith(sunXPosition:Number, sunYPosition:Number):Number
		{
			var intensity:Number = 1 / Math.sqrt(square(distanceBetween(this.x, sunXPosition)) + square(distanceBetween(this.y, sunYPosition)));
			trace("intensity: " + intensity);
			return square(intensity*20)/20; 	//we want it to be low when the sun is far away and high when it's close sow we square it
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
			var timeSinceStart:Number = (FlxG.state as PlayState).timeSinceStart;
			
			tanText.x = this.x;
			tanText.y = this.y + this.height;
			
			timeToLeaveText.x = this.x;
			timeToLeaveText.y = this.y + this.height + 20;
			
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
					this.timeSinceTanning += FlxG.elapsed;
					
					timeToLeaveText.text = ( Math.round((untilPissOff - timeSinceTanning)*100)/100 ).toString();
					
					if( this.tan > 1.2 )
					{
						this.velocity.x = 250.0;
						this.y = 380;
						FlxG.score -= 20;
						this.beachState = leaveAngry;
						//TODO: make an angry animation 
						play("leaveAngry");
						
					} else if(this.timeSinceTanning >= untilPissOff)
					{
						if (this.tan > 0.7 && this.tan < 1.0)
						{
							this.velocity.x = 200.0;
							this.y = 380;
							
							FlxG.score += 10;
							
							this.beachState = leaveHappy;
							//TODO: make an happy animation 
							play("leaveHappy");
						}
						else
						{
							this.velocity.x = 250.0;
							this.y = 380;
							FlxG.score -= 20;

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
		
		override public function render():void
		{
			super.render();
			
			tanText.render();
			
			timeToLeaveText.render();
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