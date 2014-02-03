package {

import flash.display.Sprite;
import flash.events.Event;

import ru.etcs.utils.FontLoader;

public class Main extends Sprite {

    private var loader:FontLoader;
    
    public function Main() {
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
    
    private function onAdded(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        loader = new FontLoader();
    }
}

}