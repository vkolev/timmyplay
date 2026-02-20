//
//  ContentView.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 16.02.26.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var gamePoints: [GridPosition] = []
    @State var gridSize: Int
    @State var gameState: GameState = .playing
    @State var viewID = 1
    @State var player: AVAudioPlayer?
    @State var currentLevelIndex: Int = 0
    @State private var timeRemaining: Double?
    @State private var levelStartTime: Date?
    @State var useTimer: Bool = true
    @State private var gameMode: GameMode = .menu
    
    let levels = LevelConfig.generate()
    
    
    init() {
        let config = levels[0]
        _gridSize = .init(initialValue: config.gridSize)
        _gamePoints = .init(
            initialValue: Self.generateGamePoints(config)
        )
    }
    
    var body: some View {
        Group {
            switch gameMode {
            case .menu:
                MenuView {
                    useTimer = true
                    gameMode = .timeAttack
                    resetGame()
                } onStartCasual: {
                    useTimer = false
                    gameMode = .casual
                    resetGame()
                }
            case .timeAttack, .casual:
                gameView
                
            }
        }
    }
    
    var gameView: some View {
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
                let isCompact = sizeClass == .compact
                Text("TimmyPlay")
                    .font(.system(size: isCompact ? 45: 66, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.3)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                    .padding(.top, isCompact ? 10 : 30)
                
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
                if gameState == .lost {
                    playSound(named: "icq-sound.mp3")
                    resetGame()
                    return
                }
                startGame()
                
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
            
            
            if useTimer {
                TimelineView(
                    .animation
                ) { timeline in
                    let elapsed = timeline.date.timeIntervalSince(levelStartTime ?? timeline.date)
                    let remaining = max(
                        0,
                        levels[currentLevelIndex].timeLimit! - elapsed
                    )
                    
                    VStack {
                        HStack {
                                Button(action: {
                                    gameMode = .menu
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(.black))
                                        .frame(width: 40, height: 40)
                                        .background(.ultraThinMaterial, in: Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                                .padding(.leading, 20)
                                .padding(.top, 20)
                                
                            Spacer()
                            
                            
                            Text(String(format: "Timer: %.0f seconds", remaining))
                                .font(.system(size: 33, weight: .bold, design: .rounded))
                                .foregroundStyle(remaining < 5 ? .red : .black)
                                .padding(.horizontal, 2)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                                .padding(.trailing, 20)
                            
                            Text("Level \(levels[currentLevelIndex].number)")
                                .font(
                                    .system(size: 33, weight: .bold, design: .rounded)
                                )
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    .onChange(of: remaining) { newValue in
                        if newValue <= 0 {
                            gameState = .lost
                        }}
                }.onAppear {
                    if levels[currentLevelIndex].timeLimit != nil {
                        levelStartTime = Date()
                    }
                }
            } else {
                VStack {
                    HStack {
                            Button(action: {
                                gameMode = .menu
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(.black))
                                    .frame(width: 40, height: 40)
                                    .background(.ultraThinMaterial, in: Circle())
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .padding(.leading, 20)
                            .padding(.top, 20)
                            
                        Spacer()
                        Text("Level \(levels[currentLevelIndex].number)")
                            .font(.system(size: 33, weight: .bold, design: .rounded))
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
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
    
    func resetGame() {
        currentLevelIndex = 0
        self.gamePoints = Self.generateGamePoints(levels[currentLevelIndex])
        self.gridSize = levels[currentLevelIndex].gridSize
        gameState = .playing
        self.viewID += 1
        levelStartTime = Date()
    }
    
    func startGame() {
        playSound(named: "csgo-sound.mp3")
        print("State of the game: \(self.gameState)")
        self.gamePoints = Self.generateGamePoints(levels[currentLevelIndex])
        self.gridSize = levels[currentLevelIndex].gridSize
        self.viewID += 1
        if (currentLevelIndex >= levels.count - 1) {
            self.currentLevelIndex = self.currentLevelIndex
        } else {
            self.currentLevelIndex += 1
        }
        gameState = .playing
    }
    
}

#Preview {
    ContentView()
}
