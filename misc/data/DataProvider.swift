import Foundation
/*
 *
 * // :TODO: impliment allowDuplicates
 * // :TODO: replaceItem
 * // :TODO: merge() appends and removes duplicates
 * // :TODO: clone()
 * // :TODO: removeAll()
 * // :TODO: removeDuplicates
 * // :TODO: sortOn
 * // :TODO: outsource static pricate functions
 * // :TODO: Do we need a DataProviderItem?
 * // :TODO: create DataProviderItem that extends a proxy class so that it can hold virtual properties, shouuld have title and data as getters and setters
 *
 * @example
 * var orange:Object = {name:"orange", title:"harry"}
 * var blue:Object = {name:"blue", url:"na"}
 * var red:Object = {name:"red", headline:"spring"}
 * var dp:DataProvider = new DataProvider();
 * dp.addItem(orange);
 * dp.addItem(blue);
 * dp.addItem(red);
 * dp.removeItemAt(dp.getItemIndex(orange))
 * trace(dp.length())
 */
class DataProvider :EventSender{
    private var items:Array<AnyObject> = []
    override init(){
        super.init()
    }
}
