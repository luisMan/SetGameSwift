//
//  GameDataModel.swift
//  luismanon
//
//  Created by lusi Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

class GameDataModel {
    
    //lets create a private variable to know when the game is in motion
    private var playing: Bool {
        get{
            return self.playing == true
        }
        set(value:Bool){
            
            self.playing = value
        }
        
    }
    
    //create a pointer that points toward our deck of cards
    private var cardDeck: ModelDeck
    
    
    //check if game has started
    func inGame() -> Bool {
        return playing == true
    }
    
    init(){
        
    }
    
    
}
