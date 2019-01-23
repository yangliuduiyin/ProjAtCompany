
//
//  KeyNote_Disposable.swift
//  YinRxSwiftDemo
//
//  Created by admin-3k on 2019/1/23.
//  Copyright © 2019 admin-3k. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// 通常来说，一个序列如果发出了 error 或者 completed 事件，那么所有内部资源都会被释放。如果你需要提前释放这些资源或取消订阅的话，那么你可以对返回的 可被清除的资源（Disposable） 调用 dispose 方法：
/**
 var disposable: Disposable?
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 self.disposable = textField.rx.text.orEmpty
 .subscribe(onNext: { text in print(text) })
 }
 
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 
 self.disposable?.dispose()
 }
 */

/**
 调用 dispose 方法后，订阅将被取消，并且内部资源都会被释放。通常情况下，你是不需要手动调用 dispose 方法的，这里只是做个演示而已。我们推荐使用 清除包（DisposeBag） 或者 takeUntil 操作符 来管理订阅的生命周期。
 */
