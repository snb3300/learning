//
//  ViewController.swift
//  MySafari
//
//  Created by Shridhar Bhalekar on 6/15/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

enum defaultBookmarks : String {
    case apple = "http://www.apple.com/"
    case google = "http://www.google.com/"
    case cricinfo = "http://www.cricinfo.com/"
}

class Bookmark : NSObject {
    var url: String;
    var title: String;
    
    init(url: String, title:String) {
        self.url = url;
        self.title = title;
        super.init();
    }
}


class ViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate, BookmarkTableViewControllerDelegate, BookmarkActivityProtocol {

    @IBOutlet weak var webViewForward: UIBarButtonItem!
    @IBOutlet weak var webViewBack: UIBarButtonItem!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var webView: UIWebView!
    
    var bookmarks: [Bookmark] = [Bookmark(url: defaultBookmarks.apple.rawValue, title: "Apple"),
                                 Bookmark(url: defaultBookmarks.google.rawValue, title: "Google"),
                                 Bookmark(url: defaultBookmarks.cricinfo.rawValue, title: "CricInfo")];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlField.delegate = self;
        webView.delegate = self;
        webViewBack.enabled = false;
        webViewForward.enabled = false;
    }
    
//    override func viewWillAppear(animated: Bool) {
//        webViewBack.enabled = false;
//        webViewForward.enabled = false;
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let urlString = textField.text;
        return gotoWebSite(urlString);
    }
    
    func bookmarkTableViewController(controller: BookmarkTableViewController, didSelectBookmark: Bookmark) {
        print("User selected \(didSelectBookmark.title)");
        gotoWebSite(didSelectBookmark.url);
        navigationController?.popToRootViewControllerAnimated(true);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tvc = segue.destinationViewController as? BookmarkTableViewController {
            tvc.bookmarks = bookmarks;
            tvc.delegate = self;
        }
    }
    
    @IBAction func shareURL(sender: UIBarButtonItem) {
        if let urlToShare = webView.request?.URL {
            let bookmarkActivity = BookmarkActivity();
            let vc = UIActivityViewController(activityItems: [urlToShare], applicationActivities: [bookmarkActivity]);
            bookmarkActivity.delegate = self;
            presentViewController(vc, animated: true, completion: nil);
        }
    }
    
    func addBookmarkActivity(bookmarkActivity: BookmarkActivity, url: NSURL) {
        print("Adding Bookmark");
        var isBookmarked : Bool = false;
        let pattern : String = "^https?:\\/\\/www\\.([a-z]+)\\.[a-z]*";
        for bookmark in bookmarks {
            do {
                let regex : NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive);
                let addr = url.absoluteString;
                
                let bookmarkResult = regex.firstMatchInString(bookmark.url, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, bookmark.url.characters.count))
                let bookmarkRange: NSRange? = bookmarkResult?.rangeAtIndex(1)
                
                let urlResult = regex.firstMatchInString(addr, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, addr.characters.count));
                let urlRange: NSRange? = urlResult?.rangeAtIndex(1)
                
                if let unwrappedBookmarkRange = bookmarkRange, unrappedURLRange = urlRange {
                    let urlDomain = (addr as NSString).substringWithRange(unrappedURLRange);
                    let bookmarkDomain = (bookmark.url as NSString).substringWithRange(unwrappedBookmarkRange);
                    if(urlDomain.lowercaseString == bookmarkDomain.lowercaseString) {
                        print("Already bookmarked");
                        isBookmarked = true;
                        break;
                    }
                }
            } catch {
                print("Could not create regular expression object");
            }
        }
        if(!isBookmarked) {
            bookmarks.append(Bookmark(url: url.absoluteString, title: "Secret String"));
        }
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        if let unwrappedWebView = webView {
            unwrappedWebView.goBack();
        }
    }
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        if let unwrappedWebView = webView {
            unwrappedWebView.goForward();
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if(webView.canGoBack) {
            webViewBack.enabled = true;
        } else {
            webViewBack.enabled = false;
        }
        
        if(webView.canGoForward) {
            webViewForward.enabled = true;
        } else {
            webViewForward.enabled = false;
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        urlField.text = webView.request?.URL?.absoluteString;
    }
    
    func gotoWebSite(string: String?) -> Bool {
        var urlStringRepresentation: String;
        if let urlString = string {
            if(urlString.hasPrefix("http") || urlString.hasPrefix("https")) {
                urlStringRepresentation = urlString;
            } else {
                urlStringRepresentation = "http://" + urlString;
            }
            urlField.text = urlStringRepresentation;
            if let url = NSURL(string: urlStringRepresentation) {
                let request:NSURLRequest = NSURLRequest(URL: url);
                webView.loadRequest(request);
                return true;
            }
        }
        return false;
    }
}

