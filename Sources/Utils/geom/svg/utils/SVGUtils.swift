import Cocoa
/*
 * XML utility methods
 * NOTE: This class has methods that convert SVG elements into XML
 */
class SVGUtils {
	/**
	 * Returns svg syntax in an XML instance derived from PARAM: svg 
	 * PARAM: svg (instance of a custom SVG class that is easy to work with)
	 * NOTE: for the reverse function look into using the adobe native functionality namespaceDeclarations, namespace to also include the namespace
	 */
	static func xml(_ svg:SVG)->XML {// :TODO: refactor to one or loop?
		let xml:XML = SVGUtils.svg(svg)
		for i in 0..<svg.items.count{
			let svgElement:ISVGElement = svg.items[i]
			var child:XMLElement
            if(svgElement is SVGLine) {child = line(svgElement as! SVGLine)}
            else if(svgElement is SVGRect) {child = rect(svgElement as! SVGRect)}
            else if(svgElement is SVGPath) {child = path(svgElement as! SVGPath)}
            else if(svgElement is SVGGroup) {child = group(svgElement as! SVGGroup)}
            else {fatalError("type not supported: " + "\(svgElement)")}
            xml.appendChild(child)
		}
		return xml
	}
	/**
	 * Returns pathData from PARAM: path (SVGPath instance)
	 */
	static func pathData(_ path:SVGPath)->String {
		var pathData:String = ""
		let commands:[String] = path.commands
		var parameters:[CGFloat] = path.parameters
		var index:Int = 0
		for command:String in commands {
			if(command.test("[m,M,l,L,t,T]")) {
				pathData += command + String(parameters[index]) + " " + String(parameters[index + 1]) + " "
				index += 2
			}else if(command.test("[h,H,v,V]")){
				pathData += command + String(parameters[index]) + " "
				index += 1
			}else if(command.test("[s,S,q,Q]")){
				pathData += command + String(parameters[index]) + " " + String(parameters[index+1]) + " " + String(parameters[index+2]) + " " + String(parameters[index+3]) + " "
				index += 1
			}else if(command.test("[c,C]")){
				pathData += command + String(parameters[index]) + " " + String(parameters[index+1]) + " " + String(parameters[index+2]) + " " + String(parameters[index+3]) + " " + String(parameters[index+4]) + " " + String(parameters[index+5]) + " ";
				index += 1
			}else if(command.test("[a,A]")){
				pathData += command + String(parameters[index]) + " " + String(parameters[index+1]) + " " + String(parameters[index+2]) + " " + String(parameters[index+3]) + " " + String(parameters[index+4]) + " " + String(parameters[index+5]) + " " + String(parameters[index+6]) + " ";
				index += 1
			}else if(command.test("[z,Z]")){
				pathData += command + " "
				index += 1
			}
		}
		pathData = pathData.replace("\\s*?$", "")/*Removes the ending whitespace, if it exists*/
		return pathData
	}
	/**
	 * Returns the root node for the SVG XML document
	 */
	static func svg(_ svg:SVG)->XML {
		let xml:XML = "<?xml version=“1.0”?><svg></svg>".xml
		xml["xmlns"] = "http://www.w3.org/2000/svg"
		xml["x"] = svg.frame.x.string+"px"
		xml["y"] = svg.frame.y.string+"px"
		xml["width"] = svg.width.string + "px"
		xml["height"] = svg.height.string + "px"
		return xml
	}
	/**
	 * Returns a svg line in SVG XML notation from PARAM: line (SVGLine)
	 */
	static func line(_ line:SVGLine)->XML {
		var xml:XML = "<line></line>".xml
		xml = id(xml,line);
		xml["x1"] = line.x1.string
		xml["y1"] = line.y1.string
		xml["x2"] = line.x2.string
		xml["y2"] = line.y2.string
		xml = style(xml,line)
		return xml
	}
	/**
	 * Returns a svg rect in SVG XML notation from PARAM: rect (SVGRect)
	 */
	 static func rect(_ rect:SVGRect)->XML {//NOTE:: API<rect x="64" y="64" fill="none" stroke="#000000" stroke-miterlimit="10" width="512" height="512"/>
		var xml:XML = "<rect></rect>".xml
		xml = id(xml,rect);
		xml["x"] = rect.frame.x.string
		xml["y"] = rect.frame.y.string
		xml["width"] = rect.width.string
		xml["height"] = rect.height.string
		xml = style(xml,rect)
		xml["stroke-miterlimit"] = rect.style!.strokeMiterLimit!.string
		return xml
	 }
	 /**
	  * Returns an SVGPath instance in SVG XML notation from PARAM: path (SVGPath)
	  */
	 static func path(_ path:SVGPath)->XML {
         var xml:XML = "<path></path>".xml
		 xml = id(xml,path)
		 xml["d"] = SVGUtils.pathData(path)
		 xml = style(xml,path)
		 return xml
	 }
	 /**
	  * Returns an XML instance with SVGGroup data derived from PARAM: group
	  * NOTE: this method is recursive
	  * TODO: remeber groups can have style applied inline cant they?
	  */
	 static func group(_ group:SVGGroup) -> XML {
		 var xml:XML = "<g></g>".xml
		 xml = id(xml,group);
		 /*xml = style(xml,group); not supported yet*/
		 for i in 0..<group.items.count{
			 let svgGraphic:ISVGElement = group.items[i] as ISVGElement
			 var child:XML
             if(svgGraphic is SVGLine) {child = line(svgGraphic as! SVGLine)}
             else if(svgGraphic is SVGRect) {child = rect(svgGraphic as! SVGRect)}
             else if(svgGraphic is SVGPath) {child = path(svgGraphic as! SVGPath)}
             else if(svgGraphic is SVGGroup) {child = SVGUtils.group(svgGraphic as! SVGGroup)}
             else{ fatalError("type not supported: " + "\(svgGraphic)")}
             xml.appendChild(child)
		 }
		 return xml
	 }
	 /**
	  * Returns the id from a ISVG instance
	  * TODO: move to an internal class
	  */
	 static func id(_ xml:XMLElement,_ svg:ISVGElement)->XML {
         if(svg.id != ""/*<-this was nil*/) {xml["id"] = svg.id}
		 return xml
	 }
	 /**
	  * Returns an XML instance with style properties derived from PARAM: xml
	  * TODO: move to an internal class
	  */
	 static func style(_ xml:XMLElement,_ graphic:SVGGraphic)->XML {
        
         //this method is missing support for gradient (Get clues from the legacy SVGPropertyParser)
        
         xml["fill"] = graphic.style!.fill is Double && !((graphic.style!.fill as! Double).isNaN) ? "#"+HexParser.hexString(UInt(graphic.style!.fill as! Double)):"none"
		 xml["stroke"] = graphic.style!.stroke is Double && !(graphic.style!.stroke as! Double).isNaN ? "#"+HexParser.hexString(UInt(graphic.style!.stroke as! Double)):"none"
         if(graphic.style!.strokeWidth != nil && !graphic.style!.strokeWidth!.isNaN && graphic.style!.strokeWidth! != 1) {xml["stroke-width"] = "\(graphic.style!.strokeWidth!)"}/*if strokeWidth is 1 then you dont have to include it in the svg, this is considered a default value if stroke is avialbale*/
		 // :TODO: add support for fillOpacity,fillRule,strokeOpacity,strokeLineCap,strokeLineJoin,strokeMiterLimit, (Get ques from the old SVGPropertyParser)
		 return xml
	 }
}
