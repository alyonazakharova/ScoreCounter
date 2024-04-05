//
//  ContentView.swift
//  ScoreCounter Watch App
//
//  Created by Алёна Захарова on 4.4.24..
//

import SwiftUI

struct CounterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let maxScore: Int
    
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var showAlert = false
    @State private var player1WonSets = 0
    @State private var player2WonSets = 0
    
    func checkScore(thisScore: Int, otherScore: Int) {
        if thisScore >= maxScore && thisScore > otherScore && thisScore - otherScore > 1 {
            WKInterfaceDevice.current().play(.success)
            showAlert = true
            if player1Score > player2Score {
                player1WonSets += 1
            } else {
                player2WonSets += 1
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(player1Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 26, design: .monospaced))
                    .frame(width: 40)
                    .padding()
                Text(":")
                    .frame(width: 10)
                Text("\(player2Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 26, design: .monospaced))
                    .frame(width: 40)
                    .padding()
            }
            HStack {
                VStack {
                    Button("Player 1") {
                        player1Score += 1
                        checkScore(thisScore: player1Score, otherScore: player2Score)
                    }
                    .font(.system(size: 15))
                    Text("\(player1WonSets) set\(player1WonSets == 1 ? "" : "s")")
                        .font(.system(size: 10))
                }
                VStack {
                    Button("Player 2") {
                        player2Score += 1
                        checkScore(thisScore: player2Score, otherScore: player1Score)
                    }
                    .font(.system(size: 15))
                    Text("\(player2WonSets) set\(player2WonSets == 1 ? "" : "s")")
                        .font(.system(size: 10))
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert, content: {
            Alert (
                title: Text("This set is over!"),
                message: Text("Score: \(player1Score):\(player2Score)"),
                primaryButton: .default(Text("Start again")) {
                    player1Score = 0
                    player2Score = 0
                },
                secondaryButton: .destructive(Text("Quit")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        })
    }
}

#Preview {
    CounterView(maxScore: 11)
}
