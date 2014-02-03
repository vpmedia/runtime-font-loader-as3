package {

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.etcs.utils.FontLoader;

public class Main extends Sprite {

    private var loader:FontLoader;
    
    private var console:TextField;
    
    public function Main() {
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
    
    private function onAdded(event:Event):void {
        console = new TextField();
        addChild(console);
        console.width = stage.stageWidth;
        console.height = stage.stageHeight;
        console.defaultTextFormat = new TextFormat("Verdana", 12, 0x000000);
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
}

}