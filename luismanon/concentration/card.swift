//
//  card.swift
//  CardGame
//
//  Created by Luis Manon on 9/21/18.
//  Copyright © 2018 NioCoders. All rights reserved.
//

import Foundation

struct Cards {
    var isFaceUp =  false
    var isMatched =  false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory+=1
        return identifierFactory
    }
    
    init(){
        self.identifier =  Cards.getUniqueIdentifier()
    }
}
