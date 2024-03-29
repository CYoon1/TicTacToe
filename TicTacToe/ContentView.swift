//
//  ContentView.swift
//  TicTacToe
//
//  Created by Christopher Yoon on 3/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct BoardView: View {
    @State var vm = VM()
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
    }
}
enum Player: Int {
    case none = 0, x, o
    var text: String {
        switch self {
        case .none:
            "blank"
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
    var engine = Engine()
    var rowMax: Int = 3
    var colMax: Int = 3
    var spacing: CGFloat = 5
    var isGameOver: Bool = false
    
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
    
    var isGameOver: Bool = false
    
    var currentPlayer : Player = .none
    func changeTurn() {
        if currentPlayer == .x {
            currentPlayer = .o
        } else {
            currentPlayer = .x
        }
    }
    
    func handleTap(row: Int, col: Int) {
        let selectedTile = board[row][col]
        guard selectedTile.player == .none else { return }
        changeTile(row: row, col: col)
        changeTurn()
    }
    func changeTile(row: Int, col: Int) {
        board[row][col].player = currentPlayer
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
    }
}
#Preview {
    BoardView()
}
