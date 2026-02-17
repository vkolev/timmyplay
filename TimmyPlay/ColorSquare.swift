//
//  ColorSquare.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 17.02.26.
//
import SwiftUI
import AVFoundation

struct ColorSquare: View {
    @State var color: Color
    @Binding var gamePoints: [GridPosition]
    @State var player: AVAudioPlayer?
    let frameSize: CGFloat
    let position: GridPosition
    
    @GestureState private var isPressed = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(
                colors: [
                    color.opacity(0.7),
                    color
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            )
            .frame(width: frameSize, height: frameSize)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.7), lineWidth: 4)
                    .blendMode(.overlay)
            )
            .shadow(color: .black.opacity(0.30), radius: isPressed ? 4 : 16, x: 0, y: isPressed ? 2 : 8)
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
            .gesture(
                 LongPressGesture(minimumDuration: 0.2)
                    .updating($isPressed) { currentState, gestureState, transaction in
                        gestureState = currentState
                    }
                    .onEnded { _ in
                        if (color == .gray) {
                            // play sound oh-oh
                            playSound(named: "icq-sound.mp3")
                        } else {
                            // play sound yeah
                            playSound(named: "pop-sound.mp3")
                            gamePoints
                                .removeAll { $0 == position}
                            color = .gray
                        }
                    }
            )
        
    }
    
    func playSound(named soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil ) else {
            print("path not created")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
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
    struct Preview: View {
        @State var gamePoints = [GridPosition(row: 0, col: 1), GridPosition(row: 2, col: 3)]
        @State var gridSize = 4
        @State var gameState = GameState.playing
        var body: some View {
            
            ColorSquare(
                color: .pink,
                gamePoints: $gamePoints,
                frameSize: 300,
                position: GridPosition(row: 0, col: 0)
            )
        }
    }
    
    return Preview()
}
