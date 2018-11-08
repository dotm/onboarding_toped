//
//  RangeSlider.swift
//  TokopediaUI
//
//  Created by Ridho Pratama on 12/03/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit

public class RangeSlider: UIControl {
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbLayer = ThumbLayer()
    private let upperThumbLayer = ThumbLayer()
    var previousLocation = CGPoint()
    
    public var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var lowerValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var upperValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var stepValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var trackTintColor: UIColor = UIColor.black.withAlphaComponent(0.2) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var trackHightlightTintColor: UIColor = .tpGreen {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    public override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    public init(minimumValue: Double, maximumValue: Double, lowerValue: Double, upperValue: Double, stepValue: Double) {
        super.init(frame: .zero)
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.lowerValue = lowerValue
        self.upperValue = upperValue
        self.stepValue = stepValue
        
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func draw(_ rect: CGRect) {
        updateLayerFrames()
        addTickMarkersAboveSlider()
    }
    
    private func commonInit() {
        trackLayer.slider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
    }
    
    private func addTickMarkersAboveSlider() {
        let markersView = UIView(frame: CGRect.init(x: 0,
                                                    y: -25,
                                                    width: self.frame.size.width,
                                                    height: self.frame.size.height))
        markersView.backgroundColor = UIColor.clear
        
        for index in 0...Int(maximumValue) {
            let indexPosition = CGFloat(positionForValue(value: Double(index)))
            let marker = UIView(frame: CGRect.init(x: indexPosition,
                                                   y: (self.frame.size.height - 10.0) / 2,
                                                   width: 1, height: 10))
            
            marker.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            markersView.insertSubview(marker, belowSubview: self)
        }
        
        self.insertSubview(markersView, at: 0)
    }
    
    private func updateLayerFrames() {
        self.backgroundColor = UIColor.white
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    public func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    public func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        var deltaValue = ((maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height))
        
        if abs(deltaValue) < stepValue {
            return true
        }
        
        if stepValue != 0 {
            deltaValue = deltaValue < 0 ? -stepValue : stepValue
        }
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
}

fileprivate class RangeSliderTrackLayer: CALayer {
    fileprivate weak var slider: RangeSlider?
    
    fileprivate override func draw(in ctx: CGContext) {
        guard let slider = self.slider else { return }
        
        let cornerRadius = bounds.width / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHightlightTintColor.cgColor)
        let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
        let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
        let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        ctx.fill(rect)
    }
}
