import Foundation

protocol IGradientLineStyle:ILineStyle {
    var gradient:IGradient{get set}
}
extension IGradientLineStyle{
    func mix(_ colors:[CGColor])->GradientLineStyle{
        let c = copy()
        c.gradient.colors = colors
        return c
    }
}