//
//  ModelDeck.swift
//  luismanon
//
//  Created by Luis Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

//lets create an struct
struct ModelDeck {
    
    //lets create an array of deck using our deck of cards we declaring private since we are the only one
    //accesing this variable
    private var deck: [ModelCards]
    
    //lets get the total number of cards
    func getTotalDeck() -> Int {
        return self.deck.count
    }
    
    //check if the deck is empty
    //this function will return empty if the counter ==0 other wise false
    func isDeckEmpty() -> Bool {
        return self.deck.count == 0
    }
    
    
    //lets get single card from the deck we are using mutating func since we will be changing
    //the value on deck within this class
    //this function will be removing a card every single time is been call\
    //oh yes ! almost forgot we use ? because this function can either be nil or not
    mutating func dealCard() -> ModelCards? {
        if(!self.isDeckEmpty()){
            let card =  deck.remove(at: 0)
            return card
        }
        return nil
    }
    
    
    //lets have an initializer to this class of deck
    init(){
        //create an empty array of cards
        self.deck = [ModelCards]()
        
        //lets create the deck
        for shape in ModelCards.Shapes.all {
            for color in ModelCards.Colors.all {
                for shade in ModelCards.Shades.all{
                    for count in 1...3 {
                        let card =  ModelCards(shape: shape, color: color, shaded: shade, count: count)
                        
                        self.deck.append(card)
                    }
                }
            }
        }//close outer loop
        
        
        //let shuffle this deck a little
        for _ in 1...10 {
            for index in self.deck.indices {
                let randomIndex =  index.arc4random
                let card =  self.deck.remove(at: randomIndex)
                self.deck.append(card)
                
            }
        }
    }//close init function
}

extension Int {
    var arc4random: Int {
        if(self > 0){
        return Int(arc4random_uniform(UInt32(self)))
        }else if( self < 0 ){
        return Int(arc4random_uniform(UInt32(-self)))
        }else{
            return 0
        }
    }
}
