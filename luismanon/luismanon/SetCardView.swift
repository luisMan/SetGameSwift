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
    var isFaceDown: Bool!
    var color : UIColor!
    var UIController: ViewController!
    var enabled: Bool = true
   
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
    
    
    //this inspectable var is to draw specific shape on the View default one is circle
    @IBInspectable var type: String = "circle" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    //set the card object
    func setObjectCardToRender(card: ModelCards, uiController: ViewController){
        self.cardToDraw =  card
        self.UIController = uiController
        self.quantity = card.count
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
    
    func setCardFaceUp(flip: Bool){
        self.isFaceDown =  flip
    }
    
    
    
    //the frontView Scale of our card
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    //now since we are working with the set game am going to show the curner string of each cards
    func setIsEnabled(v: Bool)
    { enabled = v}
    func isCardEnabled() -> Bool {
        return enabled == true
    }
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
        label.isHidden = !isFaceDown
    }
    
    
    //since we are extending a view this type of object  in swift contain an override function name layoutsubviews because each view has a bunch of subviews on it then lets create this function
    override func layoutSubviews() {
        super .layoutSubviews()
        //lets configure this subview now
        //for the upper label lol
        configurecornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin =  bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        let touch = UITapGestureRecognizer(target: self,
                                           action: #selector(touchView(byHandlingGestureRecognizedBy:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(touch)
        
        
    }
    
    
    @objc func touchView(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            print("Just clicked on the view with card name ",self.cardToDraw.contents())
            UIController.toggle_buttons(sender: self)
        default:
            break
        }
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
         let outPath = UIBezierPath()
        
        //lets use our extension offsetBy wich is a CGPoint
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        for _ in 0..<cardToDraw.count {
        let FillDiamond = UIBezierPath()
        FillDiamond.move(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH+0.40)))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)))
        FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH)))
        
            FillDiamond.lineWidth = 3.0
            color.setFill()
            FillDiamond.fill()
            FillDiamond.close()
            pW = pW + 0.30
            outPath.append(FillDiamond)
        }
    
        
        return outPath
    }
    
    //====================================end of a fill diamond object==================================
    //=====================================================================Draw a empty diamond ===================================
    private func drawEmptyDiamond() -> UIBezierPath
    {
        let outPath = UIBezierPath()
        
        //lets use our extension offsetBy wich is a CGPoint
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        for _ in 0..<cardToDraw.count {
            let FillDiamond = UIBezierPath()
            FillDiamond.move(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH+0.40)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH)))
            
            FillDiamond.lineWidth = 3.0
            color.setStroke()
            FillDiamond.stroke()
            FillDiamond.close()
            pW = pW + 0.30
            outPath.append(FillDiamond)
        }
        
        return outPath
    }
    
    //====================================end of a fill diamond object==================================
    //====================================Draw striped diamong ========================================
    private func StipedDiamond() ->  UIBezierPath{
        
        let outPath = UIBezierPath()
        outPath.addClip()
        
        //lets use our extension offsetBy wich is a CGPoint
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        for _ in 0..<cardToDraw.count {
            let FillDiamond = UIBezierPath()
            FillDiamond.move(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH+0.40)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)))
            FillDiamond.addLine(to: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*(pH)))
            
            FillDiamond.lineWidth = 3.0
            color.setStroke()
            FillDiamond.stroke()
            FillDiamond.close()
            pW = pW + 0.30
            outPath.append(FillDiamond)
        }
        
        return outPath
        
    }
    //=====================================================end of Stiped Diamong shape frame ==============================================//
    func addLineToFrame(path: UIBezierPath) -> UIBezierPath
    {
        let lines = UIBezierPath()
        lines.append(path);
        
        lines.addClip()
        var height:CGFloat = 0.0
        
        for _ in 0...50 {
            lines.move(to: bounds.origin.offsetBy(dx: 0.0, dy: height))
            lines.addLine(to: bounds.origin.offsetBy(dx: self.frame.width, dy: height))
            height =  height + 20.0;
        }
        
        lines.lineWidth = 1.0
        color.setStroke()
        //UIColor.blue.setStroke()
        lines.stroke()
        
        return lines;
    }
    //================================================function to draw  a Oval ===============
    func drawFillOval() -> UIBezierPath{
        let toDraw =  UIBezierPath()
        //left angle
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            
            color.setFill()
            oval.fill()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
     return toDraw
    }
    //=====================================================end of draw fill oval=====================
    //=====================================================begind of empty oval ======================
    func drawEmptyOval() -> UIBezierPath{
        let toDraw =  UIBezierPath()
        //left angle
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
                oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
           oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                       radius: 8,
                       startAngle: leftAngleOnarc,
                       endAngle: rightAngleOnArc,
                       clockwise: true)
            
            color.setStroke()
            oval.stroke()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
        
        return toDraw
    }
    //====================================================begin of stiped oval -=================================
    func drawStipedOval() -> UIBezierPath{
        let toDraw =  UIBezierPath()
        toDraw.addClip()
        //left angle
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            
            color.setStroke()
            oval.stroke()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
        
        return toDraw
    }
    //============================================END OF STIPED OVAL= ==============================================
    //============================================BEGIN OF WEIRD SHAPE =============================================
    func drawCurveFillShape() -> UIBezierPath
    { let toDraw  = UIBezierPath()
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            //right line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
            //bottom oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
            //left line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH)))
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            
            color.setFill()
            oval.fill()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
     return toDraw
    }
    //=======================================================draw empty shape =================================
    func drawCurveEmptyShape() -> UIBezierPath
    {
        let toDraw  = UIBezierPath()
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            //right line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
            //bottom oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
            //left line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH)))
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            
            color.setStroke()
            oval.stroke()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
        
        return toDraw
    }
   
    
    //======================================================draw stiped path for Custom curve shape =============================
    func drawCurveStipedShape() -> UIBezierPath {
        let toDraw  = UIBezierPath()
        toDraw.addClip()
        var leftAngleOnarc =  CGFloat(180.0) * CGFloat.pi
        leftAngleOnarc = leftAngleOnarc / CGFloat(180.0)
        
        //right angle
        var rightAngleOnArc = CGFloat(0.0) * CGFloat.pi
        rightAngleOnArc =  rightAngleOnArc / CGFloat(180.0)
        var pW:CGFloat = 0.20
        let pH:CGFloat = 0.30
        
        
        for _ in 0..<cardToDraw.count {
            let oval =  UIBezierPath()
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            //right line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH+0.20)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH+0.20)))
            //bottom oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH+0.40)),
                        radius: 8,
                        startAngle: rightAngleOnArc,
                        endAngle: leftAngleOnarc,
                        clockwise: true)
            //left line
            oval.addCurve(to: bounds.origin.offsetBy(dx:self.frame.width*pW, dy: self.frame.height*(pH)), controlPoint1: bounds.origin.offsetBy(dx: self.frame.width*(pW-0.10), dy: self.frame.height*(pH)), controlPoint2: bounds.origin.offsetBy(dx: self.frame.width*(pW+0.10), dy: self.frame.height*(pH)))
            //top oval
            oval.addArc(withCenter: bounds.origin.offsetBy(dx: self.frame.width*pW, dy: self.frame.height*pH),
                        radius: 8,
                        startAngle: leftAngleOnarc,
                        endAngle: rightAngleOnArc,
                        clockwise: true)
            
            color.setStroke()
            oval.stroke()
            oval.close()
            pW = pW + 0.30
            toDraw.append(oval)
        }
        return toDraw
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
        //lets set the color to fill this rectangle with
        UIColor.white.setFill()
        
        //now lets fill it
        roundedRect.fill()
        
        //lets check if is not deleted from view
        if !isFaceDown {
            switch(cardToDraw.shape){
            case .diamond:
                      switch(cardToDraw.shaded)
                      {
                      case .filled:
                           path.append(drawFillDiamond())
                           numberOfCard = 7
                      case .stiped:
                        path.append(addLineToFrame(path: StipedDiamond()))
                        numberOfCard = 10
                      case .outlined:
                        path.append(drawEmptyDiamond())
                         numberOfCard = 4
                       }
            case .oval:
                switch(cardToDraw.shaded)
                {
                case .filled:
                    path.append(drawFillOval())
                     numberOfCard = 9
                case .stiped:
                    path.append(addLineToFrame(path: drawStipedOval()))
                     numberOfCard = 12
                case .outlined:
                    path.append(drawEmptyOval())
                     numberOfCard = 6
                }
            case .custom:
                switch(cardToDraw.shaded)
                {
                case .filled:
                    path.append(drawCurveFillShape())
                     numberOfCard = 8
                case .stiped:
                    path.append(addLineToFrame(path:drawCurveStipedShape()))
                     numberOfCard = 11
                case .outlined:
                    path.append(drawCurveEmptyShape())
                     numberOfCard = 5
                }
            }
        }else{
            if let cardBackImage = UIImage(named: "cardback",
                                           in: Bundle(for: self.classForCoder),
                                           compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
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
        case 2: return "C"
        case 3: return "O"
        case 4: return "DE"
        case 5: return "CE"
        case 6: return "OE"
        case 7: return "DF"
        case 8: return "CF"
        case 9: return  "OF"
        case 10: return "DS"
        case 11: return "CS"
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




