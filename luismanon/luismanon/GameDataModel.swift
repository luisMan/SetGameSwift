//
//  GameDataModel.swift
//  luismanon
//
//  Created by lusi Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import UIKit
struct GameDataModel {
    //create a pointer that points toward our deck of cards
    private var cardDeck = ModelDeck()
    private var view: ViewController = ViewController()
    
    var PvCShape = Set<String>()
    var PvCColor = Set<String>()
    var PvCCounter = Set<Int>()
    var PvCShaded = Set<String>()
    
    //our game factory singleton to detect any potential patterns
    private var logicSetsFactory = Set<GameFactorySingleton>()
    
    //tree collection of key and childrens well a close aproach to that of A* algorithm
    private var tree = Dictionary<SetCardView, [SetCardView]>()
    

    private var pivot = 11;
    //maximum number of cards
    private let max_grid =  24;
    
    public var score: Int = 0
    
    //this is our timer
    public var gameTimer: Int = 0
    //lets create a private variable to know when the game is in motion
    private var playing: Bool {
        get{
            return self.playing == true
        }
        set(value){
            
            self.playing = value
        }
    }
    
    
    //compute a set base on user input
    mutating func ComputeSet()
    {
        var counter = 0;
        var firstCard,secondCard,thirdCard: ModelCards?
       
        //well well now we are getting a game basket with three index items lets do some work
        for index in view.getGameSetBasket().indices {
            if counter == 0 {
                firstCard = view.getGameSetBasket()[index].value
            }else if counter == 1 {
                secondCard =  view.getGameSetBasket()[index].value
            }else {
                thirdCard =  view.getGameSetBasket()[index].value
            }
            counter = counter + 1
        }
        
        if firstCard != nil && secondCard != nil && thirdCard != nil {
          
            var gameSet =  GameFactorySingleton(firstCard: firstCard!, secondCard: secondCard!, thirdCard: thirdCard!)
            
            if gameSet.isASet() {
                
                //lets give fewer point to the user since he peak before finding this set
                if view.peakSets.count > 0 {
                    //since a set is hashable
                    if view.peakSets[0] == gameSet {
                    score = score + 100 - view.countBeforeFoundSet
                    }else{
                        score = score + 300 - view.countBeforeFoundSet
                    }
                }else{
                    score = score + 300 - view.countBeforeFoundSet
                }
                
                print (" whoooooot!!! we found a set host!!! " )
                
                 for index in view.getGameSetBasket().indices {
                 view.objectToFlush.append(view.getGameSetBasket()[index].key)
                }
                
                //reset the counter again to see if user gets smarter
                view.countBeforeFoundSet = 0
        
            }else{
                score = score - 500
                print("Is not a set host :-(")
                view.flushColor()
            }
    
        }
        
    }
    
    
    
    
    mutating func upDateScore(val: Int){
        score = score + val
    }

    //pointer to return the cardDeck objec
    func cardDeckObject() -> ModelDeck {
        return cardDeck
    }
    
    
    //check if game has started
    func inGame() -> Bool {
        return playing == true
    }
    
    
    //function checking if can deal
    func canDealMoreCards() ->  Bool {
        return view.counterOnPeak < max_grid
    }
 
    func getCardMaxGrid() -> Int {
        return max_grid;
    }
    
    //lets get an object reference to the computed sets
     mutating func getComputedAISets()->Set<GameFactorySingleton> {
        return self.logicSetsFactory
    }
    
