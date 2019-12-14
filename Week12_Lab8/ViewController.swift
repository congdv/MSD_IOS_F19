//
//  ViewController.swift
//  Week12_Lab8
//
//  Created by Student on 2019-11-22.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreMotion


struct Range {
    var value: Double = 0.0
    var lowest: Double = 0.0
    var highest: Double = 0.0
    init(value:Double, lowest:Double, highest: Double) {
        self.value = value
        self.lowest = lowest
        self.highest = highest
    }
    init(value: Double, lowest: Double){
        self.init(value: value, lowest: lowest, highest: 1.0)
    }
}

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    var isMoved: Bool = false

    var typingTimes = 0
    
    var seconds = 0
    
    @IBOutlet weak var lblSensorData: UILabel!
    @IBOutlet weak var lblPickUpStatus: UILabel!
    @IBOutlet weak var lblPhoneOrientation: UILabel!
    @IBOutlet weak var lblTypingOrientationStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startDeviceMotion()
    
    }
    
    func startDeviceMotion() {
        if(motionManager.isDeviceMotionAvailable) {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {
                (deviceMotion, error) in
                if let deviceMotion = deviceMotion {
                    let x = deviceMotion.gravity.x
                    let y = deviceMotion.gravity.y
                    let z = deviceMotion.gravity.z
                    self.displaySendorData(x,y,z)
                    self.displayPickupPhone(x, y, z)
                    self.displayPhoneOrientation(x, y, z)
                    self.displayTypingActivity(x, y, z)
                    
                }
            }
        }
    }
    
    func displaySendorData(_ x: Double,_ y: Double,_ z: Double)  {
        let displayValue = String(format: "x = %.4f \n y = %.4f \n z = %.4f", x,y,z)
        lblSensorData.text! = "Sensor Data:\n" + displayValue
        
    }
    
    func displayPhoneOrientation(_ x: Double,_ y:Double,_ z:Double) {
        
        // Rule for checking portrait orientation
        var xRange = Range(value: x, lowest: -0.2, highest: 0.2)
        var yRange = Range(value: y, lowest: -1.0, highest: -0.8)
        let zRange = Range(value: z, lowest: -0.2, highest: 0.2)
        
        
        let isPortrait = isRuleOk(xRange, yRange, zRange)
        
        // Rule for checking portrait Upside Down, only change rule of y
        yRange.lowest = 0.8
        yRange.highest = 1
        
        let isPortraitUpsideDown = isRuleOk(xRange, yRange, zRange)
        
        //Rule for checking landscape left
        xRange.lowest = -1.0
        xRange.highest = -0.8
        yRange.lowest = -0.2
        yRange.highest = 0.2
        
        let isLandscapeLeft = isRuleOk(xRange, yRange, zRange)
        
        //Rule for checking landscape right
        xRange.lowest = 0.8
        xRange.highest = 1
        let isLandscapeRight = isRuleOk(xRange, yRange, zRange)
        
        phoneOrientation( isPortrait, isPortraitUpsideDown, isLandscapeLeft, isLandscapeRight)
    }
    
    func phoneOrientation(_ isPortrait: Bool,_ isPortraitUpsideDown: Bool,
                          _ isLandscapeLeft: Bool,_ isLandscapeRight: Bool){
        lblPhoneOrientation.text! = "Phone Orientation: \n"
        if(isPortrait){
            lblPhoneOrientation.text! += "Portrait"
        } else if(isPortraitUpsideDown) {
            lblPhoneOrientation.text! += "Portrait Upside Down"
        } else if(isLandscapeLeft){
            lblPhoneOrientation.text! += "Landscape Left"
        } else if(isLandscapeRight) {
            lblPhoneOrientation.text! += "Landscape Right"
        } else {
            lblPhoneOrientation.text! += "Unidentify"
        }
    }
   
    
    
   
    
    func displayPickupPhone(_ x: Double,_ y: Double,_ z: Double) {
        lblPickUpStatus.text! = "Pick up status:\n"
        let zRange = Range(value: fabs(z), lowest: 0.9)
        
        if(isValueInRange(zRange.value, zRange.lowest, zRange.highest)){
            isMoved = false
            lblPickUpStatus.text! += "No"
            seconds = 0
        } else {
            seconds += 1
            if(seconds <= 100) {
                lblPickUpStatus.text! += "Yes"
            } else {
                seconds = 101
                lblPickUpStatus.text! += "No"
            }
        }
    }
    
    func displayTypingActivity(_ x: Double,_ y: Double,_ z: Double) {
        // Default highest range is 1.0
        
        // Portrait Typing Range (PTRange)
        let xPTRange = Range(value: fabs(x), lowest: 0.0)
        let yPTRange = Range(value: fabs(y), lowest: 0.5)
        let zPTRange = Range(value: fabs(z), lowest: 0.5)
        
        
        // Landscape typing Range (LTRange)
        let xLTRange = Range(value: fabs(x), lowest: 0.5)
        let yLTRange = Range(value: fabs(y), lowest: 0.0)
        let zLTRange = Range(value: fabs(z), lowest: 0.5)
    
        // Horizontal Portrait Typing Range(HPTRange)
        let xHPTRange = Range(value: fabs(x), lowest: 0.0)
        let yHPTRange = Range(value: fabs(y), lowest: 0.2)
        let zHPTRange = Range(value: fabs(z), lowest: 0.8)
        
        // Vertical Portrait Typing Range(VPTRange)
        let xVPTRange = Range(value: fabs(x), lowest: 0.0)
        let yVPTRange = Range(value: fabs(y), lowest: 0.8)
        let zVPTRange = Range(value: fabs(z), lowest: 0.2)
        
        
        
        if(isRuleOk(xPTRange, yPTRange, zPTRange)
            || isRuleOk(xLTRange, yLTRange, zLTRange)
            || isRuleOk(xHPTRange, yHPTRange, zHPTRange)
            || isRuleOk(xVPTRange, yVPTRange, zVPTRange)) {
            typingTimes += 1
        }
        else {
            typingTimes = 0
        }
        
        lblTypingOrientationStatus.text! = "Typing Orientation Status:\n"
        if(typingTimes > 20){
            lblTypingOrientationStatus.text! += " Typing"
        } else {
            lblTypingOrientationStatus.text! += " None"
        }
    }
    
    func isRuleOk(_ x: Range,_ y: Range,_ z: Range) -> Bool {
        if(isValueInRange(x.value, x.lowest, x.highest) && isValueInRange(y.value,y.lowest, y.highest) && isValueInRange(z.value, z.lowest, z.highest)) {
            return true
            
        }
        
        return false
    }
    
    
    
    func isValueInRange(_ value: Double,_ lowest: Double,_ highest: Double) -> Bool {
        print(value,lowest, highest)
        
        if(value >= lowest && value <= highest){
            return true
        }
        return false
    }
    


}

