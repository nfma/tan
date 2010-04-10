package com.igwjam
{
	import org.flixel.*;
	
	public class SunPeople extends FlxSprite
	{
		[Embed(source="../resources/walking_dude.png")] private var ImgSunDude:Class;
		
		
		private var timeToLeave:Number;
		private var untilPissOff:Number;
		private var tan:Number;
		private var state:int;
		private var tanMultiplier:Number;
		private var targetPosition:int;
		
		
		public const walking = 0;
		public const tanning = 1;
		public const leaveHappy = 2;
		public const leaveAngry = 3;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int)
		{
			tan = 0;
			timeToLeave = 0; //doesnt work like this because elapsed is time since last FRAME! FlxG.elapsed + untilPissOff;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 150);
			loadGraphic(ImgSunDude, true, true, 32, 64);
			addAnimation("walk", [0, 1, 2], 4, true);
			
			state = walking;
		}
		
		public function addTan(intensity:Number)
		{
			tan += intensity * tanMultiplier;
		}
		
		override public function update():void
		{
			//TODO: update statemachine
			
			switch(state)
			{
				case walking:
					play("walk");
					if(this.velocity.x == 0)
						this.acceleration.x = 20;
					if(this.velocity.x >= 50)
						this.acceleration.x = 0;
					break;
				case tanning:
					break;
				case leaveHappy:
					break;
				case leaveAngry:
					break;
					
//				default:
//					break;
			}
			
			super.update();
		}

		

	}
}