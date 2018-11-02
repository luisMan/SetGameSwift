//
//  GameFactorySingleton.swift
//  luismanon
//
//  Created by Luis Manon on 10/16/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import UIKit

struct GameFactorySingleton : Hashable {
    private var identifier: Int
    private var view: ViewController = ViewController()
    
    var shape = Set<String>()
    var color = Set<String>()
    var counter = Set<Int>()
    var shaded = Set<String>()
    
   
    var hashValue: Int {
        return self.identifier
    }
    public var  firstCard, secondCard, thirdCard : ModelCards
    //this is a hashable function to check whether two GameFactorySingleton set object are equal to each other
      static func == (lhs: GameFactorySingleton, rhs: GameFactorySingleton) -> Bool {
         return (lhs.hashValue==rhs.hashValue)
        }
    
    //set the view controller after object initialization
    mutating func setViewController(view: ViewController) {
        self.view  =  view
    }
    //================================================Shape ========================
    //get shape for first card
    func getShapeStringForCard(obj: ModelCards) -> String {
        switch obj.shape {
        case .oval:
            return "oval"
        case .diamond:
            return "diamond"
        case .custom:
            return "custom"
        }
    }
  
    //==========================================shaded===========================
    //get shape for first card
    func getShadeStringForCard(obj: ModelCards) -> String {
        switch obj.shaded {
        case .outlined:
            return "outlined"
        case .filled:
            return "filled"
        case .stiped:
            return "stiped"
        }
    }

    //============================================color logic =========================
    func getColorStringForCard(obj: ModelCards) -> String {
        switch obj.color {
        case .red:
            return "red"
        case .green:
            return "green"
        case .purple:
            return "purple"
        }
    }
 
   
    mutating func computeSetAlgorithmLogic() -> Bool{
        //set the shaped
        shape.insert(getShapeStringForCard(obj: firstCard))
        shape.insert(getShapeStringForCard(obj: secondCard))
        shape.insert(getShapeStringForCard(obj: thirdCard))
        //color
        color.insert(getColorStringForCard(obj: firstCard))
        color.insert(getColorStringForCard(obj: secondCard))
        color.insert(getColorStringForCard(obj: thirdCard))
        //shade
        print("cards shaded = f = \(firstCard.shaded)",
          "\n s = \(secondCard.shaded)", "\n t = \(thirdCard.shaded)")
        shaded.insert(getShadeStringForCard(obj: firstCard))
        shaded.insert(getShadeStringForCard(obj: secondCard))
        shaded.insert(getShadeStringForCard(obj: thirdCard))
        //counter
        counter.insert(firstCard.count)
        counter.insert(secondCard.count)
        counter.insert(thirdCard.count)
        
   // print (" the shade = \(shaded.count) ", "\n shaped = \(shape.count) ","\n color = \(color.count) ","\n counter = \(counter.count)")
        if (shape.count == 3 || shape.count == 1)
          && (color.count == 3 || color.count == 1)
          && (shaded.count == 3 || shaded.count == 1)
            && (counter.count == 3 || counter.count == 1) {
            print("is a set found ")
            return true
        }
        
      return false
    }
    
    
    mutating func isASet() -> Bool {
  
        //magic begins lol for my algorithm
        if computeSetAlgorithmLogic() {
            return true;
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
