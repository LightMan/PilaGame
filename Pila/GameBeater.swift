//
//  Waiter.swift
//  Pila
//
//  Created by Dev2 on 25/04/2019.
//  Copyright © 2019 Dev2. All rights reserved.
//

import Foundation

protocol GameBeaterDelegate {
    func beater(_ beater: GameBeater, hasNewGameItem item: GameItem)
}

class GameBeater {

    let factory: RandomFactory

    var timer: Timer?
    var delegate: GameBeaterDelegate?
    
    init(itemFactory: RandomFactory) {
        self.factory = itemFactory
    }
    
    func startWorking(){
        timer = Timer.scheduledTimer(withTimeInterval: 2.000, repeats: true) { [weak self] (timer) in
            
            if let strongSelf = self {
                let gameItem = strongSelf.factory.generateRandom()
                debugPrint("Plato creado \(gameItem)")

                if strongSelf.delegate != nil {
                    strongSelf.delegate?.beater(strongSelf, hasNewGameItem: gameItem)
                }
            }
        }
    }
    
    func stopWorking() {
        timer?.invalidate()
    }
    
}
