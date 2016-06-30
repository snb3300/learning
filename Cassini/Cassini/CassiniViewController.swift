//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Shridhar Bhalekar on 6/28/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue identifier \(segue.identifier)")
        if segue.identifier == Storyboard.ShowImageSegue {
            if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                let imageName = (sender as? UIButton)?.currentTitle
                print("Current Image Selected \(imageName)")
                let url = DemoURL.NASAImageNamed(imageName)
                ivc.imageURL = url
                ivc.title = imageName
            }
        }
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        return self
    }
}