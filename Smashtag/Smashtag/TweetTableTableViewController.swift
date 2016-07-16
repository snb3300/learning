//
//  TweetTableTableViewController.swift
//  Smashtag
//
//  Created by Shridhar Bhalekar on 6/30/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit
import Twitter

class TweetTableTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.text = searchText
            searchTextField.delegate = self
        }
    }
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest : Twitter.TwitterRequest? {
        if let query = searchText where !query.isEmpty {
            return TwitterRequest(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest : Twitter.TwitterRequest?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets {[weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if let prevRequest = weakSelf?.lastTwitterRequest {
                        if request.equals(prevRequest){
                            if !newTweets.isEmpty {
                                weakSelf?.tweets.insert(newTweets, atIndex: 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
//        searchText = "#stanford"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
