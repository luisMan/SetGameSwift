//
//  GameDataModel.swift
//  luismanon
//
//  Created by lusi Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

class GameDataModel {
    //create a pointer that points toward our deck of cards
    private var cardDeck = ModelDeck()
    
    public var score: Int = 0
    //lets create a private variable to know when the game is in motion
    private var playing: Bool {
        get{
            return self.playing == true
        }
        set(value){
            
            self.playing = value
        }
    }
    
    func upDateScore(val: Int){
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
    
    
    init(){
        //lets set the score to 0
        self.score = 0
        print("the lengh of our cardDeck is \(cardDeck.getTotalDeck())")
    }
    
    
}
