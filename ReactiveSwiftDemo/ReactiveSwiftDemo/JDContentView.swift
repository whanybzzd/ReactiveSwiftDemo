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
        self.addSubview(userNameText)
        userNameText.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(100)
            make.height.equalTo(50)
        }
        
        
        let testView=UIView()
        testView.backgroundColor=UIColor.cyan
        self.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        
        let testView2=UIView()
        testView2.backgroundColor=UIColor.black
        testView.addSubview(testView2)
        testView2.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userNameText:UITextField={
        
        let text=UITextField()
        text.backgroundColor=UIColor.white
        text.layer.borderColor=UIColor.blue.cgColor
        text.placeholder="请输入你要输的"
        text.layer.borderWidth=1.0
        text.layer.cornerRadius=25
        return text
    }()
    

    
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
