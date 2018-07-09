//
//  BaseModel.swift
//  ReactiveSwiftDemo
//
//  Created by jktz on 2018/7/6.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class BaseModel: NSObject {

    let signal:Signal<Int,NoError>
    let innerObserver:Signal<Int,NoError>.Observer
    
    override init() {
        (signal,innerObserver) = Signal<Int,NoError>.pipe()
    }
    
    func bind(model:userInfoModel) -> Void {
        
        
    }
}


class userInfoModel {
    
    
}
