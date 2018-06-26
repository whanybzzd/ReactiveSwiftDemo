//
//  UserAPIManager.swift
//  ReactiveSwiftDemo
//
//  Created by jktz on 2018/6/26.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

private let ManagerWorkRequestShareInstance=UserAPIManager()
//属性设置
class UserAPIManager {
    
    class var sharedInstance:UserAPIManager {
        
        return ManagerWorkRequestShareInstance
    }
    
    
    
}


extension UserAPIManager{
    
    func getVerifyCodess(phoneNumber: String) -> SignalProducer<Any?,NoError> {
        return SignalProducer<Any?,NoError>{ observer, disposable in
            
            
            let firstSearch = SignalProducer<(), NoError>(value: ())
            let load = firstSearch.concat(SignalProducer.empty)
            load.on(value:{
                
                self.result()
                    .start({event in
                        
                        switch event{
                            
                        case.value(let value):
                            
                            observer.send(value: value)
                            observer.sendCompleted()
                            
                        case .failed(let error):
                            observer.send(error: error)
                            
                        case .completed:
                            break
                        case .interrupted://事件被打断了
                            observer.sendInterrupted()
                        }
                    })
            }).start()
        }
    }
    func result() -> SignalProducer<Any?, NoError>  {
        
        return SignalProducer {observer,disponsable in
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    func getVerifyCodess1(phoneNumber: String) -> SignalProducer<Any?,NoError> {
        return SignalProducer<Any?,NoError>{ observer, disposable in
            
            
            let firstSearch = SignalProducer<(), NoError>(value: ())
            let load = firstSearch.concat(SignalProducer.empty)
            load.on(value:{
                
                self.result1()
                    .start({event in
                        
                        switch event{
                            
                        case.value(let value):
                            
                            observer.send(value: value)
                            observer.sendCompleted()
                            
                        case .failed(let error):
                            observer.send(error: error)
                            
                        case .completed:
                            break
                        case .interrupted://事件被打断了
                            observer.sendInterrupted()
                        }
                    })
            }).start()
        }
    }
    func result1() -> SignalProducer<Any, NoError>  {
        
        return SignalProducer {observer,disponsable in
            
            
        }
    }
}

