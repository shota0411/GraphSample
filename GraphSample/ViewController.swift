//
//  ViewController.swift
//  GraphSample
//
//  Created by 鶴本賢太朗 on 2018/03/23.
//  Copyright © 2018年 松田翔大. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBarGraph()
    }
    
    func drawBarGraph() {
        // グラフにしたい配列
        let bars = BarStroke(graphPoints: [nil, 100, 300, 100, 400, 900, 1200, 400, 1600])
        bars.color = UIColor.blue
        
        let barFrame = LineStrokeGraphFrame(strokes: [bars])
        
        let barGraphView = UIView(frame: CGRect(x: 0, y: 240, width: view.frame.width, height: 200))
        barGraphView.backgroundColor = UIColor.lightGray
        barGraphView.addSubview(barFrame)
        
        view.addSubview(barGraphView)
    }
    
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
        return view.frame.width/CGFloat(xAxisPointsCount)
    }
}

class LineStrokeGraphFrame: UIView, GraphFrame {
    var strokes = [GraphStroke]()

    convenience init(strokes: [GraphStroke]) {
        self.init()
        self.strokes = strokes
    }

    override func didMoveToSuperview() {
        if self.superview == nil { return }
        self.frame.size = self.superview!.frame.size
        self.view.backgroundColor = UIColor.clear

        strokeLines()
    }

    func strokeLines() {
        for stroke in strokes {
            self.addSubview(stroke as! UIView)
        }
    }

    override func draw(_ rect: CGRect) {
        drawTopLine()
        drawBottomLine()
        drawVerticalLines()
    }

    func drawTopLine() {
        self.drawLine(
            from: CGPoint(x: 0, y: frame.height),
            to: CGPoint(x: frame.width, y: frame.height)
        )
    }

    func drawBottomLine() {
        self.drawLine(
            from: CGPoint(x: 0, y: 0),
            to: CGPoint(x: frame.width, y: 0)
        )
    }

    func drawVerticalLines() {
        for i in 1..<xAxisPointsCount {
            let x = xAxisMargin*CGFloat(i)
            self.drawLine(
                from: CGPoint(x: x, y: 0),
                to: CGPoint(x: x, y: frame.height)
            )
        }
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
        return CGFloat(index) * xAxisMargin
    }
    
    // 値からY座標を取る
    func getYPoint(yOrigin: CGFloat) -> CGFloat {
        let y: CGFloat = yOrigin/yAxisMax * graphHeight
        return graphHeight - y
    }
}


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

class BarStroke: UIView, GraphStroke {
    var graphPoints = [CGFloat?]()
    var color = UIColor.white
    // グラフの上に表示したい文字列の配列
    let text: [String] = ["test", "test", "test", "test", "test", "test", "test", "test", "text"]
    
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
        for graphPoint in graphPoints.enumerated() {
            let graphPath = UIBezierPath()
            let label = UILabel()
            let button = UIButton()
            button.tag = graphPoint.offset
            button.addTarget(self, action: #selector(self.tapGraph), for: .touchUpInside)
            let xPoint = getXPoint(index: graphPoint.offset)
            graphPath.move(
                to: CGPoint(x: xPoint, y: getYPoint(yOrigin: 0))
            )
            
            if graphPoint.element == nil { continue }
            let nextPoint = CGPoint(x: xPoint, y: getYPoint(yOrigin: graphPoint.element!) + 10)
            graphPath.addLine(to: nextPoint)
            
            // labelにテキストを入れて表示
            label.text = self.text[graphPoint.offset]
            self.view.addSubview(label)
            label.frame = CGRect(x: xPoint - 15, y: (getYPoint(yOrigin: graphPoint.element!) - 10), width: 30, height: 20)
            
            // グラフと同じ位置に透明なbuttonを設置
            button.backgroundColor = UIColor.red //test
            self.view.addSubview(button)
            button.frame = CGRect(x: xPoint - 15, y: getYPoint(yOrigin: graphPoint.element!) + 10, width: 30, height: self.view.frame.height - (getYPoint(yOrigin: graphPoint.element!) + 10))
            
            graphPath.lineWidth = 30
            color.setStroke()
            graphPath.stroke()
            graphPath.close()
        }
    }
    
    @objc func tapGraph() {
    
    }
}
