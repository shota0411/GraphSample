//
//  ViewController.swift
//  GraphSample
//
//  Created by 鶴本賢太朗 on 2018/03/23.
//  Copyright © 2018年 松田翔大. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBarGraph()
    }
    
    func drawBarGraph() {
        // graphPointにグラフにしたい配列を指定する
        let bars = BarStroke(graphPoints: [300, 1000, 300, 100, 400, 900, 1200, 400, 1600])
        bars.color = UIColor.blue
        bars.delegate = self
        
        let barFrame = LineStrokeGraphFrame(strokes: [bars])
        
        let barGraphView = UIView(frame: CGRect(x: 0, y: 240, width: view.frame.width, height: 200))
        
        barGraphView.backgroundColor = UIColor.lightGray
        barGraphView.addSubview(barFrame)
        
        view.addSubview(barGraphView)
    }
    
}

extension ViewController: BarStrokeDelegate {
    func tapGraph(_ sender: UIButton) {
        // グラフのタップイベント
        print("グラフの\(sender.tag)番目")
    }
}
