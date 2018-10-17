//
//  GameFactorySingleton.swift
//  luismanon
//
//  Created by Luis Manon on 10/16/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

struct GameFactorySingleton : Hashable {
    private var identifier: Int
    var hashValue: Int {
        return self.identifier
    }
    var  firstCard, secondCard, thirdCard : ModelCards
    
    
    //this is a hashable function to check whether two GameFactorySingleton set object are equal to each other
      static func == (lhs: GameFactorySingleton, rhs: GameFactorySingleton) -> Bool {
         return (lhs.hashValue==rhs.hashValue)
        }
    
    
     func isShapeLogicComplete() -> Bool {
        if (firstCard.shape == secondCard.shape &&
            firstCard.shape == thirdCard.shape &&
            thirdCard.shape == secondCard.shape){
            return true;
        }else if (firstCard.shape != secondCard.shape &&
            firstCard.shape != thirdCard.shape &&
            thirdCard.shape != secondCard.shape) {
            return true;
        }else{
            return false;
        }
    
    }
    
    func isColorLogicComplete() -> Bool {
        
        if (firstCard.color == secondCard.color &&
            firstCard.color == thirdCard.color &&
            thirdCard.color == secondCard.color){
            return true;
        }else if (firstCard.color != secondCard.color &&
            firstCard.color != thirdCard.color &&
            thirdCard.color != secondCard.color) {
            return true;
        }else{
            return false;
        }
    }
    
    func isShadinglogicComplete()-> Bool {
        if (firstCard.shaded == secondCard.shaded &&
            firstCard.shaded == thirdCard.shaded &&
            thirdCard.shaded == secondCard.shaded){
            return true;
        }else if (firstCard.color != secondCard.color &&
            firstCard.color != thirdCard.color &&
            thirdCard.color != secondCard.color) {
            return true;
        }else{
            return false;
        }
        
    }
    
    
    func isCounterLogicComplete()-> Bool {
         if (firstCard.count == secondCard.count &&
            firstCard.count == thirdCard.count &&
            thirdCard.count == secondCard.count){
            return true;
        }else if (firstCard.count != secondCard.count &&
            firstCard.count != thirdCard.count &&
            thirdCard.count != secondCard.count) {
            return true;
        }else{
            return false;
        }
        
    }
    
    
    func isASet() -> Bool {
        var counter = 0
        //magic begins lol for my algorithm
        if  (isShapeLogicComplete()){
           print("shape is equal or differents")
            counter = counter + 1
        }
        if(isColorLogicComplete()) {
            print("color  is equal or differents")
            counter = counter + 1
        }
        if(isShadinglogicComplete()) {
            print("shading is equal or differents")
            counter = counter + 1
        }
        if(isCounterLogicComplete()){
            print("counter is equal or differents")
            counter = counter + 1
        }
        
        print("the counter \(counter)")
        if counter == 4 {
          return true
        }
     
     return false
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    //initializer function
    init(firstCard: ModelCards, secondCard: ModelCards, thirdCard: ModelCards)
    {
        self.firstCard = firstCard
        self.secondCard = secondCard
        self.thirdCard =  thirdCard
        identifier = GameFactorySingleton.getUniqueIdentifier()
    }
    
    
}
