import Foundation

class GradientBoxUtils{
    /**
     * Returns the start and end of a linear gradient (that fills an exact rectangle at any angle) (aka GradientBox)
     * NOTE: this is a really important method concerning gradients. And its pretty well coded and easy to understand.
     * NOTE: there may be faster ways to calculate this so imporve it if its necassery
     * EXAMPLE: GradientBoxUtils.points(CGRect(0,0,100,100), 45*Trig.rad) //Ouputs: 0,0 and 100,100
     */
    static func points(_ rect:CGRect, _ angle:CGFloat)->(start:CGPoint,end:CGPoint){
        //Swift.print("GradientBoxUtils rect: \(rect) angle: \(angle) angle: \(angle)")
        var cornerPoint:CGPoint = CGPoint()
        switch true{
            case CGFloatRangeAsserter.within(Trig.tl, angle):
                cornerPoint = rect.topLeft
            case CGFloatRangeAsserter.within(Trig.tr, angle):
                cornerPoint = rect.topRight
            case CGFloatRangeAsserter.within(Trig.br, angle):
                cornerPoint = rect.bottomRight
            case CGFloatRangeAsserter.within(Trig.bl, angle):
                cornerPoint = rect.bottomLeft
            default:
                fatalError("Angle is out of the allowed range (-π to π): " + "\(angle)")
                break;
        }
        //Swift.print("cornerPoint: \(cornerPoint) rect.center: \(rect.center) ")
        //let normalizedAngle = Trig.normalize(angle)//clamps the angle between: 0 and Math.PI*2 Radian (0 - 6.28)
        //Swift.print("normalizedAngle: \(normalizedAngle) angle: \(angle)")
        let distPoint = PointParser.directionalAxisDistance(rect.center, cornerPoint, angle)
        //Swift.print("distPoint: " + String(distPoint))
        let end:CGPoint = rect.center.polarPoint(distPoint.x, angle)
        //Swift.print("end: " + String(end))
        let start:CGPoint = rect.center.polarPoint(-distPoint.x, angle)
        //Swift.print("start: " + String(start))
        return (start,end)
    }
}
