import Foundation
class RegExpParser{
    /**
    *
    */
    class func match(){
        
    }
   
    
    private class func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }
    
    class func testing(){
        do {
            let input = "My name is Taylor Swift"
            let regex = try NSRegularExpression(pattern: "My name is (.*)", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count))
            
            if let match = matches.first {
                let range = match.rangeAtIndex(1)
                if let swiftRange = rangeFromNSRange(range, forString: input) {
                    let name = input.substringWithRange(swiftRange)
                    name
                    print(name)
                }
            }
        } catch {
            // regex was bad!
        }
    }
    
    
	/*
	 * Returns an Array with the matches 
	 * EXAMPLE: match("£4$9", "[0-9]", text: string)//Output: [4, 9]
	 * NOTE: NSRegularExpression. (has overview of the regexp syntax supported) https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSRegularExpression_Class/index.html
	 * NOTE: you could try this one too: https://www.hackingwithswift.com/example-code/strings/nsregularexpression-how-to-match-regular-expressions-in-strings
     */
	class func brokenMatch(text: String!, searchPattern: String!, options:NSRegularExpressionOptions = []) -> [String] {
	    do {
	        let regex = try NSRegularExpression(pattern: searchPattern, options: options)
	        let nsString = text as NSString
	        let results = regex.matchesInString(text,options: [], range: NSMakeRange(0, nsString.length))
	        return results.map { nsString.substringWithRange($0.range)}
	    } catch let error as NSError {
	        print("invalid regexp: \(error.localizedDescription)")
	        return []//return empty array
	    }
	}
}