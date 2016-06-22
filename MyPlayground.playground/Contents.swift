//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let path = UIBezierPath()

path.moveToPoint(CGPoint(x: 80, y: 50))

path.addLineToPoint(CGPoint(x: 140, y: 150))
path.addLineToPoint(CGPoint(x: 10, y: 150))
path.closePath()

UIColor.greenColor().setFill()
UIColor.redColor().setStroke()
path.lineWidth = 3.0
path.fill()
path.stroke()