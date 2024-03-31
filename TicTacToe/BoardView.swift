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

#Preview {
    BoardView()
}
