//
//  GameView.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 16.02.26.
//

import SwiftUI
import AVFoundation


struct GameView: View {
    @Binding var intgridSize: Int
    @Binding var gamePoints: [GridPosition]
    @Binding var gameState: GameState
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 20
            let availableSize = min(geometry.size.width,
                                    geometry.size.height)
            let totalSpacing = spacing * CGFloat(intgridSize - 1)
            let cellSize = (availableSize - totalSpacing) / CGFloat(intgridSize)
            VStack {
                Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                    ForEach(0..<intgridSize, id: \.self) { row in
                        GridRow {
                            ForEach(0..<intgridSize, id: \.self) { col in
                                let position = GridPosition(row: row, col: col)
                                ColorSquare(
                                    color: isInPoints(
                                        point: position
                                    ) ? .pink : .gray,
                                    gamePoints: $gamePoints,
                                    frameSize: cellSize,
                                    position: position
                                )
                            }
                        }
                    }
                }
                .onChange(of: gamePoints) { _ in
                    if self.gamePoints.isEmpty {
                        self.gameState = .won
                        
                    }
                }
            }
            .frame(width: availableSize, height: availableSize, alignment: .center)
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
    
    func isInPoints(point: GridPosition) -> Bool {
        return self.gamePoints.contains(point)
    }
    
}

#Preview {
    struct Preview: View {
        @State var gamePoints = [GridPosition(row: 0, col: 1), GridPosition(row: 2, col: 3)]
        @State var gridSize = 4
        @State var gameState = GameState.playing
        var body: some View {
            
            GameView(
                intgridSize: $gridSize,
                gamePoints: $gamePoints,
                gameState: $gameState
            )
        }
    }
    
    return Preview()
}
