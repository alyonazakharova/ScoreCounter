//
//  MotionController.swift
//  ScoreCounter Watch App
//
//  Created by Konstantin Smirnov on 21.04.2024.
//

//
//  MotionController.swift
//  ScoreCounter Watch App
//
//  Created by Konstantin Smirnov on 21.04.2024.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
    let motionManager = CMMotionManager()
    var viewModel = GameViewModel(maxScore: 11)

    override func awake(withContext context: Any?) {
        print("InterfaceController is awake")
        super.awake(withContext: context)
        print("Start motion")
        startMonitoringMotion()
    }

    func startMonitoringMotion() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            print("Gyroscope is available and monitoring started.")
            motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                if let error = error {
                    print("Error while receiving gyro updates: \(error)")
                    return
                }
                
                if let gyroData = data {
                    print("Gyro data received: \(gyroData.rotationRate)")
                    if abs(gyroData.rotationRate.z) > 0.5 {
                        print("Threshold exceeded. Wrist movement detected.")
                        self?.viewModel.wristMove()
                    } else {
                        print("Gyro data below threshold: \(gyroData.rotationRate.z)")
                    }
                }
            }
        } else {
            print("Gyroscope is not available.")
        }
    }


    func processGyroData(_ gyroData: CMGyroData) {
        // Process the rotation rate data
        let rotationRate = gyroData.rotationRate
        if abs(rotationRate.z) > 0.1 {
            viewModel.wristMove()
        }
    }

    override func didDeactivate() {
        print("Motion deactivated")
        super.didDeactivate()
        motionManager.stopGyroUpdates()
    }
}

