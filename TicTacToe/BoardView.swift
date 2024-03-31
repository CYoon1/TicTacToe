//
//  BoardView.swift
//  TicTacToe
//
//  Created by Christopher Yoon on 3/29/24.
//

import SwiftUI

struct BoardView: View {
    @State var vm = VM()
    @State var showAlert = false
    var body: some View {
        VStack(spacing: vm.spacing) {
            ForEach(0..<vm.rowMax, id: \.self) { row in
                HStack(spacing: vm.spacing) {
                    ForEach(0..<vm.colMax, id: \.self) { col in
                        vm.tileView(row: row, col: col)
                    }
                }
            }
        }
        .onChange(of: vm.isGameOver) {
            if vm.isGameOver {
                showAlert = true
            }
        }
        .alert("Game Over", isPresented: $showAlert) {
            Button {
                vm.resetGame()
            } label: {
                Text("OK")
            }
        } message: {
            Text(vm.getAlertText())
        }

    }
}
enum Player: Int {
    case none = 0, x, o
    var text: String {
        switch self {
        case .none:
            "none"
        case .x:
            "X"
        case .o:
            "O"
        }
    }
    var symbol: String {
        switch self {
        case .none:
            ""
        case .x:
            "xmark"
        case .o:
            "circle"
        }
    }
}
enum GameState: Int {
    case running = 0, xwin, owin, draw
    var text: String {
        switch self {
        case .running:
            "Game in Progress"
        case .xwin:
            "X has Won the Game"
        case .owin:
            "O has Won the Game"
        case .draw:
            "Game Results in a Tie"
        }
    }
}
struct Tile: Identifiable {
    var id : UUID = UUID()
    var player : Player = .none
}
struct TileView: View {
    var tile: Tile
    var body: some View {
        Image(systemName: tile.player.symbol)
            .resizable()
            .scaledToFit()
            .background {
                ZStack {
                    Rectangle().opacity(0.001)
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke()
                }
            }
    }
}

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
    
    @ViewBuilder
    func tileView(row: Int, col: Int) -> some View {
        TileView(tile: engine.board[row][col])
            .onTapGesture {
                self.engine.handleTap(row: row, col: col)
            }
    }
}
@Observable
class Engine {
    var board = [
        [Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile()],
    ]
    var rowMax: Int = 3
    var colMax: Int = 3
    
    var currentGameState : GameState = .running
    var isGameOver: Bool = false
    
    var currentPlayer : Player = .x
    func changeTurn() {
        guard currentGameState == .running else { return }
        if currentPlayer == .x {
            currentPlayer = .o
        } else {
            currentPlayer = .x
        }
    }
    
    func handleTap(row: Int, col: Int) {
        guard currentGameState == .running else { return }
        let selectedTile = board[row][col]
        guard selectedTile.player == .none else { return }
        changeTile(row: row, col: col)
        // check for win
        updateGameState()
    }
    func changeTile(row: Int, col: Int) {
        board[row][col].player = currentPlayer
    }
    
    func updateGameState() {
        // check for a win
        flagWin(player: checkDiagonalWin())
        flagWin(player: checkVerticalWin())
        flagWin(player: checkHorizontalWin())
        // else, check for a draw (all tiles filled)
        checkForDraw()
        // else, game continues (only change turn if game continues)
        changeTurn()
    }
    func flagWin(player: Player) {
        guard currentGameState == .running else { return }
        if player.text == "X" {
            // X Wins
            currentGameState = .xwin
            isGameOver = true
        } else if player.text == "O" {
            // O Wins
            currentGameState = .owin
            isGameOver = true
        } else {
            // No Win Detected
            currentGameState = .running
            isGameOver = false
        }
    }
    func checkDiagonalWin() -> Player {
        // check the 2 diagonals, return winning player or .none
        let center = board[1][1].player
        if center == .none {
            return .none
        }
        if ((center == board[0][0].player) && (center == board[2][2].player)) || ((center == board[2][0].player) && (center == board[0][2].player)) {
            return center
        }
        return .none
    }
    func checkVerticalWin() -> Player {
        // check the 3 verticals, return winning player or .none (Columns)
        if (board[0][0].player == board[1][0].player) && (board[0][0].player == board[2][0].player) && (board[0][0].player != .none) {
            // win in first column
            return board[0][0].player
        } else if (board[0][1].player == board[1][1].player) && (board[0][1].player == board[2][1].player) && (board[0][1].player != .none)  {
            // win in second column
            return board[0][1].player
        } else if (board[0][2].player == board[1][2].player) && (board[0][2].player == board[2][2].player) && (board[0][2].player != .none)  {
            // win in third column
            return board[0][2].player
        } else {
            // no win
            return .none
        }
    }
    func checkHorizontalWin() -> Player {
        // check the 3 horizontals, return winning player or .none (Rows)
        if (board[0][0].player == board[0][1].player) && (board[0][0].player == board[0][2].player) && (board[0][0].player != .none) {
            // win in first row
            return board[0][0].player
        } else if (board[1][0].player == board[1][1].player) && (board[1][0].player == board[1][2].player) && (board[1][0].player != .none)  {
            // win in second row
            return board[1][0].player
        } else if (board[2][0].player == board[2][1].player) && (board[2][0].player == board[2][2].player) && (board[2][0].player != .none)  {
            // win in third row
            return board[0][2].player
        } else {
            // no win
            return .none
        }
        
    }
    func checkForDraw() {
        guard currentGameState == .running else { return }
        // check all spots for .none
        var numberOfEmptyTiles: Int = 0
        for row in 0..<rowMax {
            for col in 0..<colMax {
                if board[row][col].player == .none {
                    numberOfEmptyTiles += 1
                }
            }
        }
        // if there are 0 spots, game is a draw
        if numberOfEmptyTiles == 0 {
            currentGameState = .draw
            isGameOver = true
        }
        // otherwise continue
    }
    
    func resetGame() {
        print("Resetting Game")
        board = [
            [Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile()],
        ]
        isGameOver = false
        currentPlayer = .x
        currentGameState = .running
    }
}
#Preview {
    BoardView()
}
