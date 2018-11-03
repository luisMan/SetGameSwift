//
//  MainViewGame.swift
//  luismanon
//
//  Created by Braulio Manon on 11/2/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

@IBDesignable class MainViewGame: UIView {
    
    
    override func layoutSubviews() {
        super .layoutSubviews()
        let grid = Grid(for: self.bounds, withNoOfFrames: self.subviews.count, forIdeal: 0.5)
        
        for index in self.subviews.indices{
            if var frame = grid[index] {
                frame.size.width -= 5
                frame.size.height -= 5
                self.subviews[index].frame = frame
            }
            
        }
       // print("the size of the array inside frid is = \() ")
    }
}
