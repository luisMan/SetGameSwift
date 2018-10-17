//
//  GameDataModel.swift
//  luismanon
//
//  Created by lusi Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import UIKit
class GameDataModel {
    //create a pointer that points toward our deck of cards
    private var cardDeck = ModelDeck()
    private var view: ViewController = ViewController()
    
    //our game factory singleton to detect any potential patterns
    private var logicSetsFactory = [GameFactorySingleton]()

    private var pivot = 11;
    //maximum number of cards
    private let max_grid =  23;
    
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
    func ComputeSet()
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
            //initialize the set and now lets check some logics
            print("first card ",firstCard?.contents(),"\nshading ", firstCard?.shaded ,"\ncolor ", firstCard?.color,"\nshape ",firstCard?.shape,"\ncount ",firstCard?.count)
             print("second card ",secondCard?.contents(),"\nshading ", secondCard?.shaded ,"\ncolor ", secondCard?.color,"\nshape ",secondCard?.shape,"\ncount ",secondCard?.count)
              print("third card ",thirdCard?.contents(),"\nshading ", thirdCard?.shaded ,"\ncolor ", thirdCard?.color,"\nshape ",thirdCard?.shape,"\ncount ",thirdCard?.count)
            let gameSet =  GameFactorySingleton(firstCard: firstCard!, secondCard: secondCard!, thirdCard: thirdCard!)
            
            if gameSet.isASet() {
                print (" whoooooot!!! we found a set host!!! " )
                
               
                 for index in view.getGameSetBasket().indices {
                view.objectToFlush.append(view.getGameSetBasket()[index].key)
                }
        
            }else{
                print("Is not a set host :-(")
            }
    
        }
        
        view.flushColor();
        
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
    
    
    //function checking if can deal
    func canDealMoreCards() ->  Bool {
        return pivot == max_grid
    }
    
    //get card pivot to deal on desk
    func getCardPivot() -> Int{
        return pivot
    }
    
    init( type: ViewController){
        //lets set the score to 0
        self.score = 0
        self.view = type
        print("the lengh of our cardDeck is \(cardDeck.getTotalDeck())")
    }
    
    
}
