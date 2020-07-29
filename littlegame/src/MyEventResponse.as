/**
 * Created by lixiaopeng on 2020/7/13.
 */
package {
import flash.display.MovieClip;
import flash.events.EventDispatcher;

public class MyEventResponse {
    private var myDispatcher:EventDispatcher = null;
    private var player:MovieClip;
    private var star:MovieClip;
    public function MyEventResponse(player:MovieClip, star:MovieClip) {
        this.myDispatcher = new EventDispatcher();
        this.player = player;
        this.star = star;
    }
    public function addEventListener(type:String,handler:Function):void{
        this.myDispatcher.addEventListener(type,handler);
    }
    public function myEventDispatch():void{
        var event:MyEvent = new MyEvent(MyEvent.Touch, star);
        this.myDispatcher.dispatchEvent(event);
    }
}
}
