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
import SnapKit
class JDContentView: UIView {
    var updateConstraint:Constraint?
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
            
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        let testView2=UIView()
        testView2.backgroundColor=UIColor.black
        self.addSubview(testView2)
        testView2.snp.makeConstraints { (make) in
            
            //make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        
            //make.top.equalTo(testView.snp.bottom).offset(10)
            //make.width.height.greaterThanOrEqualTo(testView)
            //make.width.height.equalTo(100)
            make.size.equalTo(CGSize(width: 200, height: 200))
            //make.centerX.lessThanOrEqualTo(testView.snp.leading)
           // make.left.equalTo(testView.snp.left)
            self.updateConstraint=make.left.top.equalTo(10).constraint
        }
        
        let updateButton = UIButton(type: .custom)
        updateButton.backgroundColor = UIColor.brown
        updateButton.frame = CGRect(x: 100, y: 80, width: 50, height: 30)
        updateButton.setTitle("更新", for: .normal)
        updateButton.addTarget(self, action: #selector(updateConstraintMethod), for: .touchUpInside)
        self.addSubview(updateButton)
        
    }
    // 更新约束
    @objc func updateConstraintMethod() {
        
        self.updateConstraint?.update(offset: 50)   // 更新距离父视图上、左为50
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
