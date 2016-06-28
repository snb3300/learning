//
//  ViewController.swift
//  FaceIt
//
//  Created by Shridhar Bhalekar on 6/21/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var facialExpression = FacialExpression(eyes: .Closed, eyeBrows: .Normal, mouth: .Smirk) {
        didSet {
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            switch facialExpression.eyes {
            case .Open:
                facialExpression.eyes = .Closed
                facialExpression.eyeBrows = .Normal
            case .Closed: facialExpression.eyes = .Open
                facialExpression.eyeBrows = .Relaxed
            case .Squinting: break
            }
        default: break
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:)))
            faceView.addGestureRecognizer(pinchGestureRecognizer)
            
            let happierFaceSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.makeFaceHappy))
            happierFaceSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierFaceSwipeGestureRecognizer)
            
            let sadderFaceSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.makeFaceSad))
            sadderFaceSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderFaceSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    func makeFaceHappy() {
        facialExpression.mouth = facialExpression.mouth.happierMouth()
    }
    
    func makeFaceSad() {
        facialExpression.mouth = facialExpression.mouth.sadderMouth()
    }
    
    
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Smirk: -0.5, .Neutral: 0.0, .Grin: 0.5, .Smile: 1.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    private func updateUI() {
        if faceView != nil {
            switch facialExpression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[facialExpression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[facialExpression.eyeBrows] ?? 0.0
        }
    }
}

