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
    @State var gridSize: Int
    @State var gameState: GameState = .playing
    @State var viewID = 1
    @State var player: AVAudioPlayer?
    @State var currentLevelIndex: Int = 0
    
    let levels = LevelConfig.generate()
    
    
    init() {
        let config = levels[0]
        _gridSize = .init(initialValue: config.gridSize)
        _gamePoints = .init(
            initialValue: Self.generateGamePoints(config)
        )
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
                    .font(.system(size: 66, weight: .heavy, design: .rounded))
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
                
                    
            }
            .onChange(of: gameState) { _ in
                guard currentLevelIndex < levels.count else {
                    return
                }
                guard gameState != .playing else {
                    return
                }
                playSound(named: "csgo-sound.mp3")
                print("State of the game: \(self.gameState)")
                self.gamePoints = Self.generateGamePoints(levels[currentLevelIndex])
                self.gridSize = levels[currentLevelIndex].gridSize
                self.viewID += 1
                self.currentLevelIndex += 1
                gameState = .playing
                
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Text(
                        "Level: \(levels[currentLevelIndex].number)  Points: \(levels[currentLevelIndex].pointCount)"
                    )
                    .padding(.trailing, 40)
                    .padding(.top, 20)
                    
                    .font(
                        .system(size: 33, weight: .semibold, design: .rounded)
                    )
                }
                Spacer()
            }
        }
        
        
    }
    
    static func generateGamePoints(_ levelConfig: LevelConfig) -> [GridPosition] {
        // Generate random points on the grid without duplicates
        var pointArray: [GridPosition] = []
        for x in 0..<levelConfig.gridSize {
            for y in 0..<levelConfig.gridSize {
                pointArray.append(GridPosition(row: x, col: y))
            }
        }
        pointArray.shuffle()
        return Array(pointArray.prefix(levelConfig.pointCount))
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
