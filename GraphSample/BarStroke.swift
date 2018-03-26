//
//  BarStroke.swift
//  GraphSample
//
//  Created by 松田翔大 on 2018/03/26.
//  Copyright © 2018年 松田翔大. All rights reserved.
//

import UIKit

class BarStroke: UIView, GraphStroke {
    var graphPoints = [CGFloat?]()
    var color = UIColor.white
    // グラフの上に表示したい文字列の配列
    let text: [String] = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月"]
    var graphButton = [UIButton]()
    var graphLabel = [UILabel]()
    
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
            label.text = self.text[graphPoint.offset - 1]
            label.textAlignment = .center
            self.view.addSubview(label)
            label.frame = CGRect(x: xPoint - 15, y: (getYPoint(yOrigin: graphPoint.element!) - 10), width: 30, height: 20)
            self.graphLabel.append(label)
            
            
            // グラフと同じ位置に透明なbuttonを設置
            button.backgroundColor = UIColor.clear
            self.view.addSubview(button)
            button.frame = CGRect(x: xPoint - 15, y: getYPoint(yOrigin: graphPoint.element!) + 10, width: 30, height: self.view.frame.height - (getYPoint(yOrigin: graphPoint.element!) + 10))
            
            self.graphButton.append(button)
            
            graphPath.lineWidth = 30
            color.setStroke()
            graphPath.stroke()
            graphPath.close()
        }
    }
    
    @IBAction func tapGraph(_ sender: UIButton) {
        // グラフの色をリセット
        for button in graphButton {
            button.backgroundColor = UIColor.clear
        }
        // labelの値をリセット
        for label in graphLabel {
            label.text = self.text[graphLabel.index(of: label)!]
        }
        // タップしたグラフのハイライトの色
        sender.backgroundColor = UIColor.black
        // タップした
        self.graphLabel[sender.tag - 1].text = "▼"
        self.graphLabel[sender.tag - 1].textAlignment = .center
    }
}
