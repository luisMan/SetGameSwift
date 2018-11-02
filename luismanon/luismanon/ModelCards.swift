//
//  ModelCards.swift
//  luismanon
//
//  Created by Luis Manon on 10/13/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import UIKit

class ModelCards{
    let shape: Shapes
    let color: Colors
    let shaded: Shades
    let count: Int
    
    //lets declare a function contents to return the content data for this given Card obj
    func contents() -> String{
        var contents = ""
        var shape:String
        
        switch(self.shape){
        case .custom: shape = "#"
        case .diamond: shape = "▲"
        case .oval: shape = "●"
        }
        
        for _ in 1...self.count {
            contents += shape
        }
        //lets return the contents
        return contents;
    }
    
    //lets add the attribute to the shaded object
    func attributedContents() -> NSAttributedString {
        //since we will change this attribute lets use var
        var strokeColor : UIColor
        var foregroundColor : UIColor
        
        switch(self.color)
        {
        case .red: strokeColor = UIColor.red
        case .green: strokeColor = UIColor.green
        case .purple: strokeColor = UIColor.purple
        }
        
        foregroundColor =  strokeColor
        
        switch(self.shaded){
        case .outlined: foregroundColor =  foregroundColor.withAlphaComponent(-0.5)
        case .filled: foregroundColor.withAlphaComponent(1.0)
        case .stiped: foregroundColor = foregroundColor.withAlphaComponent(0.3)
        }//close the shading attribute case statement
        
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: strokeColor,
            .foregroundColor: foregroundColor,
            .strokeWidth: -5.0
            ]//close of attibutes
        
        //lets declare our attributed string now
         let attributedString = NSAttributedString(string: self.contents(),attributes: attributes)
        
        return attributedString;
    }//close the attributedContent func
    
    //now lets create the enumerations
    enum Shades{
        case outlined
        case stiped
        case filled
      static let all = [outlined,stiped,filled]
    }
    
    enum Colors{
        case red
        case green
        case purple
        static let all = [purple,green,red]
    }
    
    enum Shapes{
    case oval
    case diamond
    case custom
    static let all = [oval,diamond,custom]
    }

    init(shape: Shapes, color: Colors, shaded: Shades, count: Int)
    {
        self.color = color
        self.shape = shape
        self.shaded = shaded
        self.count = count
    }
    
    
}
