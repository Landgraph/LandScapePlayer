package landgraph
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LandButton extends SimpleButton
	{
		public var label:TextField = new TextField();
		public var labelOver:TextField = new TextField();
		private var up:Sprite = new Sprite();
		private var over:Sprite = new Sprite();
		public var textFormat:TextFormat = new TextFormat();
		public var tag:int = 0;
		
		public function LandButton()
		{	
			label.selectable = false;
			labelOver.selectable = false;
			
			textFormat.align = TextFormatAlign.CENTER;
			
			setSize(150, 50);
			
			super(up,over,over,up);
		}
		
		public function get caption():String {
			return label.text;
		}
		public function set caption(text:String):void {
			label.defaultTextFormat = textFormat;
			labelOver.defaultTextFormat = textFormat;
			label.text = text;
			labelOver.text = text;
			setSize(width, height);
		}
		
		public function setTextPos(x:int=-1, y:int=-1):void {
			if(x!=-1) {
				label.x = x;
				labelOver.x = x;
			}
			if(y!=-1) {
				label.y = y;
				labelOver.y = y;
			}
		}

		public function setSize(nWidth:int, nHeight:int):void {
			up.graphics.clear();
			over.graphics.clear();

			label.width = nWidth;
			label.height = nHeight;
			labelOver.width = nWidth;
			labelOver.height = nHeight;
			
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0xCCFF00);
			up.graphics.drawRect(0,0,nWidth,nHeight);
			up.addChild(label);
			
			over.graphics.lineStyle(1, 0x000000);
			over.graphics.beginFill(0x00CCFF);
			over.graphics.drawRect(0,0,nWidth,nHeight);
			over.addChild(labelOver);
		}
	}
}