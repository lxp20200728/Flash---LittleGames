/**
 * Created by lixiaopeng on 2020/7/13.
 */
package {
import flash.display.MovieClip;
import flash.events.Event;

public class MyEvent extends Event{
    public static const Touch:String = "touch";
    public var star:MovieClip;
    public function MyEvent(type:String, star:MovieClip, bubbles:Boolean=false, cancelable:Boolean=false) {
        this.star = star;
        super(type, bubbles, cancelable);
    }
    override public function clone():Event {
        return new MyEvent(type, star);
    }
}
}
