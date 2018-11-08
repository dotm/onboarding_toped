//
//  Slider.swift
//  TokopediaUI
//
//  Created by Ridho Pratama on 13/03/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit

public class Slider: UIControl {
    private let trackLayer = SliderTrackLayer()
    private let thumbLayer = ThumbLayer()
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
    
    public var value: Double = 0.0 {
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
            thumbLayer.setNeedsDisplay()
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
    
    public init(minimumValue: Double, maximumValue: Double, value: Double, stepValue: Double) {
        super.init(frame: .zero)
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.value = value
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
    
    private func commonInit() {
        trackLayer.slider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        thumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(thumbLayer)
    }
    
    public override func draw(_ rect: CGRect) {
        updateLayerFrames()
        addTickMarkersAboveSlider()
    }
    
    public func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    public func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    private func updateLayerFrames() {
        self.backgroundColor = UIColor.white
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let thumbCenter = CGFloat(positionForValue(value: value))
        
        thumbLayer.frame = CGRect(x: thumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        thumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
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
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if thumbLayer.frame.contains(previousLocation) {
            thumbLayer.highlighted = true
        }
        
        return thumbLayer.highlighted
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
        if thumbLayer.highlighted {
            value += deltaValue
            value = boundValue(value: value, toLowerValue: minimumValue, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbLayer.highlighted = false
    }
}

fileprivate class SliderTrackLayer: CALayer {
    fileprivate weak var slider: Slider?
    
    fileprivate override func draw(in ctx: CGContext) {
        guard let slider = self.slider else { return }
        
        let cornerRadius = bounds.width / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        ctx.beginPath()
        ctx.addPath(path.cgPath)
        ctx.closePath()
        ctx.clip()

        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHightlightTintColor.cgColor)
        let valuePosition = CGFloat(slider.positionForValue(value: slider.value))
        let rect = CGRect(x: 0.0, y: 0.0, width: valuePosition, height: bounds.height)
        ctx.fill(rect)
    }
}
