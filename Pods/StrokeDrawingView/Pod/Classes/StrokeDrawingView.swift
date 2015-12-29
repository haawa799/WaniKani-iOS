//
//  StrokeDrawingView.swift
//  StrokeDrawingView
//
//  HAVE A NICE DAY!
//  ₍ᐢ•ﻌ•ᐢ₎*･ﾟ｡
//
//  Created by Andrew Kharchyshyn
//  Copyright (c) 2015 StrokeDrawingView. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import UIKit


public protocol StrokeDrawingViewDataSource: class {
  func sizeOfDrawing() -> CGSize
  func numberOfStrokes() -> Int
  func pathForIndex(index: Int) -> UIBezierPath
  func animationDurationForStroke(index: Int) -> CFTimeInterval
  func colorForStrokeAtIndex(index: Int) -> UIColor
  func colorForUnderlineStrokes() -> UIColor?
}

public protocol StrokeDrawingViewDataDelegate: class {
  func layersAreNowReadyForAnimation()
}

public class StrokeDrawingView: UIView {
  
  private let defaultMiterLimit: CGFloat = 4
  private var numberOfStrokes: Int { return dataSource?.numberOfStrokes() ?? 0 }
  private var shouldDraw = false
  private var strokeLayers = [CAShapeLayer]()
  private var backgroundLayer = BackgroundLayer()
  private var drawingSize = CGSizeZero
  private var animations = [CABasicAnimation]()
  private var timer: NSTimer?
  
  deinit {
    timer?.invalidate()
  }
  
  // MARK: - Public API
  /// Custom drawing starts afte this property is set
  public var dataSource: StrokeDrawingViewDataSource? {
    didSet {
      guard let dataSource = dataSource else {return}
      drawingSize = dataSource.sizeOfDrawing()
      shouldDraw = true
      setNeedsDisplay()
    }
  }
  
  public var delegate: StrokeDrawingViewDataDelegate?
  
  /// Use this method to run looped animation
  public func playForever(delayBeforeEach: CFTimeInterval = 0) {
    
    guard let dataSource = dataSource else {return}
    let numberOfStrokes = dataSource.numberOfStrokes()
    var animationDuration: CFTimeInterval = 0
    for i in 0..<numberOfStrokes {
      animationDuration += dataSource.animationDurationForStroke(i)
    }
    
    playSingleAnimation()
    timer = NSTimer.scheduledTimerWithTimeInterval(delayBeforeEach + animationDuration, target: self, selector: "playSingleAnimation", userInfo: nil, repeats: true)
  }
  
  /// Use this method to stop looped animation
  public func stopForeverAnimation() {
    timer?.invalidate()
    pauseLayers()
  }
  
  public func clean() {
    removeAnimationFromEachLayer()
    resetLayers()
    for layer in strokeLayers {
      layer.removeFromSuperlayer()
    }
    strokeLayers = [CAShapeLayer]()
  }
  
  /// Use this method to run single animation cycle
  public func playSingleAnimation() {
    removeAnimationFromEachLayer()
    setStrokesProgress(0)
    resetLayers()
    
    var counter = 0
    var duration: CFTimeInterval = CACurrentMediaTime()
    
    for strokeLayer in strokeLayers {
      
      let delay = duration
      let strokeAnimationDuration = dataSource?.animationDurationForStroke(counter) ?? 0
      duration += strokeAnimationDuration
      
      let anim = defaultAnimation(strokeAnimationDuration, delayTime: delay)
      strokeLayer.addAnimation(anim, forKey: "strokeEndAnimation")
      
      counter++
    }
  }
  
  /// Use this method to reset strokes layers progress to 'progress'
  /// Can be value from 0 t0 1
  public func setStrokesProgress(progress: CGFloat) {
    for strokeLayer in strokeLayers {
      strokeLayer.strokeEnd = progress
    }
  }
  
}


// MARK:
extension StrokeDrawingView {
  
  private func pauseLayers() {
    for strokeLayer in strokeLayers {
      strokeLayer.pause()
    }
  }
  
  private func resetLayers() {
    for strokeLayer in strokeLayers {
      strokeLayer.reset()
    }
  }
  
  private func removeAnimationFromEachLayer() {
    for strokeLayer in strokeLayers {
      strokeLayer.removeAllAnimations()
    }
  }
  
  private func drawIfNeeded() {
    
    if shouldDraw == true && numberOfStrokes > 0 {
      
      layer.addSublayer(backgroundLayer)
      
      for strokeIndex in 0..<numberOfStrokes {
        
        let color = dataSource?.colorForStrokeAtIndex(strokeIndex) ?? UIColor.blackColor()
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.miterLimit = defaultMiterLimit
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
        strokeLayers.append(shapeLayer)
      }
      shouldDraw = false
      delegate?.layersAreNowReadyForAnimation()
    }
  }
  
  private func defaultAnimation(duration: CFTimeInterval, delayTime: CFTimeInterval = 0, removeOnComletion: Bool = false) -> CABasicAnimation {
    let baseAnim = CABasicAnimation(keyPath: "strokeEnd")
    baseAnim.duration = duration
    baseAnim.beginTime = delayTime
    baseAnim.fromValue = 0
    baseAnim.fillMode = kCAFillModeForwards
    baseAnim.removedOnCompletion = removeOnComletion
    baseAnim.toValue = 1
    return baseAnim
  }
  
  public override func drawRect(rect: CGRect) {
    drawIfNeeded()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let dataSource = dataSource where strokeLayers.count > 0 else {return}
    
    let scale: CGFloat = bounds.height / drawingSize.height
    
    var pathes = [UIBezierPath]()
    
    for strokeIndex in 0..<numberOfStrokes {
      
      let strokeLayer = strokeLayers[strokeIndex]
      
      let path = dataSource.pathForIndex(strokeIndex)
      let pathCopy = UIBezierPath(CGPath: path.CGPath)
      pathCopy.lineWidth = path.lineWidth * scale
      pathes.append(pathCopy)
      pathCopy.applyTransform(CGAffineTransformMakeScale(scale, scale))
      
      strokeLayer.lineWidth = path.lineWidth * scale
      strokeLayer.path = pathCopy.CGPath
    }
    
    if let underlineColor = dataSource.colorForUnderlineStrokes() {
      backgroundLayer.frame = bounds
      backgroundLayer.strokeColor = underlineColor
      backgroundLayer.strokes = pathes
      backgroundLayer.setNeedsDisplay()
    }
  }
}

extension CALayer {
  
  func pause() {
    let pausedTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
    speed = 0.0
    timeOffset = pausedTime
  }
  
  func reset() {
    speed = 1.0
    timeOffset = 0.0
  }
  
  func resume() {
    let pausedTime = timeOffset
    speed = 1.0
    timeOffset = 0.0
    beginTime = 0.0
    let timeSincePause = convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
    beginTime = timeSincePause
  }
}


public func performWithDelay(delay: Double, closure: () -> Void) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}

