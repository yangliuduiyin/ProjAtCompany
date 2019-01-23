//
//  ViewController.swift
//  YinRxSwiftDemo
//
//  Created by admin-3k on 2018/12/17.
//  Copyright © 2018年 admin-3k. All rights reserved.
// RxSwift的简单使用.

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameTipLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordTipLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTipLabel.text = .userNameValidTip
        userNameTipLabel.textColor = .red
        
        passwordTipLabel.text = .passwordValidTip
        passwordTipLabel.textColor = .red
        
        //  1.用户名是否有效
        let userNameValid = userNameTF.rx.text.orEmpty
            .map { $0.count >= 6 }
        .share(replay: 1)
        
        userNameValid.bind(to: passwordTF.rx.isEnabled)
        .disposed(by: disposeBag)

        userNameValid.bind(to: userNameTipLabel.rx.isHidden)
        .disposed(by: disposeBag)
        
        // 2.密码收否有效
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= 6 }
        .share(replay: 1)
        
        passwordValid.bind(to: passwordTipLabel.rx.isHidden)
        .disposed(by: disposeBag)
        
        // 3.所有输入是否有效
        let everythingValid = Observable.combineLatest(
               userNameValid,
               passwordValid
        ) { $0 && $1 }
        .share(replay: 1)
        
        everythingValid.bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.doSomething()
            }).disposed(by: disposeBag)
        
        
       
    }
    
    private func doSomething() {
        // 1. Single的使用
        usingSingle()
    }

    
    
}

// MARK: - Single的使用
extension ViewController {
    func usingSingle() {
        FunctionalReactiveProgramming.getRepo("Reactive/RxSwift")
            .subscribe(onSuccess: { (json) in
                print("JSON: \(json)")
            }) { (error) in
                print("Error: \(error.localizedDescription)")
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Completable的使用
extension ViewController {
    func usingCompletable() {
        FunctionalReactiveProgramming.cacheLocally()
            .subscribe(onCompleted: {
                print("Completed with no error")
            }) { (error) in
                print("Completed with an error: \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
}

// MARk: - Maybe的使用
extension ViewController {
    func usingMaybe() {
        FunctionalReactiveProgramming.gengerateStringByMaybe()
            .subscribe(onSuccess: { (str) in
                print("STR: \(str)")
            }, onError: { (error) in
               print("Maybe with an error: \(error.localizedDescription)")
            }) {
                 print("Maybe with no error")
        }.disposed(by: disposeBag)
    }
}


extension String {
    static let userNameValidTip = "用户名不得少于6个字符"
    static let passwordValidTip = "密码不得少于6个字符"
}

