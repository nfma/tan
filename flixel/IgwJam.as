package {
	import org.flixel.*;
	import com.igwjam.PlayState;
	
	[SWF(width="800", height="600", backgroundColor="#44acec")]
	[Frame(factoryClass="Preloader")]

	public class IgwJam extends FlxGame
	{
		public function IgwJam():void
		{
			super(800, 600, PlayState, 1);
			//FlxState.bgColor = 0xff000000;
			//showLogo = true;
			//setLogoFX(0x00000000);
			useDefaultHotKeys = true;
		}
	}
}