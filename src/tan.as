package {
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import com.igwjam.PlayState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")] //Set the size and color of the Flash file

	public class tan extends FlxGame
	{
		public function tan()
		{
			super(640,480,PlayState); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}