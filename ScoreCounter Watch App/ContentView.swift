//
//  ContentView.swift
//  ScoreCounter Watch App
//
//  Created by Алёна Захарова on 4.4.24..
//

import SwiftUI

struct ContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var showAlert = false
    
    func checkScore(_ score: Int) {
        if score == 11 {
            WKInterfaceDevice.current().play(.success)
            showAlert = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(player1Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 24, design: .monospaced))
                    .padding()
                Text(":")
                Text("\(player2Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 24, design: .monospaced))
                    .padding()
            }
            HStack {
                Button("Player 1") {
                    player1Score += 1
                    checkScore(player1Score)
                }
                Button("Player 2") {
                    player2Score += 1
                    checkScore(player2Score)
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert, content: {
            Alert (
                title: Text("This set is over!"),
                primaryButton: .default(Text("Start again")) {
                    player1Score = 0
                    player2Score = 0
                },
                secondaryButton: .default(Text("Quit")) {
                    print("Should quit)))")
                }
            )
        })
    }
}

#Preview {
    ContentView()
}
