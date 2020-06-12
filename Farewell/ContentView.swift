//
//  ContentView.swift
//  Farewell
//
//  Created by Ahmad Alhashemi on 2020-06-11.
//  Copyright © 2020 Ahmad Alhashemi. All rights reserved.
//

import SwiftUI

struct Conway {
    let gridSize: Int
    private var data: [Bool]

    init(gridSize: Int) {
        self.gridSize = gridSize
        self.data = Array(repeating: false, count: gridSize * gridSize)
    }

    subscript(x x: Int, y y: Int) -> Bool {
        get { data[y * gridSize + x] }
        set { data[y * gridSize + x] = newValue }
    }

    private func liveNeighbours(x: Int, y: Int) -> Int {
        // check all neighbours
        return (self[x: x - 1, y: y - 1] ? 1 : 0) +
            (self[x: x, y: y - 1] ? 1 : 0) +
            (self[x: x + 1, y: y - 1] ? 1 : 0) +
            (self[x: x - 1, y: y] ? 1 : 0) +
            (self[x: x + 1, y: y] ? 1 : 0) +
            (self[x: x - 1, y: y + 1] ? 1 : 0) +
            (self[x: x, y: y + 1] ? 1 : 0) +
            (self[x: x + 1, y: y + 1] ? 1 : 0)
    }
    
    mutating func tick() {
        var changeList: [(x: Int, y: Int, v: Bool)] = []

        for x in 1..<(gridSize - 1) {
            for y in 1..<(gridSize - 1) {
                let ln = liveNeighbours(x: x, y: y)
                
                if ln == 2 {
                    // 2 neighbours & alive, stays alive otherwise stays dead
                } else if ln == 3 {
                    // 3 neighbours and dead becomes alive
                    if !self[x: x, y: y] { changeList.append((x, y, true)) }
                } else {
                    // any number of neighbours other than 2 or 3 and alive should die
                    if self[x: x, y: y] { changeList.append((x, y, false)) }
                }
            }
        }
        
        // apply changes
        for (x, y, v) in changeList {
            self[x: x, y: y] = v
        }
    }
}

struct ContentView: View {
    @State var conway = Conway(gridSize: 64)
    @State var autoPlay = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            VStack(spacing: 2) {
                ForEach(0..<self.conway.gridSize) { y in
                    HStack(spacing: 2) {
                        ForEach(0..<self.conway.gridSize) { x in
                            Button(action: {
                                self.conway[x: x, y: y].toggle()
                            }) {
                                Rectangle()
                                    .fill(self.conway[x: x, y: y] ? Color.black : Color.white)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            .background(Color.black)
            .onReceive(timer) { _ in
                if self.autoPlay {
                    self.conway.tick()
                }
            }
            
            Spacer()
            HStack {
                Button(action: {
                    self.conway.tick()
                }) {
                    Text("Tick")
                }
                
                Button(action: {
                    self.autoPlay.toggle()
                }) {
                    if self.autoPlay {
                        Text("Pause")
                    } else {
                        Text("Play")
                    }
                }

            }
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
