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
     */
    
    func getRepo(_ repo: String) -> Single<[String: Any]> {
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
    // MARK: - Maybe
    // MARK: - Driver
    // MARK: - ControlEvent
    
    
    
   
   
}



enum DataError: Error {
    case cantParseJSON
}










extension FunctionalReactiveProgramming {
     static let define = "函数式编程是种编程范式，它需要我们将函数作为参数传递，或者作为返回值返还。我们可以通过组合不同的函数来得到想要的结果。"
}
