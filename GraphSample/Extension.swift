//
//  Extension.swift
//  GraphSample
//
//  Created by 松田翔大 on 2018/03/26.
//  Copyright © 2018年 松田翔大. All rights reserved.
//

import UIKit

class Extension: NSObject {
    
}

protocol GraphObject {
    var view: UIView { get }
}

extension GraphObject {
    var view: UIView {
        return self as! UIView
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        let linePath = UIBezierPath()
        
        linePath.move(to: from)
        linePath.addLine(to: to)
        
        linePath.lineWidth = 0.5
        
        let color = UIColor.white
        color.setStroke()
        linePath.stroke()
        linePath.close()
    }
}

protocol GraphFrame: GraphObject {
    var strokes: [GraphStroke] { get }
}

extension GraphFrame {
    // 保持しているstrokesの中で最大値
    var yAxisMax: CGFloat {
        return strokes.map{ $0.graphPoints }.flatMap{ $0 }.flatMap{ $0 }.max()!
    }
    
    // 保持しているstrokesの中でいちばん長い配列の長さ
    var xAxisPointsCount: Int {
        return strokes.map{ $0.graphPoints.count }.max()!
    }
    
    // X軸の点と点の幅
    var xAxisMargin: CGFloat {
        return (view.frame.width - 10) / CGFloat(xAxisPointsCount)
    }
}



protocol GraphStroke: GraphObject {
    var graphPoints: [CGFloat?] { get }
}

extension GraphStroke {
    var graphFrame: GraphFrame? {
        return ((self as! UIView).superview as? GraphFrame)
    }
    
    var graphHeight: CGFloat {
        return view.frame.height
    }
    
    var xAxisMargin: CGFloat {
        return graphFrame!.xAxisMargin
    }
    
    var yAxisMax: CGFloat {
        return graphFrame!.yAxisMax
    }
    
    // indexからX座標を取る
    func getXPoint(index: Int) -> CGFloat {
        return CGFloat(index) * xAxisMargin + 25
    }
    
    // 値からY座標を取る
    func getYPoint(yOrigin: CGFloat) -> CGFloat {
        let y: CGFloat = yOrigin/yAxisMax * graphHeight
        return graphHeight - y
    }
}

