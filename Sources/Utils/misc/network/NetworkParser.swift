import Foundation
class NetworkParser{
	/**
	 * Returns a string for a URL
	 */
	static func string(_ URL:String)->String{
        //TODO: needs research
		/*
        let theURL = NSURL(string: URL)
		let rssUrlRequest:NSURLRequest = NSURLRequest(URL:theURL!)
	 	let queue:NSOperationQueue = NSOperationQueue()
	 	//the bellow is sudo code
	 	let result = NSURLConnection.sendAsynchronousRequest(, queue: , completionHandler: )
		return result
        */
        return ""
	}
    /**
     * PARAM: url: "https://www.google.com"
     */
    static func stringContent(_ url:String)->String{
        //TODO: needs research
        if let urlObj = URL(string:url) {
            do {
                let contents = try NSString(contentsOf: urlObj, usedEncoding: nil)
                print(contents)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        return ""
    }
}