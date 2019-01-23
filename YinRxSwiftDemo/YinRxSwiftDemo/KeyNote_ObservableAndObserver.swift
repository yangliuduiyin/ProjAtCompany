
//
//  KeyNote_ObservableAndObserver.swift
//  YinRxSwiftDemo
//
//  Created by admin-3k on 2019/1/23.
//  Copyright © 2019 admin-3k. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 在我们所遇到的事物中，有一部分非常特别。它们既是可被监听的序列也是观察者。
 
 例如：textField的当前文本。它可以看成是由用户输入，而产生的一个文本序列。也可以是由外部文本序列，来控制当前显示内容的观察者：
 
 有许多 UI 控件都存在这种特性，例如：switch的开关状态，segmentedControl的选中索引号，datePicker的选中日期等等。
 */

// 另外，框架里面定义了一些辅助类型，它们既是可被监听的序列也是观察者。如果你能合适的应用这些辅助类型，它们就可以帮助你更准确的描述事物的特征：

// MARK: -  AsyncSubject
/**
 AsyncSubject 将在源 Observable 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 Observable 没有发出任何元素，只有一个完成事件。那 AsyncSubject 也只有一个完成事件。
 它会对随后的观察者发出最终元素。如果源 Observable 因为产生了一个 error 事件而中止， AsyncSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
 
 */
func asyncSubjectDemo() {
    let disposeBag = DisposeBag()
    let subject = AsyncSubject<String>()
    
    subject
        .subscribe { print("Subscription: 1 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🐶")
    subject.onNext("🐱")
    subject.onNext("🐹")
    subject.onCompleted()
    
    // 输出结果:
    /**
     Subscription: 1 Event: next(🐹)
     Subscription: 1 Event: completed
     */
}

// MARK: - PublishSubject
/**
 PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。如果你希望观察者接收到所有的元素，你可以通过使用 Observable 的 create 方法来创建 Observable，或者使用 ReplaySubject。
 如果源 Observable 因为产生了一个 error 事件而中止， PublishSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
 
 */

func publishSubjectDemo() {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    subject
        .subscribe { print("Subscription: 1 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject
        .subscribe { print("Subscription: 2 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    // 输出结果:
    /**
     Subscription: 1 Event: next(🐶)
     Subscription: 1 Event: next(🐱)
     Subscription: 1 Event: next(🅰️)
     Subscription: 2 Event: next(🅰️)
     Subscription: 1 Event: next(🅱️)
     Subscription: 2 Event: next(🅱️)
     */
}

// MARK: - ReplaySubject
/**
 ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
 
 这里存在多个版本的 ReplaySubject，有的只会将最新的 n 个元素发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。
 
 如果把 ReplaySubject 当作观察者来使用，注意不要在多个线程调用 onNext, onError 或 onCompleted。这样会导致无序调用，将造成意想不到的结果。
 */
func replaySubjectDemo() {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1) // 注意bufferSize参数
    subject
        .subscribe { print("Subscription: 1 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject
        .subscribe { print("Subscription: 2 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    // 输出结果:
    /**
     Subscription: 1 Event: next(🐶)
     Subscription: 1 Event: next(🐱)
     Subscription: 2 Event: next(🐱)
     Subscription: 1 Event: next(🅰️)
     Subscription: 2 Event: next(🅰️)
     Subscription: 1 Event: next(🅱️)
     Subscription: 2 Event: next(🅱️)
     */
    
}

// MARK: - BehaviorSubject
/**
 当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
 如果源 Observable 因为产生了一个 error 事件而中止， BehaviorSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
 */

func behaviorSubjectDemo() {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴") // 设置一个默认的元素
    
    subject
        .subscribe { print("Subscription: 1 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject
        .subscribe { print("Subscription: 2 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject
        .subscribe { print("Subscription: 3 Event:", $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("🍐")
    subject.onNext("🍊")
    // 输出结果
    /**
     Subscription: 1 Event: next(🔴)
     Subscription: 1 Event: next(🐶)
     Subscription: 1 Event: next(🐱)
     Subscription: 2 Event: next(🐱)
     Subscription: 1 Event: next(🅰️)
     Subscription: 2 Event: next(🅰️)
     Subscription: 1 Event: next(🅱️)
     Subscription: 2 Event: next(🅱️)
     Subscription: 3 Event: next(🅱️)
     Subscription: 1 Event: next(🍐)
     Subscription: 2 Event: next(🍐)
     Subscription: 3 Event: next(🍐)
     Subscription: 1 Event: next(🍊)
     Subscription: 2 Event: next(🍊)
     Subscription: 3 Event: next(🍊)
     */
}
// MARK: - Varable
/**
 
 在 Swift 中我们经常会用 var 关键字来声明变量。RxSwift 提供的 Variable 实际上是 var 的 Rx 版本，你可以将它看作是 RxVar。
 */

func varableDemo() {
    let model: Variable<String?> = Variable("hello")
    model.asObservable()
        .subscribe(onNext: { (_) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
    }.disposed(by: DisposeBag())
    
    // 说明:
    /**
     Variable 封装了一个 BehaviorSubject，所以它会持有当前值，并且 Variable 会对新的观察者发送当前值。它不会产生 error 事件。Variable 在 deinit 时，会发出一个 completed 事件。
     */
    
}
// MARK: - ControlProperty
/**
 * ControlProperty 专门用于描述 UI 控件属性的，它具有以下特征：
    * 不会产生error事件
    * 一定在 MainScheduler 订阅（主线程订阅）
    * 一定在 MainScheduler 监听（主线程监听）
    * 共享状态变化
 */






