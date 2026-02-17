//
//  ContentView.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 16.02.26.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @State var gamePoints: [GridPosition] = []
    @State var gridSize = 4
    @State var gameState: GameState = .playing
    @State var viewID = 1
    @State var player: AVAudioPlayer?
    
    
    init() {
        _gamePoints = .init(initialValue: generateGamePoints())
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray6),
                    Color.pink.opacity(0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                Text("TimmyPlay")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.3)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                    .padding(.top, 30)
                GameView(intgridSize: $gridSize, gamePoints: $gamePoints, gameState: $gameState)
                    .id(viewID)
                    .onChange(of: gameState) { _ in
                        playSound(named: "csgo-sound.mp3")
                        print("State of the game: \(self.gameState)")
                        if (viewID % 10 == 0 && self.gridSize <= 6) {
                            self.gridSize += 1
                        }
                        self.gamePoints = self.generateGamePoints()
                        self.gameState = .playing
                        self.viewID += 1
                    }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
        
        
    }
    
    func generateGamePoints() -> [GridPosition] {
        var pointArray: [GridPosition] = []
        for x in 0..<gridSize {
            for y in 0..<gridSize {
                pointArray.append(GridPosition(row: x, col: y))
            }
        }
        
        pointArray.shuffle()
        return Array(pointArray.prefix(gridSize))
    }
    
    func playSound(named soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil ) else {
            print("path not created")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        //This will work if you don't use guard
        //let url = URL(fileURLWithPath: path!)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.5
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    ContentView()
}
