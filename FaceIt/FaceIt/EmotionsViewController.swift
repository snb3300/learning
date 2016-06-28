//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Shridhar Bhalekar on 6/27/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    private let emotionalFaces : Dictionary<String, FacialExpression> = [
        "angry": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin),
    ]

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navigationvc = destinationvc as? UINavigationController {
            destinationvc = navigationvc.visibleViewController ?? destinationvc
        }
        
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.facialExpression = expression
                    if let button = sender as? UIButton {
                        facevc.title = button.currentTitle
                    }
                }
            }
        }
    }
}
