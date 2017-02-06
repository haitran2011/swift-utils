import Foundation

public class XMLModifier {
    /**
     * Adds PARAM: child to PARAM: xml at an array index PARAM: index
     * // :TODO: needs some refactoring can we use hasComplexContent as an asserter? research
     */
    static func addChildAt(_ xml:XML,_ index:Array<Int>,_ child:XML) -> XML {// :TODO: rename to addAt?
        let i = index.slice2(0,index.count-1)
        //Swift.print("i: " + "\(i)")
        let parent:XMLElement? = XMLParser.childAt(xml, i)
        //Swift.print("parent: " + "\(parent)")
        _ = parent!.addAt(child,index[index.count-1])
        return xml
    }
    /**
     *
     */
    static func addChildAt(_ xml:XML,_ child:XML,_ index:Int) -> XMLElement {
        return insertAt(xml,index,child)
    }
    /**
     * Inserts PARAM child at PARAM index in PARAM xml
     * NOTE: works similarly to the sprite.addChildAt() function
     */
    static func insertAt(_ xml:XML,_ index:Int,_ child:XML) -> XMLElement {
        xml.insertChild(child, at: index)
        return xml;
    }
    /**
     * EXAMPLE XMLModifier.removeChildAt(xml, [0,0]);
     */
    static func removeChildAt(_ xml:XML,_ index:Array<Int>) -> XMLElement {// :TODO: remove may need to be recursive, rename to removeAt?
        return XMLParser.childAt(xml, index.slice2(0,index.count-1))!.removeAt(index[index.count-1])
    }
    /**
     * Convenince
     */
    static func removeChildAt(_ xml:XML,_ index:Int) -> XMLElement {
        xml.removeChild(at: index)
        return xml
    }
    /**
     * EXAMPLE XMLModifier.setNameAt(database.xml, index, "menu")
     */
    static func setNameAt(_ xml:XML,_ index:Array<Int>, _ name:String) -> XMLElement {
        XMLParser.childAt(xml, index)?.name = name
        return xml
    }
    /**
     * EXAMPLE XMLModifier.setAttributeAt(xml, [0,1], "title", "someTitle")
     * NOTE: I think this method works with depth indecies
     */
    static func setAttributeAt(_ xml:XML,_ index:Array<Int>, _ key:String,_ value:String) -> XMLElement {
        XMLParser.childAt(xml, index)?[key] = value
        return xml
    }
    /**
     * EXAMPLE: setAttributeAt(xml,[0,1],["color":"blue","gradient":"teal"])
     * NOTE: dictionaries are unordered by nature so the attributes may be randomly arranged. To mitigate this maybe implement setting arguments through an array aswell?
     */
    static func setAttributeAt(_ xml:XML,_ index:Array<Int>, _ attributes:Dictionary<String,String>) -> XML {
        XMLParser.childAt(xml, index)?.setAttributesWith(attributes)
        return xml
    }
    /**
     * TODO: Make similar method for multiple key, value pairs
     */
    static func setAttributeAt(_ xml:XML,_ index:Int, _ key:String, _ value:String)->XML{
        let child = XMLParser.childAt(xml.children!, index)
        child![key] = value
        return xml
    }
    /**
     * TODO: Make similar method for multiple key, value pairs
     */
    static func setAttribute(_ xml:XML, _ key:String, _ value:String)->XML{
        xml[key] = value
        return xml
    }
    /**
     * EXAMPLE: replaceChildAt(xml, [0,1], child)
     * NOTE: if the index is out of bound the replacment is appended to the parent index
     */
    static func replaceAt(_ xml:XML,_ index:Array<Int>,_ replacement:XML) -> XML {
        let idx = index.slice2(0,index.count-1)
        let child = XMLParser.childAt(xml, idx)
        _ = child?.replaceAt(xml, index[index.count-1], replacement)
        return xml
    }
    /**
     * EXAMPLE: replaceChildAt(xml, 0, child)
     */
    static func replaceAt(_ xml:XML,_ index:Int,_ replacement:XML) -> XML {
        xml.replaceChild(at: index, with: replacement)//upgraded to swift 3
        return xml
    }    
}
/**
//stringValueAt
//replaceChildrenAt
//removeChildrenAt
//addChildrenAt

addXMLToXMLList,
merge,
setAttribute,
addAttribute,
applyXmlAttributesToObject,
addChildAt,
insertAt,
removeChildAt,
removeChildrenAt,
replaceChildAt,
replaceChildrenAt,
setNameAt,
setAttributeAt,
replace,
sortByName,
sortByAttribute;

*/

 /**
  * Adding attributes to an element: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSXMLElement_Class/
  * more here: https://gist.github.com/brentdax/caaaa134c500e00efd36
  * worth a look (constructing html): https://gist.github.com/brentdax/caaaa134c500e00efd36
  */