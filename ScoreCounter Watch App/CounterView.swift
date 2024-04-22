//
//  ContentView.swift
//  ScoreCounter Watch App
//
//  Created by Алёна Захарова on 4.4.24..
//

import SwiftUI

struct CounterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.player1Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 26, design: .monospaced))
                    .frame(width: 40)
                    .padding()
                Text(":")
                    .frame(width: 10)
                Text("\(viewModel.player2Score)")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 26, design: .monospaced))
                    .frame(width: 40)
                    .padding()
            }
            HStack {
                VStack {
                    Button("Player 1") {
                        viewModel.addScore(which:false)
                    }
                    .font(.system(size: 15))
                    Text("\(viewModel.player1WonSets) set\(viewModel.player1WonSets == 1 ? "" : "s")")
                        .font(.system(size: 10))
                }
                VStack {
                    Button("Player 2") {
                        viewModel.addScore(which:true)
                    }
                    .font(.system(size: 15))
                    Text("\(viewModel.player2WonSets) set\(viewModel.player2WonSets == 1 ? "" : "s")")
                        .font(.system(size: 10))
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert (
                title: Text("This set is over!"),
                message: Text("Score: \(viewModel.player1Score):\(viewModel.player2Score)"),
                primaryButton: .default(Text("Start again")) {
                    viewModel.player1Score = 0
                    viewModel.player2Score = 0
                },
                secondaryButton: .destructive(Text("Quit")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        })
        .onAppear {
            viewModel.startMotionUpdates()
        }
        .onDisappear {
            viewModel.stopMotionUpdates()
        }
    }
}
