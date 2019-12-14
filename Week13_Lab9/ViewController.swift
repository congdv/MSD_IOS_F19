//
//  ViewController.swift
//  Week13_Lab9
//
//  Created by Student on 2019-11-29.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreML
import CoreMotion
import Charts

class ViewController: UIViewController {

    var motionManager = CMMotionManager()
    var model = PhoneOrientation()
    
    var gravityX: Double = 0
    var gravityY: Double = 0
    var gravityZ: Double = 0
    
    @IBOutlet weak var gravityBarChartView: BarChartView!
    @IBOutlet weak var lblPhoneOrientation: UILabel!
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
                    self.gravityX = deviceMotion.gravity.x
                    self.gravityY = deviceMotion.gravity.y
                    self.gravityZ = deviceMotion.gravity.z
                    
                    self.updateBarChartData()
                    
                    self.displayPrediction()
                }
            }
        }
    }
    
    func updateBarChartData() {
        let gravityXCol = BarChartDataEntry(x: 1, y: self.gravityX)
        let gravityYCol = BarChartDataEntry(x: 2, y: self.gravityY)
        let gravityZCol = BarChartDataEntry(x: 3, y: self.gravityZ)
        
        let gravityDataEntries = [gravityXCol,gravityYCol,gravityZCol]
        
        let gravityDataSet = BarChartDataSet(entries: gravityDataEntries, label: "Gravity Figures")
        gravityDataSet.colors = [.blue,.green,.red]
        
        let gravityChartData = BarChartData(dataSet: gravityDataSet)
        
        gravityBarChartView.data = gravityChartData
    }
    
    func displayPrediction() {
        guard let prediction = self.preditPhoneOrientation() else {
            print("Error Prediction")
            self.lblPhoneOrientation.text = "Phone Orientation: \n Cannot recognization"
            return
        }
        
        self.lblPhoneOrientation.text = "Phone Orientation: \n" + prediction
    }
    
    func preditPhoneOrientation() -> String? {
        let currentGravity = [self.gravityX, self.gravityY, self.gravityZ]
        
        guard let inputGravity = try? MLMultiArray(shape: [1,3], dataType: MLMultiArrayDataType.double) else {
            fatalError("Failed to prepare input for prediction")
        }
        for(index, element) in currentGravity.enumerated() {
            inputGravity[index] = NSNumber(floatLiteral: element)
        }
        
        guard let prediction = try? self.model.prediction(input: inputGravity) else {
            print("Cannot predict this status")
            return nil
        }
        print("Phone label: ", prediction.classLabel)
        return mappingToOrientation(label: prediction.classLabel)
    }
    
    func mappingToOrientation(label: Int64) -> String? {
        switch label {
        case 1:
            return "Face Up"
        case 2:
            return "Face Down"
        case 3:
            return "Portrait"
        case 4:
            return "Upside Down"
        case 5:
            return "Lanscape Left"
        case 6:
            return "Lanscape Right"
        default:
            return nil
        }
    }

}

