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
		
		
		public const walking:int = 0;
		public const tanning:int = 1;
		public const leaveHappy:int = 2;
		public const leaveAngry:int = 3;
		
		
		public function SunPeople(duration:Number, tanMult:Number, targetPos:int)
		{
			tan = 0;
			timeToLeave = FlxG.elapsed + untilPissOff;
			tanMultiplier = tanMult;
			targetPosition = targetPos;
			
			untilPissOff = duration;
			
			super(0, 150);
			loadGraphic(ImgSunDude, false, false);
			
			this.velocity.x = 50.0;
			this.state = walking;
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
					if( this.x >= this.targetPosition ) {
						this.x = this.targetPosition;
						this.velocity.x = 0.0;
						
						this.state = tanning;
					}
						
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