//: Playground - noun: a place where people can play

/**Iterators and Sequences*/
import UIKit

struct ReversedIterator: IteratorProtocol {
    
    var index: Int
    
    init<T>(array: [T]) {
        index = array.endIndex - 1
    }
    
    mutating func next() -> Int? {
        guard index >= 0 else {
            return nil
        }
        defer {
            index -= 1
        }
        return index
    }
}

let letters = ["A","B","C"]
letters.endIndex // 3

var iterator = ReversedIterator(array: letters)

while let i = iterator.next() {
    print("Element \(i) of thr array is \(letters[i])")
}
/* Element 2 of thr array is C
Element 1 of thr array is B
Element 0 of thr array is A
*/

struct PowerIterator: IteratorProtocol {
    var power: NSDecimalNumber = 1
    
    mutating func next() -> NSDecimalNumber? {
        power = power.multiplying(by: 2)
        return power
    }
}

extension PowerIterator {
    mutating func find(where predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}
var powerIterator = PowerIterator()
powerIterator.find { $0.intValue > 1000 } // 11 times

// MARK: - 生成字符串的迭代器
struct FileLinesIterator: IteratorProtocol {
    let lines: [String]
    var currentLine: Int = 0
    init(filename: String) throws {
        let contents: String = try String(contentsOfFile: filename)
        lines = contents.components(separatedBy: .newlines)
    }
    
    mutating func next() -> String? {
    
        guard currentLine < lines.endIndex else {
            return nil
        }
        defer {
            currentLine += 1
        }
        return lines[currentLine]
    }
}

extension IteratorProtocol {
    mutating func find(predicate: (Element) -> Bool) -> Element? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

// 我们构建了一个迭代器转换器，它可以用参数中的 limit 值来限制参数迭代器所生成的结果个数:
struct LimitIterator<I: IteratorProtocol>: IteratorProtocol {
    var limit = 0
    var iterator: I
    
    init(limit: Int, iterator: I) {
        self.limit = limit
        self.iterator = iterator
        
    }
    
    mutating func next() -> I.Element? {
        guard limit > 0 else {
            return nil
        }
        return iterator.next()
    }
}

// Swift 提供了 一个简单的 AnyIterator<Element> 结构体，其中的元素类型是一个泛型。要初始化该结构体， 既可以传入一个已有的迭代器，也可以传入一个 next 函数:
/*
 struct AnyIterator<Element>: IteratorProtocol {
     init (_ body: @escaping () -> Element?)
 // ...
 }
*/
// AnyIterator 不仅实现了Iterator 协议，也实现了我们会在下一节进行讲解的 Sequence 协议。
extension Int {
    func countDown() -> AnyIterator<Int> {
        var i = self -1
        return AnyIterator {
            guard i >= 0 else {
                return nil
            }
            defer {
                i -= 1
            }
            return i
        }
    }
}

// 我们甚至可以依据 AnyIterator 来定义能够对迭代器进行操作和组合的函数。比如，我们可以拼接两个基础元素类型相同的迭代器，代码如下:

func +<I: IteratorProtocol, J: IteratorProtocol>(first: I, second: J) -> AnyIterator<I.Element> where I.Element == J.Element {
    var i = first
    var j = second
    return AnyIterator {
        i.next() ?? j.next()
    }
}

func +<I: IteratorProtocol, J: IteratorProtocol>(
    rst: I, second:@escaping @autoclosure()->J)
    -> AnyIterator<I.Element> where I.Element == J.Element {
        var one =  first
        var other: J? = nil
        return AnyIterator {
            if other != nil { return other!.next()
            
            } else if let result = one.next() {
                
                return result
            
            } else {
                other = second()
                return other!.next()
            }
      
        }
}




