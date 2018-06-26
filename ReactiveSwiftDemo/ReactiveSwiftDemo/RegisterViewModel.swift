//
//  RegisterViewModel.swift
//  ReactiveSwiftDemo
//
//  Created by jktz on 2018/6/26.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result


private let InvalidAccount = "手机号格式不正确"
private let InvalidPassword = "密码格式不正确"
private let InvalidVerifyCode = "验证码格式不正确"


//MARK:Interface
protocol RegisterViewModelProtocol {
    
    func setInput(accountInput:Signal<String?,NoError>,passwordInput:Signal<String?,NoError>,ensurePasswordInput:Signal<String?,NoError>,verifyCodeInput:Signal<String?,NoError>)
    
    
    //获取账号
    var validAccount:MutableProperty<String>{get}
    //获取密码
    var validPassword:MutableProperty<String>{get}
    //获取确认密码
    var validEnsurePassword:MutableProperty<String>{get}
    //获取验证码
    var validVerifyCode:MutableProperty<String>{get}
    //错误信息
    var errorText:MutableProperty<String>{get}
    //验证码输入框
    var verifyCodeText:MutableProperty<String>{get}
    
    //获取验证码按钮方法
    var getVerifyCodeAction:Action<Any?, Any?, NoError>{get}
    //提交按钮的方法
    var submitAction:Action<Any?, Any?, NoError>{get}
    
}

extension RegisterViewModel:RegisterViewModelProtocol{}

class RegisterViewModel {

    private(set) var validAccount = MutableProperty("")
    private(set) var validPassword = MutableProperty("")
    private(set) var validEnsurePassword = MutableProperty("")
    private(set) var validVerifyCode = MutableProperty("")
    
    private var erors = (account:InvalidAccount,password:InvalidPassword,verifyCode:InvalidVerifyCode)
    private(set) var errorText = MutableProperty("")
    
    private var timer:Timer?
    private var time = MutableProperty(60)
    
    private(set) var verifyCodeText = MutableProperty("验证码")
    
    //获取验证码按钮事件
    private(set) lazy var getVerifyCodeAction = Action<Any?, Any?, NoError>(enabledIf: self.enableGetVerifyCode) { [unowned self] _ -> SignalProducer<Any?, NoError> in
        return self.getVerifyCodeProducer
    }
    
    //提交按钮事件
    private(set) lazy var submitAction: Action<Any?, Any?, NoError> = Action<Any?, Any?, NoError>(enabledIf:  self.enableSubmit) { [unowned self] _ -> SignalProducer<Any?, NoError> in
        return self.submitProducer
    }
    
    
    deinit {
        timer?.invalidate()
    }
    
    
    func setInput(accountInput: Signal<String?, NoError>, passwordInput: Signal<String?, NoError>, ensurePasswordInput: Signal<String?, NoError>, verifyCodeInput: Signal<String?, NoError>) {
        
        validAccount <~ accountInput.map({[weak self] text in
            
            let account = text?.substring(to: 11)
            self?.erors.account = !(account?.isValidPhoneNum)! ? InvalidAccount : ""
            return account!
        })
        
        
        validPassword <~ passwordInput.map({[weak self] password in
            
            let password = password?.substring(to: 16)
            let isValidPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,16}$")
            self?.erors.password = !isValidPassword.evaluate(with: password) ? InvalidPassword : ""
            return password!
        })
        
        validEnsurePassword <~ ensurePasswordInput.map({
            
            return ($0 )!.substring(to: 16)
        })
        
        
        validVerifyCode <~ verifyCodeInput.map({[weak self] text in
            
            let verifyCode=text?.substring(to: 6)
            let isValidVerifyCode = NSPredicate(format: "SELF MATCHES %@", "\\w+")
            self?.erors.verifyCode = !isValidVerifyCode.evaluate(with: verifyCode) ? InvalidVerifyCode : ""
            return verifyCode!
        })
    }
    
    
    @objc private func timeDown(){
        
        if self.time.value>0{
            
            self.verifyCodeText.value=String(self.time.value)+"s"
        }else{
            
            timer?.invalidate()
            verifyCodeText.value="验证码"
        }
        self.time.value-=1
    }
    
    
    private var getVerifyCodeProducer:SignalProducer<Any?,NoError>{
        
        return UserAPIManager.sharedInstance.getVerifyCodess(phoneNumber: "").on(value:{ response in
            
            print("失败")
            self.timer?.invalidate()
            self.time.value=60
            self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeDown), userInfo: nil, repeats: true)
        })
    }
    
    private var enableSubmit: Property<Bool> {
        return Property.combineLatest(validAccount, validPassword, validEnsurePassword, validVerifyCode).map({ [unowned self] (account, password, ensurePassword, verifyCode) -> Bool in
            
            if self.erors.account.count > 0 {
                
                self.errorText.value = self.erors.account
                
            } else if self.erors.password.count > 0 {
                
                self.errorText.value = self.erors.password
                
            } else if password != ensurePassword  {
                
                self.errorText.value = "两次输入的密码不一致"
                
            } else if self.erors.verifyCode.count > 0 {
                
                self.errorText.value = self.erors.verifyCode
                
            } else {
                
                self.errorText.value = ""
                
            }
            
            return self.errorText.value.count == 0
        })
    }
    
    private var submitProducer:SignalProducer<Any?, NoError>{
        
        
        
        return UserAPIManager.sharedInstance.getVerifyCodess1(phoneNumber: "").on(value:{ response in
            
        })
    }
    
    private var enableGetVerifyCode:Property<Bool>{
        
        return Property.combineLatest(time,errorText).map({(time, error) -> Bool in
            
            return error != InvalidAccount && (time <= 0 || time >= 60)
        })
    }
    
}

