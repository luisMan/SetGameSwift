//
//  ViewController.swift
//  CardGame
//
//  Created by Luis Manon on 9/21/18.
//  Copyright © 2018 NioCoders. All rights reserved.
//

import UIKit

class concViewController: UIViewController {

    private lazy var game =  concentration(numberOfPairsOfCards: numberOfPairsOfCards, type: self)
    public var gameTheme: Int = 0
    private var emoji = [Int: String]()
    
    public var inGame = false
    
    var timer: Timer!
    
    private var snow = ["🌨", "✲", "🐼", "❄️", "⛸", "⛷", "☃️", "🍭", "⛄️"]
    private var forest = ["🐛","🦋","🐞","🐝","🐌","🍄","🐇","🕷","🐜"]
    private var halloween = ["😈","🍭","🧟‍♀️","🧟‍♂️","☠️","💀","👻","🤡","🎃"]
   
    let themes = [
        "Sports"   : "🌨✲🐼❄️⛸⛷☃️🍭⛄️",
        "forest"  : "🐶🐱🐭🦊🦁🐸🐔🦑🕷🐙🐖",
        "faces"    : "😀😙😛🤣😇😎😡🤡👹🤠",
        ]
    
    var theme: String? {
        didSet {
            //emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    var numberOfPairsOfCards: Int{
        return (cardButtons.count + 1 ) / 2
    }

    //array of image backgrounds
    var themeBackgrounds: [UIImage] = [
        UIImage(named: "forest.png")!,
        UIImage(named: "halloween.png")!,
        UIImage(named: "snow.png")!
    ]
    
  
  
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var timerCountLabel: UILabel!
    
    @IBOutlet var gameScoreLabel: UILabel!
    
    @IBOutlet var RandomTheme: UIButton!
    @IBOutlet var PlayGame: UIButton!
    
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private(set) var flipCounts = 0 {
        didSet{
            flipCountLabel.text =  "Flips : \(flipCounts)"
        }
    }
    
    
    public var gameTimer = 0 {
        didSet{
            timerCountLabel.text = "Timer : \(gameTimer)"
        }
    }
    
    public var gameScore = 0{
        didSet{
            gameScoreLabel.text = "Score : \(gameScore)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func touchCard(_ sender: UIButton){
        if !inGame{
            startGameOrRestart(sender)
        }else{
        flipCounts+=1
        if let cardNumber  =  cardButtons.index(of: sender)
        {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("chosen card was not int the collection")
        }
        }//close else
    }
    
    @IBAction func newGame(_ sender: UIButton)
    {
        if !inGame || inGame {
            
            restartGame()
            
        }
       print("the button new Game has been clicked!")
        
    }
    
    @IBAction func RandomTheme(_ sender: UIButton)
    {

        changeViewModelBackgroundAndGameTheme();
        
    }
    
    
    //this function is going to be call when ever the user click random theme
    func changeViewModelBackgroundAndGameTheme()
    {
        gameTheme = themeBackgrounds.count.arc4randomTheme
        print("The random index for background is now \(gameTheme)")
        
        self.view.backgroundColor = UIColor(patternImage: themeBackgrounds[gameTheme])

    }
    
    
    private func emoji(for card: Cards) -> String {
        switch gameTheme {
        case 0:
            if emoji[card.identifier] == nil , forest.count > 0 {
                let randomIndex = forest.count.arc4random
                emoji[card.identifier] = forest.remove(at: randomIndex)
            }
            break
        case 1:
            if emoji[card.identifier] == nil , halloween.count > 0 {
                let randomIndex = halloween.count.arc4random
                emoji[card.identifier] = halloween.remove(at: randomIndex)
            }
            break
        case 2:
            if emoji[card.identifier] == nil , snow.count > 0 {
                let randomIndex = snow.count.arc4random
                emoji[card.identifier] = snow.remove(at: randomIndex)
            }
            break
        default:
            break
        }
       
        return emoji[card.identifier] ?? "?"
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.2)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            
            }
        }
    }
    
    
    
    
    //lets declare a new method to be shown when the user start clicking without starting a new game
    @IBAction func startGameOrRestart(_ sender: UIButton) {
      
        if !inGame{
              let startGame = UIAlertController(title: "CardGame", message: "Please start Game to play!", preferredStyle: .alert)
              let gameAction = UIAlertAction(title: "play", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.inGame = !self.inGame
                self.changeViewModelBackgroundAndGameTheme()
                self.PlayGame.setTitle("InGame", for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                
            }
            
             startGame.addAction(gameAction)
             present(startGame, animated: true, completion:nil)
        }
        
    }
    
    func allMatched() -> Bool{
        var counter: Int = 0
        for index in cardButtons.indices {
          
            if game.cards[index].isMatched {
                counter += 1
            }
        }
        if counter>=cardButtons.count{
            return  true
        }
        
    return false
    }
    
    
    //restart game method
    func restartGame(){
        
        if gameTimer == 0 {
            changeViewModelBackgroundAndGameTheme()
             self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }else{
            gameTimer = 0
             self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
    
        game =  concentration(numberOfPairsOfCards: numberOfPairsOfCards, type: self)
        for index in cardButtons.indices {
            game.cards[index].isMatched = false
            game.cards[index].isFaceUp = false
        }
        
        //set the ingame = false
        inGame =  true
        self.PlayGame.setTitle("inGame", for: .normal)
        flipCounts = 0
        gameScore = 0
        
        
        updateViewFromModel()
        snow = ["🌨", "✲", "🐼", "❄️", "⛸", "⛷", "☃️", "🍭", "⛄️"]
        forest = ["🐛","🦋","🐞","🐝","🐌","🍄","🐇","🕷","🐜"]
        halloween = ["😈","🍭","🧟‍♀️","🧟‍♂️","☠️","💀","👻","🤡","🎃"]
        
    }
    
    //the status report game alert on finish
    func showGameStats()
    {
        let gameFinish = UIAlertController(title: "CardGame", message: "Nice host! \n Your Score : \(gameScore) your Time : \(gameTimer) \n in this many flips : \(flipCounts)", preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart", style: .default) { (alert: UIAlertAction!) -> Void in
            self.restartGame()
        }
        gameFinish.addAction(restart)
        present(gameFinish,animated: true, completion:nil)
    }
    
    
    //this is going to be my function to update the timer every 5 second
    @objc
    func update()
    {
        if inGame{
            gameTimer += 1;
            //lets check when we are over with the game :-)
            if allMatched(){
                print("The game has ended we can show status report")
                timer.invalidate()
                showGameStats()
            }
            
        }else{
            timer.invalidate()
        }
    }
}


extension Int{
    var arc4randomTheme: Int{
        return Int(arc4random_uniform(UInt32(self)))
    }
}

