//
//  BookmarkActivity.swift
//  MySafari
//
//  Created by Shridhar Bhalekar on 6/18/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

protocol BookmarkActivityProtocol : NSObjectProtocol {
    func addBookmarkActivity(bookmarkActivity: BookmarkActivity, url: NSURL);
}

class BookmarkActivity: UIActivity {
    var bookmarkURL: NSURL?;
    weak var delegate: BookmarkActivityProtocol?;
    
    override func activityTitle() -> String? {
        return "Add Bookmark";
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "plus");
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        let URLs = activityItems.filter { ( x : AnyObject) -> Bool in
            if x.dynamicType is NSURL.Type {
                return true
            }
            return false
        }
        return URLs.count == 0 ? false : true;
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        let URLs = activityItems.filter { ( x : AnyObject) -> Bool in
            if x.dynamicType is NSURL.Type {
                return true
            }
            return false
        }
        bookmarkURL = URLs.first as? NSURL;
    }
    
    override func performActivity() {
        if let unwrappedURL = bookmarkURL {
            delegate?.addBookmarkActivity(self, url: unwrappedURL);
        }
        activityDidFinish(true);
    }
}
