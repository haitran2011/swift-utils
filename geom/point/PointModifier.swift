import Foundation

class PointModifier {
    /**
     * Rotates a point around a given pivot point
     * PARAM: point The point to rotate.
     * PARAM: pivot the pivot point that PARAM: point is roatated around.
     * PARAM: rot the amount in which to rotate (radians)
     * NOTE: this function does not alter the original point
     * NOTE: this function is keept around to illustrate how to rotate a point around a pivot in regular trig math (Also may be faster than the equvilant function that uses matrix math)
     * TODO: rename to trigRot?!?
     */
    static func rot(point:CGPoint,_ pivot:CGPoint,_ rot:CGFloat)->CGPoint {
        let x:CGFloat = pivot.x + ( cos(rot) * (point.x - pivot.x) - sin(rot) * (point.y - pivot.y))
        let y:CGFloat = pivot.y + ( sin(rot) * (point.x - pivot.x) + cos(rot) * (point.y - pivot.y))
        return CGPoint(x,y)
    }
    /**
     * PARAM: rotation must be between -PI and +PI
     */
    static func safeRotatePoint(pivot:CGPoint, _ point:CGPoint, _ rotation:CGFloat)->CGPoint {
        let pointAngle:CGFloat = Trig.angle(pivot, point)//find the angle of point
        //Swift.print("pointAngle: " + "\(pointAngle)")
        let distance:CGFloat = PointParser.distance(pivot, point)//length of point and pivotPoint
        let rot:CGFloat = Trig.normalize2(pointAngle + rotation)//sum of pointAngle and rotation, normalize this aka clamp between (-π and π)
        //Swift.print("rot: " + "\(rot)")
        return pivot + PointParser.safePolar(distance, rot)//use Point.polar
    }
    /**
     * UNTESTED, but should work
     * Returns a point rotated around a pivot point
     * NOTE: does not modifify the PARAM: point
     * TODO: rename to matrixRot?
     */
    static func rotatePoint(point:CGPoint, _ pivot:CGPoint, _ rotation:CGFloat) -> CGPoint {
        var transform = CGAffineTransformIdentity//var matrix:Matrix = new Matrix();
        transform.rotateAroundPoint(rotation, pivot)//MatrixModifier.rotateAroundExternalPoint(matrix, pivot, rotation);
        return CGPointApplyAffineTransform(point, transform)//matrix.transformPoint(point)
    }
    /**
     * Untested, but should work
     */
    static func matrixRot(point:CGPoint,  _ rotation:CGFloat) -> CGPoint {
        var transform = CGAffineTransformIdentity//var matrix:Matrix = Matrix();
        transform.rotate(rotation)//matrix.rotate(rotation);
        return CGPointApplyAffineTransform(point, transform)//matrix.transformPoint(point);
    }
    /**
     * Returns points rotated around a pivot point
     * NOTE: does not modifiy the original points
     * PARAM: rotation: in radians (suppers radian values from -∞ to +∞)
     * TODO: make a similar method that takes initPoints and points, this way you avoid recrating a new array everytime
     */
    static func rotatePoints(points:Array<CGPoint>, _ pivot:CGPoint, _ rotation:CGFloat) -> Array<CGPoint> {
        var rotatedPoints:Array<CGPoint> = []
        var transform = CGAffineTransformIdentity//var matrix:Matrix = new Matrix()
        transform.rotateAroundPoint(rotation, pivot)//MatrixModifier.rotateAroundExternalPoint(matrix, pivot, rotation)
        for point : CGPoint in points { rotatedPoints.append(CGPointApplyAffineTransform(point, transform))}
        return rotatedPoints
    }
    /**
     * Scales PARAM: p at PARAM: pivot with PARAM: scale
     * EXAMPLE: PointModifier.scale(CGPoint(0,0), CGPoint(40,40), CGPoint(2,2))//Output: (-40.0, -40.0)
     */
    static func scale(p:CGPoint,_ pivot:CGPoint,_ scale:CGPoint/*0-1*/)->CGPoint{
        var transform = CGAffineTransformIdentity
        transform.scaleFromPoint(scale.x, scale.y, pivot)
        return CGPointApplyAffineTransform(p, transform)
    }
    /**
     * Scales an array of points from PARAM: pivotPoint to PARAM: xScale and PARAM: yScale 
     * NOTE: Does not modify the original array
     * PARAM: points reoresents the points to be scaled
     * PARAM: pivot represents the origin point where the PARAM: points are scaled from 
     * PARAM: scale represents the x and y axis scale ratio
     * EXAMPLE: 
     * circle.setPosition(100,100)
     * var pivotPoint:Point = new Point(50,50)
     * var scaledPoints:Array = PointModifier.scalePoints([new Point(circle.x,circle.y)], pivotPoint,1, 1.5)
     * circle.setPosition(scaledPoints[0]);//Output: the circle is now at 100,125
     */
    static func scalePoints(points:Array<CGPoint>,_ pivot:CGPoint,_ scale:CGPoint)->Array<CGPoint>{
        var scaledPoints:Array<CGPoint> = []
        for p : CGPoint in points{ scaledPoints.append(PointModifier.scale(p,pivot,scale))}
        return scaledPoints
    }
    /**
     * Use this when you want to scale the points directly
     */
    static func scalePoints(inout points:Array<CGPoint>,_ pivot:CGPoint,_ scale:CGPoint) {
        for var i = 0; i < points.count; ++i{points[i] = PointModifier.scale(points[i],pivot,scale)}
    }
    /**
     * Multiplies x and y in PARAM: point with PARAM: multiplier
     */
    static func multiply(point:CGPoint,_ multiplier:CGFloat) -> CGPoint {
        return CGPoint(point.x * multiplier,point.y * multiplier)
    }
}