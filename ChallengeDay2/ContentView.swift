//
//  ContentView.swift
//  ChallengeDay2
//
//  Created by Scott Obara on 9/1/21.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, alignment: .center)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.blue, lineWidth: 3)
                )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
}

struct ContentView: View {
    
    let computerMove = ["🪨 Rock", "🧻 Paper", "✂️ Scissors"]
    
    enum GameOutcome : String {
        case win
        case loose
        case draw
    }
    
    @State private var computerMoveSelected = Int.random(in: 0 ..< 3)
    @State private var winLooseObjective = [GameOutcome.win, GameOutcome.loose].shuffled()
    @State private var showingScore = false
    @State private var currentScore = (successCount: 0, failureCount: 0)

    var body: some View {
            VStack(spacing: 10) {
                Text(computerMove[computerMoveSelected])
                    .font(.system(size: 56))
                    .padding(.bottom, 30)
                Text("Your objective is to:")
                Text(winLooseObjective[0].rawValue.uppercased())
                    .font(.headline)
                    .frame(width: 200, height: 40, alignment: .center)
                    .background(
                        winLooseObjective[0] == GameOutcome.win ? Color.green :
                        Color.red
                            
                    )
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.buttonTapped(number)
                    }) {
                        Text(computerMove[number])
                            .buttonStyle()
                        
                    }
                }
        }
        .alert(isPresented: $showingScore) {
            Alert(
                title: Text("Game Outcome"),
                message: Text("""
                    Success count: \(currentScore.successCount)
                    Failure count: \(currentScore.failureCount)
                    """),
                dismissButton: .default(Text("Continue")) {
                    currentScore.successCount = 0
                    currentScore.failureCount = 0
                    winLooseObjective.shuffle()
                    computerMoveSelected = Int.random(in: 0 ..< 3)
            })
        }
    }
    
    func buttonTapped(_ number: Int) {
        if challengeOutcome(number) == winLooseObjective[0] {
            currentScore.successCount += 1
        } else {
            currentScore.failureCount += 1
        }
        newChallenge()
        
    }

    func challengeOutcome(_ userMove: Int) -> GameOutcome? {
        
        if computerMoveSelected == 0 {
            if userMove == 0 {
                return GameOutcome.draw
            } else if userMove == 1 {
                return GameOutcome.win
            } else if userMove == 2 {
                return GameOutcome.loose
            }
        } else if computerMoveSelected == 1 {
            if userMove == 0 {
                return GameOutcome.loose
            } else if userMove == 1 {
                return GameOutcome.draw
            } else if userMove == 2 {
                return GameOutcome.win
            }
        } else if computerMoveSelected == 2 {
            if userMove == 0 {
                return GameOutcome.win
            } else if userMove == 1 {
                return GameOutcome.loose
            } else if userMove == 2 {
                return GameOutcome.draw
            }
        }
        return nil
    }
    
    func newChallenge() {
        if (currentScore.successCount + currentScore.failureCount) >= 10 {
            showingScore = true
        } else {
        winLooseObjective.shuffle()
        computerMoveSelected = Int.random(in: 0 ..< 3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
