import Cocoa
/**
 * NOTE: Shape is a convenient way to seperate drawing the stroke and the fill. ("Composite drawing") 
 * NOTE: Ultimatly you should have both stroke and fill in the same layer, as I suspect both contexts are redrawn if either change anyway. 
 */
class Shape:CALayer{
    //override func containsPoint(p: CGPoint) -> Bool {return true}
    //override func hitTest(p: CGPoint) -> CALayer? {return self}
    lazy var graphics:Graphics = Graphics()//Delays the creation of graphics until it is needed, keep in mind that you cant create this instance before drawRect is called
    var path:CGMutablePath = CGMutablePath()
    /**
     * NOTE: If you zoom this class in. you need to change the contentScale appropriatly. Zoom 2x on a retina screen: (2x2=4) Zoom 4x on a retina screen: (2x2=4) etc
     */
    override init(){
        super.init()
        //self.needsDisplayOnBoundsChange = true//<--new I presume?
        self.contentsScale = 2.0/*<--Makes lines smooth on retina screens, you may wan't to consider toggeling this on non-retina displays. From apple docs: The default value of this property is 1.0. For layers attached to a view, the view changes the scale factor automatically to a value that is appropriate for the current screen. For layers you create and manage yourself, you must set the value of this property yourself based on the resolution of the screen and the content you are providing. Core Animation uses the value you specify as a cue to determine how to render your content.*/
    }
    override func hitTest(_ p:CGPoint) -> CALayer? {
        return super.hitTest(p)
    }
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    override func draw(in ctx:CGContext) {
        super.draw(in: ctx)
    }
    /*override func containsPoint(p: CGPoint) -> Bool {
        //add path inside code here
        return true
    }*/
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
