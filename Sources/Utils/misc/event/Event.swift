import Foundation
/*
 * TODO: Implement the immediate variable if its needed (it would be a way to get assert the 1-level down immediate child an event came from, rather than the origin child which can be many levels deeper in the hierarchy)
 * NOTE: Event could be a struct, most Event classes are really simple and their passed data could be accessed via origin, maybe try using a struct for Element iOS
 * TODO: Event should extend string or stringconvertible etc. So that one can do onEvent(.update) the subclasses can do .mouseDown etc
 */
class Event{
    static var update:String = "eventUpdate"/*Ideally I would name this change but apparently then subclasses can name their const the same*/
    var type:String
    var origin:AnyObject/*origin sender of event, this could also be weak if you discover a memory leak*///TODO:this should be of type IEventSender
    var immediate:AnyObject/*previouse sender of event*///TODO:this should be of type IEventSender
    init(_ type:String = "", _ origin:AnyObject){
        self.type = type
        self.origin = origin
        self.immediate = origin
    }
}
