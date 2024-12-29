//
//  ModelView.swift
//  ScoreCounter Watch App
//
//  Created by Konstantin Smirnov on 21.04.2024.
//

import CoreMotion

class GameViewModel: ObservableObject {
    @Published var player1Score = 0
    @Published var player2Score = 0
    @Published var showAlert = false
    @Published var player1WonSets = 0
    @Published var player2WonSets = 0
    
    let maxScore: Int

    private var motionManager = CMMotionManager()
    
    init(maxScore: Int) {
        self.maxScore = maxScore
        motionManager.deviceMotionUpdateInterval = 0.5
    }
    
    // TODO: надо зделац так чтобы екран у аппки и мотион апедйт были активны тока когда поднято запястье
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            print("oh la la")
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else {
                    print("Error or no data in device motion updates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.processDeviceMotion(motion)
            }
        } else {
            print("Device motion is not available.")
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }

    private func processDeviceMotion(_ motion: CMDeviceMotion) {
        let rotationRate = motion.rotationRate
        print("x: \(String(format: "%.2f", rotationRate.x)),\ty: \(String(format: "%.2f", rotationRate.y)), z: \(String(format: "%.2f", rotationRate.z))")
        
        if rotationRate.y > 1.0 {
            // поднятие предплечья
            DispatchQueue.main.async {
                print("SECOND player movement detected")
                self.wristMove(isFirstPlayer: false)
            }
        } else if rotationRate.x > 1.0 {
            // поворот запястья от себя
            DispatchQueue.main.async {
                print("FIRST player movement detected")
                self.wristMove(isFirstPlayer: true)
            }
        }
    }

    func wristMove(isFirstPlayer: Bool) {
        self.addScore(isFirstPlayer: isFirstPlayer)
    }

    func addScore(isFirstPlayer: Bool) {
        print("Add score")
        if isFirstPlayer {
            self.player1Score += 1
        } else {
            self.player2Score += 1
        }
        checkScore()
    }

    func checkScore() {
        if player1Score >= maxScore && player1Score > player2Score && player1Score - player2Score > 1 {
            self.player1WonSets += 1
            showAlert = true
            resetScores()
        } else if player2Score >= maxScore && player2Score > player1Score && player2Score - player1Score > 1 {
            self.player2WonSets += 1
            showAlert = true
            resetScores()
        }
    }

    private func resetScores() {
        player1Score = 0
        player2Score = 0
    }
}
