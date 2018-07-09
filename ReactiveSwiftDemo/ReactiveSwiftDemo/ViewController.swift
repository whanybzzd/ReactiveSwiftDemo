//
//  ViewController.swift
//  ReactiveSwiftDemo
//
//  Created by ZMJ on 2018/6/25.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import Result
class ViewController: UIViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var accountTF: UITextField!//账号输入框
    @IBOutlet weak var passwordTF: UITextField!//密码输入框
    @IBOutlet weak var ensurePasswordTF: UITextField!//确认密码输入框
    @IBOutlet weak var verifyCodeTF: UITextField!//验证码输入框
    @IBOutlet weak var verifyCodeButton: UIButton!//获取验证码按钮
    @IBOutlet weak var errorLabel: UILabel!//错误描述Label
    @IBOutlet weak var submitButton: UIButton!//提交注册按钮
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        //代替delegate
        contentView.signalTap.observeValues {[weak self] (contentView) in

            print("点击")
            self?.click()

        }
        //当文本框输入的值大于3后才输出
//        contentView.userNameText.reactive.continuousTextValues.filter { (text) -> Bool in
//
//            return (text?.count)! > 3
//            }.observeValues { (value) in
//
//                print("value:\(value!)")
//        }
        
        
        
        contentView.userNameText.reactive.continuousTextValues
            .map{(text)->Int in
                
                return (text?.count)!
            }.map{(length)->UIColor in
                
                return length>5 ? UIColor.blue : UIColor.lightGray
            }.observeValues {[weak self] (color) in
                
                self?.contentView.userNameText.textColor=color
        }
        
        
        
        
        
        
        viewModel = RegisterViewModel()
    }
    
    var viewModel:RegisterViewModelProtocol!{
        didSet{
            
           self.viewModel.setInput(accountInput: accountTF.reactive.continuousTextValues, passwordInput: passwordTF.reactive.continuousTextValues, ensurePasswordInput: ensurePasswordTF.reactive.continuousTextValues, verifyCodeInput: verifyCodeTF.reactive.continuousTextValues)
            
            
            accountTF.reactive.text <~ viewModel.validAccount
            
            passwordTF.reactive.text <~ viewModel.validPassword
            
            ensurePasswordTF.reactive.text <~ viewModel.validEnsurePassword
            
            errorLabel.reactive.text <~ viewModel.errorText.signal.skip(first: 1)
            
            verifyCodeTF.reactive.text <~ viewModel.validVerifyCode
            
            verifyCodeButton.reactive.title <~ viewModel.verifyCodeText
            
            //增加背景颜色的判断
            verifyCodeButton.reactive.backgroundColor <~ viewModel.validAccount.map({[weak self]_ in
                
                self?.viewModel.verifyCodeButtonColor.value.count == 0 ? UIColor.red : UIColor.lightGray
            })
            verifyCodeButton.reactive.pressed = ButtonAction(viewModel.getVerifyCodeAction)
           
            
           
            viewModel.getVerifyCodeAction.errors.observeValues { (error) in
                print("错误1:\(error)")
            }
            
            submitButton.reactive.pressed = ButtonAction(viewModel.submitAction)
            
            //增加背景颜色的判断
            submitButton.reactive.backgroundColor <~ viewModel.errorText.map({
                
                $0.count == 0 ? UIColor.red : UIColor.lightGray
            })
            viewModel.submitAction.errors.observeValues { (error) in
                
                 print("错误2:\(error)")
            }
            viewModel.submitAction.values.observeValues { (value) in
                
               print("注册成功")
            }
            
        }
        
    }

    
    
    
    
    lazy var contentView:JDContentView = {
        
        let view=JDContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        return view
        
    }()
    
    func click() -> Void {
        
        //take
        let (signal,observer)=Signal<String,NoError>.pipe()
        let (takeSignal,takeOberver)=Signal<(),NoError>.pipe()
        signal.on(value:{ value in

            print("value:\(value)")

        }).observeValues { (value) in

            print("value2:\(value)")
        }
        signal.take(until: takeSignal).observeValues { (value) in

            print("value3:\(value)")
        }
        observer.send(value: "1")
        observer.sendCompleted()


        takeOberver.send(value: ())
        takeOberver.sendCompleted()
        
        
        //first last
        let (signal1,innerObserver)=Signal<String,NoError>.pipe()
        signal1.take(first: 2).observeValues { (value) in
            
            print("first:\(value)")
        }
        
        //包含2
        signal1.take(last: 2).observeValues { (value) in
            
            print("last:\(value)")
        }
        innerObserver.send(value: "1")
        innerObserver.send(value: "2")
        innerObserver.send(value: "3")
        innerObserver.sendCompleted()
        
        //merge合并成为一个新的信号
        let (mergeSignal,mergeObserver)=Signal<NSString,NoError>.pipe()
        let (mergeSignal1,mergeOberver1)=Signal<NSString,NoError>.pipe()
        
        Signal.merge(mergeSignal,mergeSignal1).observeValues { (value) in
            
            print("merge:\(value)")
        }
        
        //把多个信号组合成一个新的信号
        Signal.combineLatest(mergeSignal,mergeSignal1).observeValues { (value,value1) in
            
            print("组合成新的信号:\(value)==\(value1)")
        }
        
        //zip 拉链式的组合
        Signal.zip(mergeSignal,mergeSignal1).observeValues { (value,value1) in
            
            print("拉链式的组合:\(value)===\(value1)")
        }
        mergeObserver.send(value: "111")
        mergeObserver.sendCompleted()
        mergeOberver1.send(value: "222")
        mergeOberver1.sendCompleted()
        
        
        self.view.reactive.producer(forKeyPath: "bounds").start { (rect) in
            
            print(self.view)
        }
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name(""), object: nil).observeValues { (noti) in
            
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(""), object: nil)
        
        
        //let viewModel:BaseModel=BaseModel()
        //viewModel.innerObserver.send(value: 1)
        
        let lab=UILabel()
        lab.reactive.text <~ viewModel.errorText
        
        
        let barButton=UIBarButtonItem()
        barButton.reactive.pressed=BarButtonAction(viewModel.submitAction)
        
        let barItem=UIBarItem()
        barItem.reactive.image <~ viewModel.validAccount.map({_ in
            
            UIImage.init(named: "")
        })
        
        
        let navigation=UINavigationItem(title: "我爱你")
        navigation.reactive.leftBarButtonItem <~ viewModel.validAccount.map({_ in
            
            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        })
        
        navigation.reactive.rightBarButtonItem <~ viewModel.validAccount.map({_ in
            
            UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        })
        
        
        let progress=UIProgressView(progressViewStyle: .default)
        progress.reactive.progress <~ viewModel.validAccount.map({ text in
            
            let pro=Float(text)!
           return pro/2.00
        })
        
        
        let searchBar=UISearchBar()
        searchBar.delegate=self
        searchBar.reactive.searchButtonClicked.observeValues { (search) in
            
            
        }
        searchBar.reactive.selectedScopeButtonIndex <~ viewModel.errorText.map({_ in
            
            2
        })
        
        searchBar.reactive.isHidden <~ viewModel.errorText.map({_ in
            
             true
        })
        
        
        
    }
}

