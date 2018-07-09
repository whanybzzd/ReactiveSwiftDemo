//
//  ViewController.swift
//  ReactiveSwiftDemo
//
//  Created by ZMJ on 2018/6/25.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift


typealias ButtonAction = ReactiveCocoa.CocoaAction<UIButton>
typealias BarButtonAction = ReactiveCocoa.CocoaAction<UIBarButtonItem>

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
