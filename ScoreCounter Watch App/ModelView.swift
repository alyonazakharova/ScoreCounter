//
//  ModelView.swift
//  ScoreCounter Watch App
//
//  Created by Konstantin Smirnov on 21.04.2024.
//
import Foundation
import Combine
import CoreMotion

class GameViewModel: ObservableObject {
    @Published var player1Score = 0
    @Published var player2Score = 0
    @Published var showAlert = false
    @Published var player1WonSets = 0
    @Published var player2WonSets = 0
    let maxScore: Int

    private var motionManager = CMMotionManager()
    private var updateInterval = 0.5

    init(maxScore: Int) {
        self.maxScore = maxScore
    }

    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = updateInterval
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
            // я что-то наговнокодил #Аленканепизди
        if abs(rotationRate.z) > 0.6 {
            DispatchQueue.main.async {
                self.wristMove()
            }
        }
    }

    func wristMove() {
        self.player1Score += 1
        checkScore()
    }

    func addScore(which: Bool) {
        print("Add score")
        if which {
            self.player2Score += 1
        } else {
            self.player1Score += 1
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


