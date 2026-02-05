//
//  ContentView.swift
//  lifecounter v2
//
//  Created by iguest on 2/4/26.
//

import SwiftUI

struct ContentView: View {
    @State private var players = [
        Player(name: "P1", life: 20, hasLost: false),
        Player(name: "P2", life: 20, hasLost: false),
        Player(name: "P3", life: 20, hasLost: false),
        Player(name: "P4", life: 20, hasLost: false)
    ]

    @State private var history: [String] = []
    @State private var showHistory = false
    @State private var showGameOver = false
    @State private var winnerName = ""

    var body: some View {
        VStack {
            if showHistory {
                HistoryView(history: history) {
                    showHistory = false
                }

            } else if showGameOver {
                GameOverView(winner: winnerName) {
                    resetGame()
                }

            } else {
                HStack(spacing: 15) {
                    Button("Add Player") { addPlayer() }
                        .buttonStyle(.borderedProminent)
                        .disabled(players.count >= 8)

                    Button("History") { showHistory = true }
                        .buttonStyle(.borderedProminent)

                    Button("Reset") { resetGame() }
                        .buttonStyle(.borderedProminent)
                }
                .padding()

                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(players.indices, id: \.self) { i in
                            PlayerView(
                                player: players[i],
                                addLife: { changeLife(index: i, amount: $0) },
                                subtractLife: { changeLife(index: i, amount: -$0) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    struct PlayerView: View {
        let player: Player
        let addLife: (Int) -> Void
        let subtractLife: (Int) -> Void

        @State private var amount = "1"

        var body: some View {
            HStack(spacing: 20) {
                // player name, player life
                HStack {
                    Text(player.name + ":")
                        .font(.system(size: 30))
                        .frame(minWidth: 80, alignment: .leading)

                    Text("\(player.life)")
                        .font(.system(size: 50))
                }

                Spacer()

                VStack(spacing: 15) {
                    // +1 and -1 buttons
                    HStack(spacing: 15) {
                        Button("+1") { addLife(1) }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)

                        Button("-1") { subtractLife(1) }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                    }
                    // custom amount buttons
                    HStack(spacing: 12) {
                        TextField("Amount", text: $amount)
                            .frame(width: 50)
                            .textFieldStyle(.roundedBorder)

                        Button("+") {
                            addLife(Int(amount) ?? 1)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

                        Button("-") {
                            subtractLife(Int(amount) ?? 1)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
            }
            .padding()
        }
    }
    
    private func changeLife(index: Int, amount: Int) {
        if players[index].hasLost { return }

        players[index].life += amount

        if amount > 0 {
            history.append("\(players[index].name) gained \(amount) life.")
        } else {
            history.append("\(players[index].name) lost \(abs(amount)) life.")
        }

        if players[index].life <= 0 {
            players[index].hasLost = true
            checkGameOver()
        }
    }

    struct HistoryView: View {
        var history: [String]
        var onBack: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Button("Back") { onBack() }
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("Game History")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                
                .padding(5)
                
                Divider()
                
                .padding(20)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        ForEach(history, id: \.self) { event in
                            Text(event)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
    }

    struct GameOverView: View {
        var winner: String
        var onPlayAgain: () -> Void
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .bold()
                
                Text("\(winner) wins!")
                    .font(.title2)
                
                Button("Ok") { onPlayAgain() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private func addPlayer() {
        if players.count >= 8 { return }
        
        let number = players.count + 1
        players.append(Player(name: "P\(number)", life: 20))
    }
    
    private func resetGame() {
        players = [
            Player(name: "P1", life: 20),
            Player(name: "P2", life: 20),
            Player(name: "P3", life: 20),
            Player(name: "P4", life: 20)
        ]
        
        history.removeAll()
        showGameOver = false
        winnerName = ""
    }
    
    private func checkGameOver() {
        var remainingPlayers = 0
        var winningPlayer = ""
        
        for player in players {
            if player.life > 0 {
                remainingPlayers += 1
                winningPlayer = player.name
            }
        }
        
        if remainingPlayers == 1 {
            winnerName = winningPlayer
            showGameOver = true
        }
    }
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var life: Int
    var hasLost: Bool = false
}

#Preview {
    ContentView()
}
