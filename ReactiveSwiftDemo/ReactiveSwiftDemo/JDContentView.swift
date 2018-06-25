//
//  JDContentView.swift
//  ReactiveSwiftDemo
//
//  Created by ZMJ on 2018/6/25.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
class JDContentView: UIView {
    
 let (signalTap , observerTap) = Signal<Any, NoError>.pipe()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

extension JDContentView{
    
    fileprivate func setUI() {
        backgroundColor = UIColor.orange
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapClick(_:)))
        addGestureRecognizer(tap)
    }
    
    //使用RAC，替代delegate，闭包
    @objc fileprivate func tapClick(_ tap : UITapGestureRecognizer) {
        observerTap.send(value: tap)
    }
}
