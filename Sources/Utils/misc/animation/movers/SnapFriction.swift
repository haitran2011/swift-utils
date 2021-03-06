import Foundation

class SnapFriction:Friction {
    var snap:CGFloat
    var minVelocity:CGFloat = 0.8
    init(_ view:IAnimatable,  _ callBack:@escaping (CGFloat)->Void,_ value:CGFloat, _ velocity:CGFloat = 0, _ frictionStrength:CGFloat = 0.98, _ snap:CGFloat = 0,_ minVelocity:CGFloat = 0.8){
        self.snap = snap
        self.minVelocity = minVelocity
        super.init(view, callBack, value, velocity, frictionStrength)
    }
    override func applyFriction() {
        //keep some velocity alive
        //when at snap stop
        if(velocity <= minVelocity){
            let modulo:CGFloat = (value %% snap)
            //Swift.print("modulo: " + "\(modulo)")
            if(modulo.isNear(0, minVelocity)){//modulo is closer than 1 px to 0,
                stop()
            }
            velocity = minVelocity
        }else{
            super.applyFriction()//regular friction
        }
    }
}
