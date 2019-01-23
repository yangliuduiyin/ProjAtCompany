//
//  KeyNote.swift
//  YinRxSwiftDemo
//
//  Created by admin-3k on 2019/1/21.
//  Copyright © 2019 admin-3k. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class FunctionalReactiveProgramming {
    
    // 创建序列:
    let numbers: Observable<Int> = Observable.create { (observer) -> Disposable in
        observer.onNext(0)
        observer.onNext(1)
        observer.onNext(2)
        observer.onNext(3)
        observer.onNext(4)
        observer.onNext(5)
        observer.onNext(6)
        observer.onCompleted()
        return Disposables.create()
    }
    
    // MATRK: - 几种常用的序列(Observable)
    // MARK: - Single
    /**
     * 要么只发出一个元素,要么产生一个error事件,Ex:HTTP请求.
        * 发出一个元素，或一个error事件
        * 不会共享状态变化
     */
    // 同样可以对 Observable 调用 .asSingle() 方法，将它转换为 Single
    static func getRepo(_ repo: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create(subscribe: { (single) -> Disposable in
            let url = URL(string: "https://api.github.com/repos/\(repo)")!
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves), let result = json as? [String: Any] else {
                    single(.error(DataError.cantParseJSON))
                    return
                }
                
                single(.success(result))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    
    
    // MARK: - Completable
    /**
     Completable是Observable的另外一个版本,不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。
        * 发出0个元素
        * 发出一个completed事件或一个error事件
        * 不会共享状态变化
     */
    
    // 创建Completable和Observable非常相似
    static func cacheLocally() -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            let success: Bool = arc4random() > 50 // Store some data locally if Success.
            guard success else {
                completable(.error(CacheError.failedCaching))
                return Disposables.create { }
            }
            completable(.completed)
            return Disposables.create {
                
            }
            
        })
    }
    // MARK: - Maybe
    /**
     * Maybe是Observable的另外一个版本,它介于Single和Completable之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
         * 发出一个元素或者一个 completed 事件或者一个 error 事件
         * 不会共享状态变化
     */
    
    // 同样可以对 Observable 调用 .asMaybe() 方法，将它转换为 Maybe。
    
    static func gengerateStringByMaybe() -> Maybe<String> {
        return Maybe.create(subscribe: { (maybe) -> Disposable in
            maybe(.success("RxSwift"))
            // OR
            maybe(.completed)
            maybe(.error(DataError.cantParseJSON))
            return Disposables.create { }
        })
    }
    
    // MARK: - Driver
    /**
     * Driver 是一个精心准备的特征序列。它主要是为了简化 UI 层的代码。不过如果你遇到的序列具有以下特征，你也可以使用它:
         * 不会产生Error事件
         * 一定在MainScheduler监听(主线程监听)
         * 共享状态变化
     */

    
    // MARK: - ControlEvent
    /**
     * ControlEvent 专门用于描述 UI 控件所产生的事件，它具有以下特征：
        * 不会产生Error事件
        * 一定在Mainscheduler订阅(主线程订阅)
        * 一定在Mainscheduler监听(主线程监听)
        * 共享状态变化
     */
   
    
   
   
}


public enum SingleEvent<Element> {
    case success(Element) // 产生一个单独的元素
    case error(Swift.Error) // 产生一个错误
}

public enum CompletableEvent {
    case error(Swift.Error)
    case completed
}

public enum DataError: Error {
    case cantParseJSON
}

public enum CacheError: Error {
    case failedCaching
}









extension FunctionalReactiveProgramming {
     static let define = "函数式编程是种编程范式，它需要我们将函数作为参数传递，或者作为返回值返还。我们可以通过组合不同的函数来得到想要的结果。"
}
