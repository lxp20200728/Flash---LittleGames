/**
 * Created by lixiaopeng on 2020/7/10.
 */
package {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

public class game extends MovieClip{
    public const speedX:int = 2;
    public var addSpeedY:int = -1;
    public var avgLine:int = 0;
    public var tm:Timer = new Timer(1, 1);
    public var upPlayer:MovieClip;
    public var downPlayer:MovieClip;
    private var isClick:Boolean = false;
    private var isJump:Boolean = false;
    private var clickBegin:int = 0;
    private var clickEnd:int = 0;
    public var startJumpSpeed:int = 0;
    public var isJumpUp:Boolean = false;
    public var starArray:Array;
    public var eatCount:int = 0;
    public function game() {
        init();
        this.addEventListener(MouseEvent.MOUSE_OVER, addListener); //添加鼠标移入事件
        this.addEventListener(MouseEvent.MOUSE_OUT, removeListener); //添加鼠标移入事件
    }

    public function init(): void{
        this.gotoAndStop(1);
        upPlayer = this.getChildByName("_upPlayer") as MovieClip;
        downPlayer = this.getChildByName("_downPlayer") as MovieClip;
        avgLine = upPlayer.y + upPlayer.height;
        initPlayerPoint();
        starArray = [];
        for(var i:int = 0; i < 30; i++) {
            var star:Star = new Star();
            star.x = Math.round(Math.random() * 10000) % 720 + i;
            star.y = Math.round(Math.random() * 10000) % (445 - avgLine) + avgLine + i;
            this.addChild(star);
            starArray.push(star);
//            var myEvent:MyEvent = new MyEvent(MyEvent.Touch, star);
//            downPlayer.addEventListener(MyEvent.Touch, removeStar);
//            downPlayer.dispatchEvent(myEvent);
////            var newEvent:NewEvent = new NewEvent(NewEvent.Touch, downPlayer, star);
////            this.addChild(star);
////            myEventDispatcher.addEventListener(NewEvent.Touch, removeStar);
////            myEventDispatcher.dispatchEvent(newEvent);
        }
    }

//    public function removeStar(evt:MyEvent):void{
//        trace("in");
//        if(evt.currentTarget.x <= evt.star.x <= evt.currentTarget.x + evt.currentTarget.width && evt.currentTarget.y + evt.currentTarget.hight * 2 == evt.star.y){
//            trace("you touch the star");
//            evt.currentTarget.removeListener(MyEvent.Touch, evt.star);
//            this.removeChild(evt.star);
//            trace("you have ate one star, nice job!");
//        }
////        if(evt.player.x <= evt.star.x <= evt.player.x + evt.player.width && evt.player.y + evt.player.hight * 2 == evt.star.y){
////            trace("you touch the star");
////            //evt.currentTarget.removeListener(MyEvent.Touch, evt.star);
////
////            this.removeChild(evt.star);
////            trace("you have ate one star, nice job!");
////        }
//    }
    public static function touchStar(player:MovieClip, star:MovieClip, jumpSpeed:int):Boolean{

        return !!(player.x  - player.width <= star.x && star.x <= player.x + player.width
        && player.y + player.height <= star.y && star.y <= player.y + player.height + jumpSpeed);
    }

    public function initPlayerPoint() :void{
        upPlayer.x = 0;
        upPlayer.y = avgLine - upPlayer.height;
        downPlayer.x = 0;
        downPlayer.y = avgLine - downPlayer.height;
    }

    public function addListener(evt:Event):void{
        this.addEventListener(Event.ENTER_FRAME, move);
        this.addEventListener(MouseEvent.MOUSE_DOWN, jump);
        this.addEventListener(MouseEvent.MOUSE_UP, fall);
    }

    public function removeListener(evt:Event):void{
        this.removeEventListener(Event.ENTER_FRAME, move);
        this.removeEventListener(MouseEvent.MOUSE_DOWN, jump);
        this.removeEventListener(MouseEvent.MOUSE_UP, fall);
    }

    public function move(evt:Event):void{
        if(isJump == false){
            if(this.mouseX != upPlayer.x){
                upPlayer.gotoAndStop(2);
                if(this.mouseX > upPlayer.x){
                    if(upPlayer.x + speedX <= this.mouseX){
                        upPlayer.x = upPlayer.x + speedX;
                        downPlayer.scaleX = -1;
                        upPlayer.scaleX = -1;
                    }
                    else
                        upPlayer.gotoAndStop(1);
                }
                else{
                    if(upPlayer.x - speedX >= this.mouseX){
                        upPlayer.x = upPlayer.x - speedX;
                        upPlayer.scaleX = 1;
                        downPlayer.scaleX = 1;
                    }
                    else
                        upPlayer.gotoAndStop(1);
                }
                downPlayer.x = upPlayer.x;
            }
            else{
                upPlayer.gotoAndStop(1);
            }
        }
        if(isClick == false && isJump == true){
            upPlayer.gotoAndStop(1);
            if(isJumpUp){
                upPlayer.y = upPlayer.y - startJumpSpeed * 1;
                startJumpSpeed = startJumpSpeed + addSpeedY;
                if(upPlayer.y + upPlayer.height >= avgLine){
                    upPlayer.y = avgLine - upPlayer.height;
                    startJumpSpeed = - startJumpSpeed;
                    isJumpUp = false;
                }
            }else {
                for(var i:int = 0; i < starArray.length; i++){
                    if(touchStar(downPlayer, starArray[i], startJumpSpeed)){
                        trace("star位置" + starArray[i].x + "   " + starArray[i].y);
                        trace("人物位置" + downPlayer.x + "   " + downPlayer.y + "  " + downPlayer.height);
                        this.removeChild(starArray[i]);
                        eatCount = eatCount + 1;
                        var str:String = eatCount > 1 ? " stars." : " star.";
                        trace("nice job! you have ate " + eatCount + str);
                        starArray[i].x = - 1000;
                        starArray[i].y = - 1000;
                    }
                }
                downPlayer.y = downPlayer.y + startJumpSpeed * 1;
                startJumpSpeed = startJumpSpeed + addSpeedY;
                if (downPlayer.y + downPlayer.height < avgLine) {
                    isJump = false;
                    downPlayer.y = avgLine - downPlayer.height;
                }
            }
        }
    }

    public function jump(evt:Event):void{
        if(isClick == false && isJump == false){
            clickBegin = 0;
            isClick = true;
            clickBegin = getTimer();
        }
    }

    public function fall(evt:Event):void{
        if(isClick == true && isJump == false){
            clickEnd = getTimer();
            isClick = false;
            startJumpSpeed = (((clickEnd - clickBegin) / 1000) * 20) < 30 ? (((clickEnd - clickBegin) / 1000) * 20) : 30;
            isJump = true;
            isJumpUp = true;
        }

    }
}
}
