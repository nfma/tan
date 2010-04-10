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
			
			super(0, 150);
			loadGraphic(ImgSunDude, true, true, 32, 64);
			
			
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2], 4, true);
			
			this.velocity.x = 50.0;
			this.beachState = walking;
			play("walk");
		}
		
		public function addTan(intensity:Number):void
		{
			tan += intensity * tanMultiplier;
		}
		
		override public function update():void
		{
			//TODO: update statemachine
			var timeSinceStart:Number = (FlxG.state as PlayState).timeSinceStart;
			
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
						this.velocity.x = 50.0;
						if (this.tan > 0.7 && this.tan < 1.0)
						{
							this.beachState = leaveHappy;
							play("leaveHappy");
						}
						else
						{
							this.beachState = leaveAngry;
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