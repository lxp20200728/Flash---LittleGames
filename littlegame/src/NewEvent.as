/**
 * Created by lixiaopeng on 2020/7/13.
 */
package {
import flash.display.MovieClip;
import flash.events.Event;

public class NewEvent extends Event{
    public static const Touch:String = "touch";
    public var star:MovieClip;
    public var player:MovieClip;
    public function NewEvent(type:String, upPlayer:MovieClip, star:MovieClip, bubbles:Boolean=false, cancelable:Boolean=false) {
        this.star = star;
        this.player = upPlayer;
        super(type, bubbles, cancelable);
    }
    override public function clone():Event {
        return new MyEvent(type, player, star);
    }
}
}
