package com.igwjam
{
	import com.igwjam.PlayState;
	
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source="../../../resources/midsky.png")] private var ImgMidSky:Class;
		[Embed(source="../../../resources/beach.png")] private var ImgBeach:Class;
		[Embed(source="../../../resources/water.png")] private var ImgWater:Class;
		
		[Embed(source="../resources/Sniglet.ttf",fontFamily="title")] protected var scoreFont:String;
		
				
		private var levelOne:FlxButton;
		private var levelTwo:FlxButton;
		private var levelThree:FlxButton;
		private var sun:Sun = new Sun;
		
		
		override public function create():void
		{
			var midsky:FlxSprite = new FlxSprite(0,0,ImgMidSky);
			add(midsky);
			
			sun.centerX = FlxG.width/2;
			add(sun);
			FlxG.mouse.show();
			
			var water:FlxSprite = new FlxSprite(0,0,ImgWater);
			add(water);
			
			var beach:FlxSprite = new FlxSprite(0,0,ImgBeach);
			add(beach);			
			
			
			var title:FlxText = new FlxText(130, 140, 400, "Sun of a Beach");
			title.setFormat("title", 60, 0xAA0000FF, "center");
			add(title);
			add(createTextInButton("Easy", new FlxButton(85, 345, playWithLevelOne)));
			add(createTextInButton("Medium", new FlxButton(245, 355, playWithLevelTwo)));
			add(createTextInButton("Hard", new FlxButton(410, 345, playWithLevelThree)));

			FlxG.mouse.show();
		}
		
		private function createTextInButton(text:String, button:FlxButton):FlxButton
		{
			
			var flxText:FlxText = new FlxText(0, 0, 150, text);
			flxText.setFormat("title", 30, 0xAA000000, "center");
			var background:FlxSprite = new FlxSprite(0,0).createGraphic(150,40,0x000000000);
			button.loadGraphic(background);
			button.loadText(flxText);
			return button;
		}
		
		private function playWithLevelOne():void
		{
			FlxG.state = new PlayState(1);
		}

		private function playWithLevelTwo():void
		{
			FlxG.state = new PlayState(2);
		}

		private function playWithLevelThree():void
		{
			FlxG.state = new PlayState(3);
		}
	}
}
