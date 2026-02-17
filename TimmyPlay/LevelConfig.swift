//
//  LevelConfig.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 17.02.26.
//

struct LevelConfig {
    let number: Int
    let gridSize: Int
    let pointCount: Int
    let timeLimit: Double?
    
    static func generate() -> [LevelConfig] {
        (1...100).map { level in
            let gridSize: Int
            let pointCount: Int
            let timeLimit: Double?
            
            switch level {
            case 1...10:
                gridSize = 4
                pointCount = 4 + (level - 1) / 3
                timeLimit = nil
            case 11...50:
                gridSize = 5
                pointCount = 6 + (level - 11) / 5
                timeLimit = nil
            case 26...45:
                gridSize = 6
                pointCount = 9 + (level - 26) / 7
                timeLimit = nil // possible limit level > 35 ? 30.0 : nil
            case 46...70:
                gridSize = 7
                pointCount = 14 + (level - 46) / 12
                timeLimit = nil // 30.0 - Double(level - 46) * 0.2
            case 71...100:
                gridSize = 8
                pointCount = 14 + (level - 71) / 15
                timeLimit = nil // 20 - Double(level - 71) * 0.1
            default:
                gridSize = 8
                pointCount = 16
                timeLimit = nil // 15.0
            }
            
            return LevelConfig(
                number: level,
                gridSize: gridSize,
                pointCount: pointCount,
                timeLimit: timeLimit
            )
        }
    }
}
