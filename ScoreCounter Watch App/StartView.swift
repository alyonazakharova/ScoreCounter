//
//  StartView.swift
//  ScoreCounter Watch App
//
//  Created by Алёна Захарова on 5.4.24..
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(sportTypes) { sportType in
                    NavigationLink(destination: CounterView(maxScore: sportType.maxScore)) {
                        ScoreTypeView(scoreType: sportType)
                    }
                }
            }
            .navigationTitle("Select Sport")
        }
    }
}

struct ScoreType: Identifiable {
    let id = UUID()
    let label: String
    let symbolName: String
    let maxScore: Int
}

let sportTypes = [
    ScoreType(label: "Squash", symbolName: "figure.squash", maxScore: 11),
    ScoreType(label: "Padel", symbolName: "tennis.racket", maxScore: 15),
    ScoreType(label: "Badminton", symbolName: "figure.badminton", maxScore: 21),
    ScoreType(label: "Table Tennis", symbolName: "figure.table.tennis", maxScore: 11),
    ScoreType(label: "Custom", symbolName: "star", maxScore: Int.max),
]

struct ScoreTypeView: View {
    let scoreType: ScoreType
    var body: some View {
        HStack {
            Image(systemName: scoreType.symbolName)
                .foregroundStyle(Color.yellow)
                .padding()
            Text(scoreType.label)
        }
    }
}

#Preview {
    StartView()
}
