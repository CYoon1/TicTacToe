//
//  VM.swift
//  TicTacToe
//
//  Created by Christopher Yoon on 3/31/24.
//

import Foundation
import SwiftUI

@Observable
class VM {
    var spacing: CGFloat = 5
    var engine = Engine()
    
    var rowMax: Int  {
        engine.rowMax
    }
    var colMax: Int {
        engine.colMax
    }
    
    var isGameOver: Bool {
        engine.isGameOver
    }
    func resetGame() {
        engine.resetGame()
    }
    func getAlertText() -> String {
        engine.currentGameState.text
    }
    
    func tileView(row: Int, col: Int) -> some View {
        TileView(tile: engine.board[row][col])
            .onTapGesture {
                self.engine.handleTap(row: row, col: col)
            }
    }
}
