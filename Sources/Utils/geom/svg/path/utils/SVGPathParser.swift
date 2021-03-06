import Foundation
/*
 * variouse methods conserningpathdata both traversing over SVGPath data and svg XML syntax based data
 */
class SVGPathParser {
	/**
	 * Returns an SVGPathData instance from PARAM: data (which is derived directly from the SVG XML formated data
	 * PARAM: data ( M-60-45 L   25.00px,20)
	 * EXAMPLE: SVGPathDataUtils.pathData("M10,10pxH110");//commands: M,H parameters: 10,10,110
	 */
	static func pathData(_ data:String)->SVGPathData {
		var parameters:[CGFloat] = []
		var commands:[String] = []
        ///(?P<cmnd>[MmLlHhVvCcSsQqTtZzAa])(?P<params>[\d\.\-\s\,px]*?)(?=[MmLlHhVvCcSsQqTtZzAa]|$)/g;
		let pattern:String = "([MmLlHhVvCcSsQqTtZzAa])([\\d\\.\\-\\s\\,px]*?)(?=[MmLlHhVvCcSsQqTtZzAa]|$)"//Capturing groups: ?P<cmnd>,?P<params>
        let matches = data.matches(pattern)
        //Swift.print("SVGPathParser.pathData matches.count: " + "\(matches.count)")
        for match:NSTextCheckingResult in matches {/*Loops through the pattern*///TODO: use marches.forEach instead
            //Swift.print("SVGPathParser.pathData() match.numberOfRanges: " + "\(match.numberOfRanges)")
            //let content = (data as NSString).substringWithRange(match.rangeAtIndex(0))//the entire match
            let cmnd = match.value(data,1)/*capturing group 1*/
            //Swift.print("cmnd: >" + cmnd+"<");
            commands.append(cmnd)//command()
            let params = match.value(data,2)/*capturing group 2*/
            //Swift.print("params: >" + params+"<");
            let array:[CGFloat] = SVGPathParser.parameters(params)
            //Swift.print("pathData.parameters: " + array);
            parameters += array//<---this is the same as concat
        }
//		Swift.print("pathData.commands: " + commands);
//		Swift.print("pathData.parameters: " + parameters);
		return SVGPathData(commands,parameters)
	}
    /**
	 * Returns an array comprised of values "sans" its prefix and or suffix
	 * NOTE: cant make this private since polyline and polygon uses this method
     * EXAMPLE: SVGPathParser.parameters("3.0-185.12-89.2")//[3.0, -185.12, -89.2]
     * EXAMPLE: SVGPathParser.parameters("-75,53.571-147.029,36.822-185-89.748")//[-75.0, 53.571, -147.029, 36.822, -185.0, -89.748]
	 * TODO: write more examples in this comment section
	 */
	static func parameters(_ parameters:String)->[CGFloat] {
        //(?<=^|\,|\s|px|\b)\-?\d*?(\.?)((?1)\d+?)(?=px|\s|\,|\-|$)
        let beginning:String = "(?<=^|\\,|\\s|px|\\b|\\d)"//
        let middle:String = RegExpPattern.digitAssertPattern//"\\-?\\d+?"//
        let end:String = "(?=px|\\s|\\,|\\-|$)"
        let pattern:String = beginning + middle + end
        //Swift.print("pattern: " + "\(pattern)")
		let stringArray:[String] = parameters.match(pattern);
        //Swift.print("stringArray: " + "\(stringArray)")
        //Swift.print("SVGPathParser.parameters() stringArray.count: " + "\(stringArray.count)")
        let array:[CGFloat] = stringArray.map {CGFloat(Double($0)!)}//<--temp fix, converts the values in the array to CGFloat
        return array
	}
	/**
	 * Returns the destination end position of a given command at PARAM: commandIndex in PARAM: commands
	 * PARAM: index the index of the command
	 */
	static func end(_ path:SVGPath, _ index:Int)->CGPoint? {// :TODO: rename to position?!?
		let command:String = path.commands[index].lowercased()
		var parameters:Array = SVGPathDataParser.pathData(path, index)
        if(command == "m" || command == "l") {return CGPoint(parameters[0],parameters[1])}
        else if(command == "c") {return CGPoint(parameters[2],parameters[3])}
        else { return nil}//Arc4Parser.end(PathDataParser.arc(pathData));/*PathCommand.ARC_TO*/
	}
	/**
	 * Returns all points in PARAM: path
	 * TODO: impliment native quad to 
	 * TODO: add support for zZ ?!? do we need to?
	 * TODO: cubic and quad curve may have more params and they may have t and s  impliment this
	 */
	static func points(_ path:SVGPath)->[CGPoint] {
		var commands:Array = path.commands
		var params:Array = path.parameters
		var positions:[CGPoint] = []
		var i:Int = 0;/*parameterIndex*/
		var prevP:CGPoint = CGPoint()
		for e in 0..<commands.count{
			let command:String = commands[e]
			let isLowerCase:Bool = StringAsserter.lowerCase(command)
			var pos:CGPoint = isLowerCase ? prevP.copy() : CGPoint()
			switch(command.lowercased()){
				case SVGPathCommand.m,SVGPathCommand.l: //lineTo,moveTo
					pos += CGPoint(params[i+0],params[i+1])
					i += 2
					break;
				case SVGPathCommand.h:/*horizontalLineTo*/
					pos += CGPoint(params[i],isLowerCase ? 0 : prevP.y)
					i += 1
					break;
				case SVGPathCommand.v:/*verticalLineTo*/
					pos += CGPoint(isLowerCase ? 0 : prevP.x,params[i])
					i += 1
					break;
				case SVGPathCommand.c:/*cubicCurveTo*/ // :TODO: this hasn't been tested!!
					pos += CGPoint(params[i+4],params[i+5])
					i += 6
					break;
				case SVGPathCommand.s:/*smooth Cubic curve command*/
					pos += CGPoint(params[i+2],params[i+3])
					i += 4
					break;
				case SVGPathCommand.q:/*quadCurveTo*/
					pos += CGPoint(params[i+2],params[i+3])
					i += 4
					break;
				case SVGPathCommand.t:/*smooth quadratic curve command*/
					pos += CGPoint(params[i],params[i+1])
					i += 2
					break;
                default:break;
			}
			positions.append(pos);
			if(e < commands.count-1 /*&& StringAsserter.lowerCase(commands[i+1])*/) {// :TODO: check for z?
				prevP = pos.copy()
			}
		}
//		Swift.print("positions: " + positions);
		return positions
	}
	/**
	 * Returns an Rectangle instance with points derived from PARAM: path
	 * TODO: arcs and curve bounding boxes will be dificult,but you have code for this, see notebooks
	 */
	static func rectangle(_ path:SVGPath) -> CGRect {
		let points:[CGPoint] = SVGPathParser.points(path)
		return PointParser.rectangle(points)
	}
}