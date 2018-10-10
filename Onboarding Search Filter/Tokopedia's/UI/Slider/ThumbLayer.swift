//
//  ThumbLayer.swift
//  TokopediaUI
//
//  Created by Ridho Pratama on 13/03/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit

internal class ThumbLayer: CALayer {
    internal var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal override func draw(in ctx: CGContext) {
        let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let cornerRadius = thumbFrame.width / 2.0
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
        
        ctx.setStrokeColor(greenThemeColor.cgColor)
        ctx.setLineWidth(2.5)
        ctx.addPath(thumbPath.cgPath)
        ctx.strokePath()
        
        if highlighted {
            ctx.setFillColor(#colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1))
        } else {
            ctx.setFillColor(UIColor.white.cgColor)
        }
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
    }
}
