//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

var pattern : String = "^https?:\\/\\/www\\.([a-z]+)\\.[a-z]*";

let regex : NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive);

let addr = "http://www.google.com";


var options = NSMatchingOptions(rawValue: 0);

var result = regex.firstMatchInString(addr, options: options, range: NSMakeRange(0, addr.characters.count));
var range: NSRange? = result?.rangeAtIndex(1)

if let unwrappedRange = range {
    let domain = (addr as NSString).substringWithRange(unwrappedRange);
}