import Cocoa
import QuartzCore
/**
 * set needsDisplay = true to clear the graphics
 * TODO: Write an example
 * NOTE: Example is in the Graphics class
 * NOTE: you can set the position by calling: graphic.frame.origin = CGPoint()
 */
class Graphic:FlippedView,IGraphic{
    lazy var fillShape:Shape = Shape()
    lazy var lineShape:Shape = Shape()//{get{return fillShape}set{fillShape = newValue}}/*Shape()*/
    var fillStyle:IFillStyle?
    var lineStyle:ILineStyle?
    var lineOffsetType:OffsetType;
    //override var wantsDefaultClipping:Bool{return false}//avoids clipping the view, not needed when you use layer-hosted
    //override var wantsUpdateLayer:Bool {return true}
    init(_ fillStyle:IFillStyle? = nil, _ lineStyle:ILineStyle? = nil, _ lineOffsetType:OffsetType = OffsetType()){
        //Swift.print("Graphic.init()")
        self.fillStyle = fillStyle
        self.lineStyle = lineStyle
        
        self.lineOffsetType = lineOffsetType
        super.init(frame:NSRect(0,0,0/*<- was 1*/,0/*<- was 1*/))//<---move this into the arguments/*the width and the height arent clipped*/
        
        //layerContentsRedrawPolicy = NSViewLayerContentsRedrawPolicy.OnSetNeedsDisplay//this is new, but apple recomends it, more about it here: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/SettingUpLayerObjects/SettingUpLayerObjects.html#//apple_ref/doc/uid/TP40004514-CH13-SW4
        layer = CALayer()//TempCALayer(layer: layer!)
        wantsLayer = true//this avoids calling drawLayer() and enables drawingRect()
        
        
        /*layer!.shadowColor = NSColor.blackColor().CGColor;
        layer!.shadowOpacity = 1.0;
        layer!.shadowRadius = 5.0;
        layer!.shadowOffset = CGSizeMake(0, 3);
        */
        //layer!.frame = NSRect(0,0,1,1)
        //layer?.display()
        //layer?.needsLayout()
        
        
        layer!.masksToBounds = false//this is needed!!!
        layer?.addSublayer(fillShape)
        //fillShape.delegate = self
        layer?.addSublayer(lineShape)
        
        
    }
    
    /**
    * If you do not implement this method, the layer calls the drawLayer:inContext: method instead.
     * NOTE: you can probably derive the cgcontext from inside this method. by utilizing the graphics.contect etc.
    */
     /*
     override func  displayLayer(layer: CALayer){
     Swift.print("Graphic.displayLayer: " + "\(layer)")
     }
     */
    /*
    override func updateLayer(){
        Swift.print("Graphic.updateLayer()")
    }
    override func layout(){
        Swift.print("Graphic.layout()")
    }
     */
    /*
    override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    }
    */
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}/*Required by super class*/
    /**
     *
     */
    /*
    
    override func drawRect(dirtyRect: NSRect) {
        Swift.print("Graphic.drawRect() ")
        super.drawRect(dirtyRect)
    }
    */
    
    /**
     * NOTE: Convenience method
     */
    func setDelegate(delegate:AnyObject){
        fillShape.delegate = delegate
        lineShape.delegate = delegate
    }
    
    
    /**
     * Convenince implicit setter
     */
    func setProperties(fillStyle:IFillStyle? = nil, lineStyle:ILineStyle? = nil){// :TODO: remove this and replace with setLineStyle and setFillStyle ?
        self.fillStyle = fillStyle;
        self.lineStyle = lineStyle;
    }
}
