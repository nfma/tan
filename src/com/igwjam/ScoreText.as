package com.igwjam
{
	
	import flash.geom.Point;
	
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.FlxPoint;
	
	public class ScoreText extends FlxText {

		private var _isAlive:Boolean;
		private var _age:Number;
		private var _targetScale:Number;
		
		public function ScoreText(scale:Number, X:Number, Y:Number, Width:uint, Text:String = null) {
			super(X, Y, Width, Text);
			
			alignment = "center";
			
			_targetScale = 5.0;
			
			this.revive();
		}
		
		public function revive():void {
			alpha = 0.9;
			_age = 0;
			_isAlive = true;
			this.scale = new FlxPoint(2,2);
//			x += width;
			y -= height;
		}
		
		override public function update():void {
			if (_isAlive) {
				if (_age > 1) {
					_isAlive = false;
					this.alpha = 0;
				}
				
				_age += FlxG.elapsed;
				alpha = Math.max(alpha-FlxG.elapsed,0.0);
				
				scale = new FlxPoint((_age+1.0)*_targetScale, (_age+1.0)*_targetScale);
			
			}			
			super.update();
		}
		
		public function set targetScale(targetScale:Number):void {
			_targetScale = targetScale;
		}
	
		public function get isAlive():Boolean {
			return _isAlive;
		}		
	}
}
