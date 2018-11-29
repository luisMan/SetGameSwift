//
//  concentration.swift
//  CardGame
//
//  Created by Luis Manon on 9/21/18.
//  Copyright © 2018 NioCoders. All rights reserved.
//

import Foundation

class concentration {
    
    private var ViewControl: concViewController = concViewController();
    //this is for extra credit this array will contain all the keys from a mis match case
    var emptyKeys: Array<Cards> = Array()

    var cards = [Cards]()
   
    
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    }else{
                        foundIndex = nil
                    }
                }
            }
            return foundIndex
        }
        set(newValue){
            for index in cards.indices {
                cards[index].isFaceUp = (index==newValue)
            }
        }
    }
    
    //lets add some penalties if we happen to see the same card coming more than one with a miss match
    func addPenaltieToGameMissMatch(index: Cards, matchIndex: Cards)
    {
        if(emptyKeys.isEmpty){
            if(!index.isMatched){ emptyKeys.append(index)}
            if(!matchIndex.isMatched){emptyKeys.append(matchIndex)}
            
        }else{

            var toDelete: Array<Int> = Array()
            for item in emptyKeys.indices {
                var penaltie =  false
                if emptyKeys[item].identifier == index.identifier && !index.isMatched {
                    penaltie = true
                }
                
                if emptyKeys[item].identifier == matchIndex.identifier && !matchIndex.isMatched{
                    penaltie = true
                }
                if(penaltie){
                     ViewControl.gameScore -= 100
                     toDelete.append(item)
                }
            }
            
            if toDelete.count == 0 {
                emptyKeys.append(index)
                emptyKeys.append(matchIndex)
            }
            
            //lets remove all items that been flag as penalties
            if toDelete.count > 0 {
                for indicis in toDelete.indices{
                emptyKeys.remove(at: indicis)
                }}
            
            print("the size of the indices of matched cards  \(emptyKeys.count)")
           
            
        }//close else
        
        
    
        
    }//close method
    
    
    func chooseCard(at index: Int)
    {
        if !cards[index].isMatched {
            if let matchIndex =  indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched =  true
                    ViewControl.gameScore += 200
                }else{
                    addPenaltieToGameMissMatch(index: cards[index], matchIndex: cards[matchIndex])
                }
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard =  index
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int, type: concViewController)
    {
        //lets set the viewControl game object
        self.ViewControl = type
        
        for _ in 1...numberOfPairsOfCards {
            let card =  Cards()
            cards += [card,card]
        }
        print("The cards size  =  \(cards.count)")
        //this is kind of hard since never program on swift but now lets implement my logic
        //we have 12 cards insize the dictionary now we just need to swap cards by some random index from 1-12
        for index in 0...cards.count - 1 {
            //lets iterate 12 times
            let randomIndex = cards.count.arc4randomCard;
            let temp =  cards[index]
            cards[index] =  cards[randomIndex]
            cards[randomIndex] = temp
        }
        //here we  need to shuffle the deck of cards for the homework rubric
    }
    
}
extension Int{
    var arc4randomCard: Int{
        return Int(arc4random_uniform(UInt32(self)))
    }
}

