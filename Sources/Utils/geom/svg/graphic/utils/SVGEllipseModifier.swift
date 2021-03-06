import Foundation

class SVGEllipseModifier {
    /**
     * Scales the SVGEllipse instance from PARAM: pivot to a specific PARAM: scale scalar value (0-1)
     */
    static func scale(_ ellipse:SVGEllipse,_ pivot:CGPoint,_ scale:CGPoint) {
        let ellipseCenter:CGPoint = PointModifier.scale(ellipse.center, pivot, scale)
        let ellipseRadii:CGPoint = PointModifier.scale(ellipse.radius, pivot, scale)
        ellipse.center = ellipseCenter
        ellipse.radius = ellipseRadii
    }
}