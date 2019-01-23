//
//  KeyNote_Observer.swift
//  YinRxSwiftDemo
//
//  Created by admin-3k on 2019/1/23.
//  Copyright © 2019 admin-3k. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class YinObserver {
    // MARK: - 观察者(Observer)
    /**
     * 观察者是用来监听事件，然后它需要这个事件作出响应。例如: ‘弹出提示框’就是观察者，它对点击按钮这个事件作出响应。
     */
    // 响应事件的都是观察者
    
    // MARK: - 创建观察者
    /**
     和 Observable 一样，框架已经帮我们创建好了许多常用的观察者。例如：view 是否隐藏，button 是否可点击， label 的当前文本，imageView 的当前图片等等。
     
     另外，有一些自定义的观察者是需要我们自己创建的。这里介绍一下创建观察者最基本的方法，例如，我们创建一个弹出提示框的的观察者：
     */
    
    static let disposeBag = DisposeBag()
    static func createObserver() {
        let button = UIButton()
        button.rx.tap
            .subscribe(onNext: {
                print("点击了按钮")
            }, onError: { (error) in
                print("Error: \(error.localizedDescription)")
            }, onCompleted: {
                print("Has been completed.")
            }) {
                print("Has been disposed.")
            }.disposed(by: disposeBag)
    }
    
    /**
     创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述，事件发生时，需要如何做出响应。而观察者就是由后面的 onNext，onError，onCompleted的这些闭包构建出来的。
     
     以上是创建观察者最常见的方法。当然你还可以通过其他的方式来创建观察者，可以参考一下 AnyObserver 和 Binder。
     */
    
    // MARK: - 特征观察者
    // MARK: - AnyObserver
    /**
     * AnyObserver 可以用来描叙任意一种观察者。
     */
    
    static func createAnyObserver() {
        let url = URL(string: "https://www.baidu.com")!
        let observer: AnyObserver<Data> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print("Data task Sucessed: \(data)")
            case .error(let error):
                print("Error: \(error.localizedDescription)")
            case .completed:
                print("completed")
            }
        }
        URLSession.shared.rx.data(request: URLRequest.init(url: url))
        .subscribe(observer)
        .disposed(by: disposeBag)
    }
    
    // MARK: - Binder
    /**
     * Binder只要有以下两个特征:
        * 不会处理错误事件
        * 确保绑定都是在给定Scheduler上执行(默认MainScheduler)
     * 一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
     */

}






























