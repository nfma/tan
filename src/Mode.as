package {
	import com.adamatomic.Mode.MenuState;
	
	import org.flixel.*;
	
	[SWF(width="1280", height="768", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Mode extends FlxGame
	{
		public function Mode():void
		{
			super(320,240,MenuState,2);
			FlxState.bgColor = 0xff131c1b;
			useDefaultHotKeys = true;
		}
	}
}
