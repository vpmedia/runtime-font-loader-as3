package {

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.etcs.utils.FontLoader;

public class Main extends Sprite {

    [Embed(source = "/../resources/verdanaBold3.swf", mimeType="application/octet-stream")]
    public var fontClass:Class;
    
    private var loader:FontLoader;
    
    private var console:TextField;
    
    private var isComplete:Boolean;
    
    public function Main() {
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
    
    private function onAdded(event:Event):void {
        console = new TextField();
        addChild(console);
        console.width = stage.stageWidth;
        console.height = stage.stageHeight;
        console.defaultTextFormat = new TextFormat("Verdana3", 12, 0x000000);
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        loader = new FontLoader();
        loader.addEventListener(Event.COMPLETE, onCompleteSWF);
        console.text += "Loading SWF... \n";
        loader.load(new URLRequest("../src/main/resources/verdana3.swf"));
    }
    
    private function onCompleteSWF(event:Event):void {
        trace(this, "onCompleteSWF: " + loader.fonts);
        console.text += loader.fonts.toString() + "\n";
        loader.removeEventListener(Event.COMPLETE, onCompleteSWF);
        loader.addEventListener(Event.COMPLETE, onCompleteBytes);
        console.text += "Loading Bytes... \n";
        loader.loadBytes(new fontClass());
    }
    
    private function onCompleteBytes(event:Event):void {
        trace(this, "onCompleteBytes: " + loader.fonts);
        console.text += loader.fonts.toString() + "\n";
        console.setTextFormat(new TextFormat("VerdanaBold3", 12, 0x000000,true));
        loader.removeEventListener(Event.COMPLETE, onCompleteBytes);
    }
}

}