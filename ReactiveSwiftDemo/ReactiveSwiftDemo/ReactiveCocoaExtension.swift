//
//  ReactiveCocoaExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/27.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift


typealias ButtonAction = ReactiveCocoa.CocoaAction<UIButton>

extension SignalProducer where Error == NoError {
    
    @discardableResult
    func startWithValues(_ action: @escaping (Value) -> Void) -> Disposable {
        return start(Signal.Observer(value: action))
    }
}

extension CocoaAction {
    
    public convenience init<Output, Error>(_ action: Action<Any?, Output, Error>) {
        self.init(action, input: nil)
    }
}
