//
//  MenuView.swift
//  TimmyPlay
//
//  Created by Vladimir Kolev on 20.02.26.
//

import SwiftUI

struct MenuView: View {
    let onStartTimeAttack: () -> Void
    let onStartCasual: () -> Void
    
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
            
            VStack(spacing: 40) {
                Spacer()
                
                // Title
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
                
//                Spacer()
                
                VStack(spacing: 20) {
                    // Time Attack button
                    Button(action: onStartTimeAttack) {
                        HStack {
                            Image(systemName: "timer")
                                .font(.system(size: 34))
                            Text("Time Attack")
                                .font(.system(size: 34, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 380, height: 100)
                        .background(
                            LinearGradient(
                                colors: [Color.pink.opacity(0.3), Color.pink.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    // Casual button
                    Button(action: onStartCasual) {
                        HStack {
                            Image(systemName: "hand.tap")
                                .font(.system(size: 34))
                            Text("Casual Mode")
                                .font(.system(size: 34, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 380, height: 100)
                        .background(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                
                Spacer()
            }
        }
    }
    

}

#Preview {
    MenuView(onStartTimeAttack: {}, onStartCasual: {})
}