    mutating func AppendANewHintAsSetToViewController()
    {
        //first remove all 
         view.peakSets.removeAll()
        
        if self.logicSetsFactory.count > 0 {
            let rand = logicSetsFactory.count.arc4Ran
            var count = 0
            for index in logicSetsFactory.indices {
                if count == rand {
                    //showing a new set
                   // print("we found a random set now lets show it ")
                    view.peakSets.append(logicSetsFactory.remove(at: index))
                    view.starPickTimer = true
                    return
                }//close if
                count = count + 1
            }
          
        }
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
    
    
    
    //check logic between two Card object
   mutating func comparePossibleChildOrMatchElement(one: ModelCards, two: ModelCards) ->Bool {
        //check color
        PvCColor.insert(getColorStringForCard(obj: one))
        PvCColor.insert(getColorStringForCard(obj: two))
        //check shape
        PvCShape.insert(getShapeStringForCard(obj: one))
        PvCShape.insert(getShapeStringForCard(obj: two))
        //check shaded
        PvCShaded.insert(getShadeStringForCard(obj: one))
        PvCShaded.insert(getShadeStringForCard(obj: two))
        //counter
        PvCCounter.insert(one.count)
        PvCCounter.insert(two.count)
        
        
        if (PvCColor.count == 1 || PvCColor.count == 2)
            && (PvCShape.count == 1 || PvCShape.count == 2)
            && (PvCCounter.count == 1 || PvCCounter.count == 2)
            && (PvCShaded.count == 1){
            return true
        }
        return false
    }
    
    
    //check if parent node exist on our tree
    func isParentNodeAdded(parent: SetCardView) -> Bool {
        //check the node on parent
        for key in tree.keys {
         
            if parent == key {
                return true
            }
            //check the node on the child object lol
            if(tree[key]!.count > 0 ){
            for child in tree[key]! {
                if parent == child {
                    return true
                }//close if
            }//close inner for
            }//close if
            
        }
        
        return false
    }
    
    //lets create a custom algorithm check to search for possible sets on a grid
  mutating func computePossibleAlgorithms()
    {
        //clear the tree before computing algorithm
        tree.removeAll()
        
        //start the logic
        for index  in  0..<view.counterOnPeak {
            //this is a button and is our tree key
           if view.viewButtons[index].enabled {
            let parentKey =  view.viewButtons[index]
            var childrenButtons = [SetCardView]()
        
            for colums  in 0..<view.counterOnPeak {
                //avoid checking same key parent
                if view.viewButtons[colums].enabled {
                if index !=  colums {
                    PvCShaded.removeAll()
                    PvCCounter.removeAll()
                    PvCShape.removeAll()
                    PvCColor.removeAll()
                    let cardKey =  view.gameCollection[parentKey]
                    let childNode =  view.gameCollection[view.viewButtons[colums]]
                    if comparePossibleChildOrMatchElement(one: cardKey!, two: childNode!) == true {
                 //add the childrens to the parent node
                        childrenButtons.append(view.viewButtons[colums])
                    }
                    
                }//close if
                }//close if enabled
            }//close inner loop
            //lets insert the key and childrens if the parent is not on tree
            if !isParentNodeAdded(parent: parentKey) {
            tree.updateValue(childrenButtons, forKey: parentKey)
            }
            }//close is enabled*/
        }
        
        
        //lets output computed tree
       // outPutDataStructureTree()
        storeSetForPeakOrLogicAI();
    }
    
    
    //output Tree lol
    func  outPutDataStructureTree()
    {
        if tree.count > 0 {
            for obj in tree.indices {
                let keyButton = tree[obj].key
                let CardObject =  view.gameCollection[keyButton]!
                print("parent node \(String(describing: CardObject.contents())) type = \(CardObject.shaded) color = \(String(describing: CardObject.color)) \n")
                for columns in tree[obj].value.indices {
                     let childObject = view.gameCollection[tree[obj].value[columns]]!
                    print("\(childObject.contents()) type = \(childObject.shaded)")
                }
                print("\n")
            }//close loop
        }//close if
    }
    
    //now magic happens lets get the sets
    mutating func storeSetForPeakOrLogicAI(){
        logicSetsFactory.removeAll()
        if tree.count > 0 {
            for obj in tree.indices {
                let keyButton = tree[obj].key
                
                let values =  tree[obj].value
                
                
                for index in values.indices {
                    //get the button
                    let button2 =  values[index]
                    for column in values.indices {
                        if index != column {
                            //third button
                            let button3 = values[column]
            
                            let cardOne = view.gameCollection[keyButton]
                            let cardTwo =  view.gameCollection[button2]
                            let cardThree =  view.gameCollection[button3]
                            //lets check a pisble set and if a set added it to the logicSetFactory
                            var logicCheck =  GameFactorySingleton(firstCard: cardOne!, secondCard: cardTwo!, thirdCard: cardThree!)
                            if logicCheck.isASet() {
                                //we found a dinamic set then lets add it to the factory lol
                                logicSetsFactory.insert(logicCheck)
                            }//close inner if
                            
                        }//clos eif
                    }//close column for loop
                }//close out inner loop
    
            }//close out first loop
        }//close if
        
        print("In this grid there are this many sets = \(logicSetsFactory.count)")
    }
    
    init( type: ViewController){
        //lets set the score to 0
        self.score = 0
        self.view = type
       // print("the lengh of our cardDeck is \(cardDeck.getTotalDeck())")
    }
    
}


//compute a random index
extension Int {
    var arc4Ran: Int {
        if(self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        }else if( self < 0 ){
            return Int(arc4random_uniform(UInt32(-self)))
        }else{
            return 0
        }
    }
}

