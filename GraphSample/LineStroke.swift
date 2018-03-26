//
//  LineStroke.swift
//  GraphSample
//
//  Created by 松田翔大 on 2018/03/26.
//  Copyright © 2018年 松田翔大. All rights reserved.
//

import UIKit

class LineStroke: UIView, GraphStroke {
    var graphPoints = [CGFloat?]()
    var color = UIColor.white
    
    convenience init(graphPoints: [CGFloat?]) {
        self.init()
        self.graphPoints = graphPoints
    }
    
    override func didMoveToSuperview() {
        if self.graphFrame == nil { return }
        self.frame.size = self.graphFrame!.view.frame.size
        self.view.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let graphPath = UIBezierPath()
        
        graphPath.move(
            to: CGPoint(x: getXPoint(index: 0), y: getYPoint(yOrigin: graphPoints[0] ?? 0))
        )
        
        for graphPoint in graphPoints.enumerated() {
            if graphPoint.element == nil { continue }
            let nextPoint = CGPoint(x: getXPoint(index: graphPoint.offset),
                                    y: getYPoint(yOrigin: graphPoint.element!))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.lineWidth = 5.0
        color.setStroke()
        graphPath.stroke()
        graphPath.close()
    }
}

