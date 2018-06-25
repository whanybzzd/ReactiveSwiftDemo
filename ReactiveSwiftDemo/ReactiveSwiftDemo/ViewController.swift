//
//  ViewController.swift
//  ReactiveSwiftDemo
//
//  Created by ZMJ on 2018/6/25.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        //代替delegate
        contentView.signalTap.observeValues { (contentView) in
            
            print("点击")
        }
    }
    
    
    lazy var contentView:JDContentView = {
        
        let view=JDContentView(frame: CGRect(x: 30, y: 200, width: 200, height: 200))
        
        return view
        
    }()
    
    
}

