package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.external.ExternalInterface;
	
	import landgraph.LandButton;
	
	[SWF( width="960", height="540" )]
	public class LandScapePlayer extends Sprite
	{
		private var metaText:TextField = new TextField();
		private var metaTextTitle:TextField = new TextField();
		private var ChannelLogo:TextField = new TextField();
		private var LandscapeCinema:TextField = new TextField();
		
		private var nc:NetConnection;
		private var ns_in:NetStream;
		private var vid_in:Video;

		private var btn:LandButton;
		private var btnMute:LandButton;
		private var btnV25:LandButton;
		private var btnV50:LandButton;
		private var btnV75:LandButton;
		private var btnV100:LandButton;
		
		private var volume:Number = 1;
		private var videoSound:SoundTransform = new SoundTransform();
		
		public function LandScapePlayer()
		{	
			
			if(ExternalInterface.available) {
			    ExternalInterface.addCallback("initStream", initConnection);
			}

			//Base elements: Video, Logo, Title
			createBaseUI();
		}
		
		private function createBaseUI():void
		{
			vid_in = new Video();
			vid_in.x = 0; 
			vid_in.y = 0;
			vid_in.width = 960;
			vid_in.height = 540;
			addChild( vid_in );
			
			var ChannelLogoFormat:TextFormat = new TextFormat();
			ChannelLogoFormat.size = 12;
			ChannelLogoFormat.bold = true;
			ChannelLogoFormat.color = 0xFFFFFF;
			ChannelLogo.defaultTextFormat = ChannelLogoFormat;
			ChannelLogo.x = 860;
			ChannelLogo.y = 10;
			ChannelLogo.selectable = false;
			ChannelLogo.text = "LandScape\nCinema";
			addChild(ChannelLogo);

			btn =  new LandButton();
			btn.addEventListener(MouseEvent.CLICK, btnPress);
			btn.x = 930;
			btn.y = 516;
			btn.setSize(14,20);
			btn.caption = "i";
			addChild(btn);
			
			var metaFormat:TextFormat = new TextFormat();
			metaFormat.size = 10;
			metaText.defaultTextFormat = metaFormat;	
			metaText.visible = false;
			addChild( metaText );
			
			
			var LandscapeCinemaFormat:TextFormat = new TextFormat();
			LandscapeCinemaFormat.size = 40;
			LandscapeCinemaFormat.align = TextFormatAlign.CENTER;
			LandscapeCinema.defaultTextFormat = LandscapeCinemaFormat;
			LandscapeCinema.x = 380;
			LandscapeCinema.y = 270;
			LandscapeCinema.width = 200;
			LandscapeCinema.height = 100;
			LandscapeCinema.text = "LandScape\nCinema";
			addChild(LandscapeCinema);
		}
		
		private function createVolumeControls():void
		{
			btnMute = new LandButton();
            btnMute.addEventListener(MouseEvent.CLICK, btnMutePress);
            btnMute.x = 50;
            btnMute.y = 516;
            btnMute.setSize(14, 20);
			btnMute.caption = "X";
			addChild(btnMute);

			btnV25 = new LandButton();
            btnV25.addEventListener(MouseEvent.CLICK, btnVolumePress);
            btnV25.x = 10;
            btnV25.y = 531;
            btnV25.setSize(5, 5);
			btnV25.tag = 25;
			addChild(btnV25);

			btnV50 = new LandButton();
            btnV50.addEventListener(MouseEvent.CLICK, btnVolumePress);
            btnV50.x = 20;
            btnV50.y = 526;
            btnV50.setSize(5, 10);
			btnV50.tag = 50;
			addChild(btnV50);

			btnV75 = new LandButton();
            btnV75.addEventListener(MouseEvent.CLICK, btnVolumePress);
            btnV75.x = 30;
            btnV75.y = 521;
            btnV75.setSize(5, 15);
			btnV75.tag = 75;
			addChild(btnV75);

			btnV100 = new LandButton();
            btnV100.addEventListener(MouseEvent.CLICK, btnVolumePress);
            btnV100.x = 40;
            btnV100.y = 516;
            btnV100.setSize(5, 20);
			btnV100.tag = 100;
			addChild(btnV100);
		}
		
		private function btnPress(event:MouseEvent):void
		{
			metaText.visible = !metaText.visible;
		}

		private function btnMutePress(event:MouseEvent):void
		{
		    if(!ns_in) return;
			if(videoSound.volume == 0)
			    videoSound.volume = volume;
			else
			    videoSound.volume = 0;
			ns_in.soundTransform = videoSound;
		}

		private function btnVolumePress(event:MouseEvent):void
		{
		    if(!ns_in) return;
			volume = (event.target as LandButton).tag/100;
			videoSound.volume = volume;
			ns_in.soundTransform = videoSound;
		}
		
		private function initConnection(url:String):void
		{
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.connect(url);
			nc.client = this;
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			if( event.info.code == "NetConnection.Connect.Success" ) { 
				displayPlaybackVideo();
			}
		}
						
		protected function displayPlaybackVideo():void
		{
			ns_in = new NetStream( nc );
			ns_in.client = this;
			ns_in.play( "live" );
			vid_in.attachNetStream( ns_in ); 
			LandscapeCinema.visible = false;
			createVolumeControls();
		}
				
		public function onMetaData( o:Object ):void	
		{
			metaText.x = 600;
			metaText.y = 55;
			metaText.width = 300;
			metaText.height = 285;
			metaText.background = true;
			metaText.backgroundColor = 0x1F1F1F;
			metaText.textColor = 0xD9D9D9;
			metaText.border = true;
			metaText.borderColor = 0xDD7500;
						
			for ( var settings:String in o ) {
				metaText.appendText( settings.toUpperCase() + " = " + o[settings] + "\n" );
			}
			
			metaText.appendText("\n" + " Copyright (c) 2016 Landgraph.ru")
		}
	}
}