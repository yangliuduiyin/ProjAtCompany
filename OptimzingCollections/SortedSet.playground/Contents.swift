//: Playground - noun: a place where people can play

import UIKit
// MARK: - begin at 2017-09-26 08:52:30

public protocol SortedSet: BidirectionalCollection,CustomStringConvertible,CustomPlaygroundQuickLookable where Element: Comparable {
    
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
}

// 提供一个description的默认实现:
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map {
            "\($0)"
        }.joined(separator: ",")
        return "[\(contents)]"
    }
}

#if os(iOS)
    extension PlaygroundQuickLook {
        public static func monospacedText(_ string: String) -> PlaygroundQuickLook {
            let text = NSMutableAttributedString(string: string)
            let range = NSRange(location: 0, length: text.length)
            let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            style.lineSpacing = 0
            style.alignment = .left
            style.maximumLineHeight = 17
            text.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
            return PlaygroundQuickLook.attributedString(text)
        }
    }
#endif

extension SortedSet {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        #if os(iOS)
            return .monospacedText(String(describing: self))
        #else
            return .text(String(describing: self))
        #endif
    }
}


// MARK: - Sorted Arrays
// 想要实现SortedSet,也许最简单的方法是将集合的元素存储在一个数组中。这引出了一个像下面这样的简单结构的定义:
public struct SortedArray<Element: Comparable>: SortedSet {
    fileprivate var storage: [Element] = []
    public init() {}
    
}
// 为了满足协议的要求，我们会时刻保持storage数组处于已排序的状态，故此，命其名曰SortedArray。

// MARK: - 二分查找:
// 为了实现 insert 和 contains，我们需要一个方法，给定一个元素，该方法返回该元素在数组中 应当放置的位置。
//如何快速实现这样一个方法呢?首先我们需要实现二分查找算法。这个算法的工作原理是，将数组一分为二，舍弃不包含我们正在查找的元素的那一半，将这个过程循环往复，直到减少到 只有一个元素为止。下面是 Swift 中实现该算法的方法之一:
extension SortedArray {
    func index(for element: Element) -> Int {
        var start = 0
        var end = storage.count
        while start < end {
            let middle = start + (end - start) / 2
            if element > storage[middle] {
                start = middle + 1
            }else {
                end = middle
            }
        }
        return start
    }
}

extension SortedArray {
    public func index(of element: Element) -> Int? {
        let index = self.index(of: element)
        guard index! < count, storage[index!] == element else {
            return nil
        }
        return index
    }
}























