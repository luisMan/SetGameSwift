//
//  SetCardView.swift
//  luismanon
//
//  Created by Luis Manon on 10/31/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

@IBDesignable class SetCardView: UIView {
    var path = UIBezierPath()
    var cardToDraw: ModelCards!
    var color : UIColor!
    //this is the number of cards am going to be draw in this case this may be the object counter of specific card shapes
    @IBInspectable var numberOfCard: Int =  12 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var quantity: Int =  2 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    //this variable will keep track of my card on face up or down but on our selection is removed or shown
    @IBInspectable var isFaceUp: Bool =  true {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    //this inspectable var is to draw specific shape on the View default one is circle
    @IBInspectable var type: String = "circle" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    //set the card object
     func setObjectCardToRender(card: ModelCards){
        self.cardToDraw =  card
        switch(cardToDraw.color)
        {
        case .green:
            color = UIColor.green
        case .red:
            color = UIColor.red
        case .purple:
            color = UIColor.purple
        }
        
    }
    
    
    
    //the frontView Scale of our card
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    //now since we are working with the set game am going to show the curner string of each cards
    private var cornerString: NSAttributedString {
        return centeredAttributedString(counterString+rankString, fontSize: cornerFontSize)
    }
    
    //now lets declare the centeredAtributedString function to make this top string possible
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        
        //lets declare our fonts
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        //now lets scale the font base on font metrics on our project
        font =  UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        //add the style to out text so we can show nice text on our grid view when render
        let textStyle =  NSMutableParagraphStyle()
        textStyle.alignment = .left
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle: textStyle,.font: font])
    }//end of function
    
    
    
    //lets override this function so we change the text size on screen base on user trait collection preferences
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    
    
    
    //now lets create a function for the upper left corner of our view lol that we we show the user the type of shape and counter for the number of items shown
    private lazy var upperLeftCornerLabel = createCornerLabel()
    
    private lazy var lowerRightCornelLabel =
        createCornerLabel()
   
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        
        label.numberOfLines = 0
        addSubview(label)
        
        return label
    }

    //func to configure the corner labels
    private func configurecornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    
    //since we are extending a view this type of object  in swift contain an override function name layoutsubviews because each view has a bunch of subviews on it then lets create this function
    override func layoutSubviews() {
        super .layoutSubviews()
        //lets configure this subview now
        //for the upper label lol
        configurecornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin =  bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        //lets work with the low right text lol
        
    }
    
    
    //adjust the card size base on scale lol
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    //=====================================================================Draw a stiped diamond ===================================
    private func drawFillDiamond() -> UIBezierPath
    {
         let FillDiamond = UIBezierPath()
        //lets use our extension offsetBy wich is a CGPoint
        FillDiamond.move(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/4, dy: self.frame.height/2))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height - (self.frame.height/4)))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width-(self.frame.width/4), dy: self.frame.height/2))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
        
        FillDiamond.lineWidth = 3.0
        color.setFill()
        FillDiamond.fill()
        
   
        
        FillDiamond.close()
        return FillDiamond
    }
    
    //====================================end of a fill diamond object==================================
    //=====================================================================Draw a empty diamond ===================================
    private func drawEmptyDiamond() -> UIBezierPath
    {
        let EmptyDiamong = UIBezierPath()
        //lets use our extension offsetBy wich is a CGPoint
        EmptyDiamong.move(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
        EmptyDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/4, dy: self.frame.height/2))
        EmptyDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height - (self.frame.height/4)))
        EmptyDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width-(self.frame.width/4), dy: self.frame.height/2))
        EmptyDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
      
        EmptyDiamong.lineWidth = 3.0
        
        
        // Specify a border (stroke) color.
        color.setStroke()
        EmptyDiamong.stroke()
        
        EmptyDiamong.close()
        
        return EmptyDiamong
    }
    
    //====================================end of a fill diamond object==================================
    //====================================Draw striped diamong ========================================
    private func StipedDiamond() ->  UIBezierPath{
        
        let StipeDiamong = UIBezierPath()
        StipeDiamong.addClip()
        
        StipeDiamong.move(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
        StipeDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/4, dy: self.frame.height/2))
        StipeDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height - (self.frame.height/4)))
        StipeDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width-(self.frame.width/4), dy: self.frame.height/2))
        StipeDiamong.addLine(to: bounds.origin.offsetBy(dx: self.frame.width/2, dy: self.frame.height/4))
        
      
        StipeDiamong.lineWidth = 3.0
        color.setStroke()
        StipeDiamong.stroke()
        
        StipeDiamong.close()
        
        return StipeDiamong
        
    }
    //=====================================================end of Stiped Diamong shape frame ==============================================//
    func addLineToFrame(path: UIBezierPath) -> UIBezierPath
    {
        let lines = UIBezierPath()
        lines.append(path);
        
        lines.addClip()
        var height =  self.frame.height/4
        
        for _ in 0...15 {
            lines.move(to: bounds.origin.offsetBy(dx: self.frame.width/4, dy: height))
            lines.addLine(to: bounds.origin.offsetBy(dx: self.frame.width - (self.frame.width/4), dy: height))
            height =  height + 20.0;
        }
        
        lines.lineWidth = 3.0
        color.setStroke()
        lines.stroke()
        
        return lines;
    }
    
    //now lets draw into this nice function lol
    //please note the draw function is not a thread it only knows how to draw not animate lol
    //we can easyly change this type of animation later on but for this game am just going to draw a single view
    override func draw(_ rect: CGRect){
        //lets remove all the bezier path so we can draw the shape on screen rotation
        path.removeAllPoints()
        
        //ui bezier path is a object from swift that knows hw to draw to views and can remember a previous path :-)
        let roundedRect =  UIBezierPath(roundedRect: bounds, cornerRadius:cornerRadius)
        
        //this function clip just the same way a focus point clip to draw on a 3D space base on camera view point
       // roundedRect.addClip()
        //lets set the color to fill this rectangle with
        UIColor.white.setFill()
        
        //now lets fill it
        roundedRect.fill()
        
        //lets check if is not deleted from view
        if isFaceUp {
            switch(cardToDraw.shape){
            case .circle:
                      switch(cardToDraw.shaded)
                      {
                      case .filled:
                           path.append(drawFillDiamond())
                      case .stiped:
                        path.append(addLineToFrame(path: StipedDiamond()))
                      case .outlined:
                        path.append(drawEmptyDiamond())
                       }
            case .square:
                switch(cardToDraw.shaded)
                {
                case .filled:
                    path.append(drawFillDiamond())
                case .stiped:
                    path.append(addLineToFrame(path: StipedDiamond()))
                case .outlined:
                    path.append(drawEmptyDiamond())
                }
            case .triangle:
                switch(cardToDraw.shaded)
                {
                case .filled:
                    path.append(drawFillDiamond())
                case .stiped:
                    path.append(addLineToFrame(path: StipedDiamond()))
                case .outlined:
                    path.append(drawEmptyDiamond())
                }
            }
        }
        
    }
    
    private func drawPips() {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(type, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(type, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(type, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(numberOfCard) {
            let pipsPerRow = pipsPerRowForRank[numberOfCard]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch numberOfCard {
        case 1: return "D"
        case 2: return "S"
        case 3: return "O"
        case 4: return "DE"
        case 5: return "SE"
        case 6: return "OE"
        case 7: return "DF"
        case 8: return "SF"
        case 9: return  "OF"
        case 10: return "DS"
        case 11: return "SS"
        case 12: return "OS"
        default: return "?"
        }
    }
    private var counterString: String {
        switch quantity {
        case 1: return "1"
        case 2: return "2"
        case 3: return "3"
        default: return "?"
        }
    }
}

//our extension function to override cgpoint lol
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

//extension function to draw rect for frams on view or any other type of object
extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}




