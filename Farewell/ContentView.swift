//
//  ContentView.swift
//  Farewell
//
//  Created by Ahmad Alhashemi on 2020-06-11.
//  Copyright © 2020 Ahmad Alhashemi. All rights reserved.
//

import SwiftUI

let maxSize = 64

struct Conway {
    private var data = Array(repeating: false, count: maxSize * maxSize)

    subscript(x x: Int, y y: Int) -> Bool {
        get { data[y * maxSize + x] }
        set { data[y * maxSize + x] = newValue }
    }

    private func liveNeighbours(x: Int, y: Int) -> Int {
        var count = 0
        
        // check all neighbours
        for nx in (x - 1)...(x + 1) {
            for ny in (y - 1)...(y + 1) {
                if self[x: nx, y: ny] { count += 1 }
            }
        }
        
        // don't count ourselves
        if self[x: x, y: y] { count -= 1 }
        
        return count
    }
    
    mutating func tick() {
        var next = self
        for x in 1..<(maxSize - 1) {
            for y in 1..<(maxSize - 1) {
                let ln = liveNeighbours(x: x, y: y)
                
                if ln == 2 {
                    // 2 neighbours & alive, stays alive otherwise stays dead
                } else if ln == 3 {
                    // 3 neighbours will always stay alive
                    next[x: x, y: y] = true
                } else {
                    // any number of neighbours other than 2 or 3 will die or stay dead
                    next[x: x, y: y] = false
                }
            }
        }
        
        // replace the current matrix with the next one
        self = next
    }
}

struct ContentView: View {
    @State var conway = Conway()
    
    var body: some View {
        VStack {
            VStack(spacing: 2) {
                ForEach(0..<maxSize, id: \.self) { y in
                    HStack(spacing: 2) {
                        ForEach(0..<maxSize, id: \.self) { x in
                            Button(action: {
                                self.conway[x: x, y: y].toggle()
                            }) {
                                Rectangle()
                                    .fill(self.conway[x: x, y: y] ? Color.black : [Color.blue, Color.green].randomElement()!)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }.aspectRatio(1.0, contentMode: .fit)
            Spacer()
            Button(action: {
                self.conway.tick()
            }) {
                Text("Tick")
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
