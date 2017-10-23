//: Playground - noun: a place where people can play

import UIKit

// MARK: - shuffled方法
//#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
//import Darwin // 为了支持arc4random_uniform()
//#elseif os(Linux)
//import Glibc // 为了支持random()
//#endif

extension Sequence {
    public func shuffled() -> [Iterator.Element] {
        var contents = Array(self)
        for i in 0..<contents.count {
            //            #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            //                let j = Int(arc4random_uniform(UInt32(count)))
            //            #elseif os(Linux)
            //                let j = random() % contents.count
            //            #endif
            let j = Int(arc4random_uniform(UInt32(contents.count))) // FIXME: 数组元素数量超过 2^32 时会挂
            if i != j {
               contents.swapAt(i, j)
            }
        }
        return contents
    }
}


// MARK: - begin at 2017-09-26 08:52:30

public protocol SortedSet: BidirectionalCollection,CustomStringConvertible,CustomPlaygroundQuickLookable where Element: Comparable {
    
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
} // BidirectionalCollection: Collection, Collection协议中包含:public var count { get }

// 提供一个description的默认实现:
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map {
            "\($0)"
        }.joined(separator: ",")
        return "[\(contents)]"
    }
}

/**
 我们需要知道的是:BidirectionalCollection 有大约30项要求 (像是 startIndex、 index(after:)、map 和 lazy)，它们中的大多数有默认实现。在这本书中，我们将聚焦于要求的绝对最小集，包括 startIndex、endIndex、subscript、index(after:)、index(before:)、 formIndex(after:)、formIndex(before:) 和 count。大多数情况下，我们只实现这些方法，尽管 通常来讲，进行专⻔的处理能获得更好的性能，但我们还是选择将其它方法保持默认实现的状态。不过有一个例外，因为 forEach 是 contains 的好搭档，所以我们也会专⻔实现它。
 */
#if os(iOS)
    extension PlaygroundQuickLook {
        public static func monospacedText(_ string: String) -> PlaygroundQuickLook {
            let text = NSMutableAttributedString(string: string)
            let range = NSRange(location: 0, length: text.length)
            let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            style.lineSpacing = 0
            style.alignment = .left
            style.maximumLineHeight = 17
            text.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Menlo", size: 13)!, range: range)
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
// 为了实现 insert 和 contains，我们需要一个方法，给定一个元素，该方法返回该元素在数组中应当放置的位置。
//如何快速实现这样一个方法呢?首先我们需要实现二分查找算法。这个算法的工作原理是，将数组一分为二，舍弃不包含我们正在查找的元素的那一半，将这个过程循环往复，直到减少到只有一个元素为止。下面是 Swift 中实现该算法的方法之一:
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
        let index = self.index(for: element) // 借助index(for:)方法
        guard index < count, storage[index] == element else {
            return nil
        }
        return index
    }
}

/**
 Collection的默认查找算法的原理是: 执行一个线性查找来遍历所有的元素,直到找到目标或是到达末尾为止.
 */
// 检验元素是否存在:
extension SortedArray {
    public func contains(_ element: Element) -> Bool {
        let index = self.index(for: element)
        return index < count && storage[index] == element
    }
}
// 实现forEach更加容易,因为我们可以直接将这个调用传递给我们的存储数组。数组已经排序,因此方法将会以正确的顺序访问元素:
extension SortedArray {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try storage.forEach(body)
    }
}

/**
 到现在我们已经实现了几个方法，不妨回过头看一看其他Sequence和Collection 的成员，值得开心的是，它们也受益于专⻔的实现。比如说，由 Comparable 元素组成的序列有一个 sorted() 方法，返回一个包含该序列所有元素的有序数组。对于 SortedArray，简单地返回 storage 就可以实现:
 */
extension SortedArray {
    
    public func sorted() -> [Element] {
        return storage
    }
}

// MARK: - 插入:
/**
 向有序集合中插入一个新元素的流程是:首先用 index(for:) 找到它相应的索引，然后检查这个 元素是否已经存在。为了维护 SortedSet 不能包含重复元素特性，我们只向 storage 插入目前不存在的元素
 */
extension SortedArray {
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let index = self.index(for: newElement)
        if index < count && storage[index] == newElement {
            return (false,storage[index])
        }
        storage.insert(newElement, at: index)
        return (true,newElement)
    }
}

// MARK: - 实现集合类型
/**
 下一步，让我们来实现 BidirectionalCollection。因为我们将所有东西都存储到了一个单一数组中，所以最简单的实现方法是在SortedArray和它的 storage之间共享索引。这样一来，我们可以将大多数集合类型的方法直接传递给storage数组，从而大幅度简化我们的实现。
 Array实现的不止是BidirectionalCollection，实际是有着相同API接口但语义要求更严格的 RandomAccessCollection。RandomAccessCollection要求高效的索引计算，因为我们必须任何时候都能够将索引进行任意数量的偏移，以及测算任意两个索引之间的距离。
 一个事实是，我们无论如何都会向 storage 传递各种调用，所以在 SortedArray 上实现相同的 协议是一件有意义的事情:
 */
extension SortedArray: RandomAccessCollection {
    public typealias Indices = CountableRange<Int>
    public var startIndex: Int { return storage.startIndex }
    public var endIndex: Int { return storage.endIndex }
    public subscript(index: Int) -> Element { return storage[index] }
}
// MARK: - ps: 至此就完成了SortedSet协议的实现.
// MARK: - 例子
// 检验一下一切是否正常:
var set = SortedArray<Int>()
for i in (0..<22).shuffled() {
    set.insert( 2 * i)
}
print(set) // [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42]
set.contains(42) // true
set.contains(13) // false

// MARK: - 我们的新集合是否具有值语义???
let copy = set
set.insert(13)
set.contains(13) // true
copy.contains(13) // false
/**
 看起来答案是肯定的!我们并没有做任何工作来实现值语义;凭借 SortedArray 是一个由单一数组构成的结构体这个仅有的事实，我们得到了前面结果。值语义是一个组合性质，若结构体中的存储属性全都具有值语义，它的行为也会自动表现得一致。
 */

//  MARK: - 性能
/**
 当我们谈论一个算法的性能时，我们常用所谓的大O符号来描述执行时间受输入元素个数的影响所发生的改变，记为:O(1)、O(n)、O(n2 )、O(log n)、O(n log n) 等。这个符号在数学上有明确的定义，不过你不需要太关注，理解我们在为算法增⻓率 (growth rate) 分类时使用这个符 号作为简写就足够了.
 */
/**
 为了了解我们的 SortedSet 的真实性能，运行一些性能测试是个好办法。例如，下述代码可以对四个SortedArray上的基础操作进行微型性能测试，它们分别是:insert、contains、 forEach 和用 for 语句实现的迭代:
 */

func benchmark(count: Int, measure:(String, () -> Void) -> Void) {
    var set = SortedArray<Int>()
    let input = (0..<count).shuffled()
    
    measure("SortedArray.insert"){
        for value in input {
            set.insert(value)
        }
    }
    
    let lookups = (0..<count).shuffled()
    measure("SortedArray.contains"){
        for element in lookups {
            guard set.contains(element) else {fatalError()}
        }
    }
    
    measure("SortedArray.forEach"){
        var i = 0
        set.forEach{ element in
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else {fatalError()}
    }
    
    measure("SortedArray.for-in") {
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
    
}


for size in ((0..<20).map({ 1 << $0 })) {
    benchmark(count: size, measure: { name, body in
        let start = Date()
        body()
        let end = Date()
        print("\(name), \(size),\(end.timeIntervalSince(start))")
    })
    
}
/**
 [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42]
 SortedArray.insert, 1,0.00387799739837646
 SortedArray.contains, 1,0.0014069676399231
 SortedArray.forEach, 1,0.00874900817871094
 SortedArray.for-in, 1,0.00116300582885742
 SortedArray.insert, 2,0.00347298383712769
 SortedArray.contains, 2,0.00319898128509521
 SortedArray.forEach, 2,0.0115560293197632
 SortedArray.for-in, 2,0.00138700008392334
 SortedArray.insert, 4,0.00758802890777588
 SortedArray.contains, 4,0.00591897964477539
 SortedArray.forEach, 4,0.01453697681427
 SortedArray.for-in, 4,0.00220900774002075
 SortedArray.insert, 8,0.015953004360199
 SortedArray.contains, 8,0.0127270221710205
 SortedArray.forEach, 8,0.021245002746582
 SortedArray.for-in, 8,0.00413805246353149
 SortedArray.insert, 16,0.036812961101532
 SortedArray.contains, 16,0.0269900560379028
 SortedArray.forEach, 16,0.0372310280799866
 SortedArray.for-in, 16,0.00769901275634766
 SortedArray.insert, 32,0.0863759517669678
 SortedArray.contains, 32,0.0569640398025513
 SortedArray.forEach, 32,0.0608360171318054
 SortedArray.for-in, 32,0.0131469964981079
 SortedArray.insert, 64,0.196743011474609
 SortedArray.contains, 64,0.108776032924652
 SortedArray.forEach, 64,0.116102993488312
 SortedArray.for-in, 64,0.0266799926757812
 SortedArray.insert, 128,0.447632968425751
 SortedArray.contains, 128,0.193419992923737
 SortedArray.forEach, 128,0.181632995605469
 SortedArray.for-in, 128,0.0397049784660339
 SortedArray.insert, 256,1.1084880232811
 SortedArray.contains, 256,0.4599369764328
 SortedArray.forEach, 256,0.361581981182098
 SortedArray.for-in, 256,0.0802139639854431
 SortedArray.insert, 512,2.63467198610306
 SortedArray.contains, 512,0.922859013080597
 SortedArray.forEach, 512,0.713934004306793
 SortedArray.for-in, 512,0.157770991325378
 SortedArray.insert, 1024,6.14901298284531
 SortedArray.contains, 1024,1.84557294845581
 SortedArray.forEach, 1024,1.32266199588776
 SortedArray.for-in, 1024,0.322825968265533
 SortedArray.insert, 2048,14.987900018692
 SortedArray.contains, 2048,4.01817899942398
 SortedArray.forEach, 2048,3.23227697610855
 SortedArray.for-in, 2048,0.639755010604858
 SortedArray.insert, 4096,40.6670219898224
 SortedArray.contains, 4096,8.04639101028442
 SortedArray.forEach, 4096,5.89471799135208
 SortedArray.for-in, 4096,1.82161098718643

 */


// MARK: - chapter 3: 将NSOrderedSet Swift化
// NSOrderedSet目前尚未被桥接到Swift。
public class Canary {}
public struct OrderedSet<Element: Comparable>: SortedSet {
    fileprivate var storage = NSMutableOrderedSet()
    fileprivate var canary = Canary() // 存在的额唯一目的是表示变更storage是否安全(另外一种方法是将NSMutableOrderedSet的引用放到新的Swift类内部。这也可以顺利达到目的。)
    public init() {}
}

// 查找元素:
extension OrderedSet {
    public func forEach(_ body: (Element) -> Void) {
        storage.forEach {
            body($0 as! Element)
        }
    }
}

extension OrderedSet {
    /*
    public func contains(_ element: Element) -> Bool {
        return storage.contains(element) // BUG! 如果Element 并未实现 Hashable，则查找总会返回false.
        // 编译上面的代码没有任何警告，当 Element 是 Int 或 String 的时候，它表现得一切正常。但是， 正如我们已经提到过的，NSOrderedSet 使用了 NSObject 的哈希 API 来加速元素查找。而我们并未要求 Element 实现 Hashable!这凭什么可以正常工作呢?
        // 当我们像上面的storage.contains中做的那样, 将一个Swift值类型提供给一个OC对象的方法时,编译器会为此生成一个私有的 NSObject子类,并将值装箱(box)到其中.一定要记住NSObject 有内建的哈希API;你不可能有一个不支持hash的NSObject实例。因此，这些自动生成的桥接类也必然有与 isEqual(:) 一致的 hash 实现。
    }
 */
}

extension OrderedSet {
    fileprivate static func compare(_ a: Any, _ b: Any) -> ComparisonResult {
        let a = a as! Element, b = b as! Element
        if a < b {
            return .orderedAscending
        }
        if a > b {
            return .orderedDescending
        }
        return .orderedSame
    }
}

extension OrderedSet {
    public func index(of element: Element) -> Int? {
        let index = storage.index(of: element, inSortedRange: NSRange(0 ..< storage.count), usingComparator: OrderedSet.compare)
        return index == NSNotFound ? nil : index // 我们有这个函数以后，对 contains 的改造就可以降低到一个很小的范围内:
    }
}

extension OrderedSet {
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
}

extension OrderedSet {
    public func contains2(_ element: Element) -> Bool {
        return storage.contains(element) || index(of: element) != nil
    }
}

// 实现 Collection
// NSOrderedSet只遵循Sequence，而不遵循Collection。(这不是什么独特的巧合;它有名的小伙伴NSArray和NSSet 也一样。) 不过，NSOrderedSet 提供了一些基于整数的索引方法，我们可以使用它们在 OrderedSet中实现 RandomAccessCollection。
extension OrderedSet: RandomAccessCollection {
    public typealias Index = Int
    public typealias Indices = CountableRange<Int>
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return storage.count }
    public subscript(i: Int) -> Element {
        return storage[i] as! Element
    }
}

// 保证值语义:
/**
 SortedSet 要求值语义，这意味着每个包含有序集合的变量都需要表现得像是持有自身的值的 单独复制，完全与所有其它变量独立。
这次我们不会再 “免费” 得到值语义了!我们的 OrderedSet 结构体包含一个指向类实例的引用，所以拷⻉一个OrderedSet的值到另一个变量只会增加存储对象的引用计数。
这意味着两个OrderedSet的变量可能很容易共享相同的存储:
 */

// Swift标准库提供了一个名为isKnownUniquelyReferenced的函数,可以调用它来判断一个指向对象的特定引用是否唯一。如果返回true，那我们就知道没有其它值持有该对象的引用，所 以直接修改它是安全的。
//(务必注意，这个函数只关注强引用;并不计算弱引用和无主 (unowned) 引用。因此我们不可能真正地明察每一种引用持有的情况。还好，在我们的例子中这不是问题，由于storage是一个私有属性，只有OrderedSet内部的代码才可以访问它，我们也绝不会创建“隐式”引用。不计算弱引用和无主引用是故意而为，并非偶然的疏忽;这样一来，更复杂的集合类型的索引就可以在某些情况下(比如将一个元素从特定索引移除时)，不进行强制写时复制，也能包含对存储的引用。我们将会在本书后面的章节中⻅到像这样的索引定义的例子。)


// 定义一个为安全修改存储保驾护航的方法:
extension OrderedSet {
    fileprivate mutating func makeUniuqe() {
        if !isKnownUniquelyReferenced(&canary) {
            storage = storage.mutableCopy() as! NSMutableOrderedSet
            canary  = Canary()
        }
    }
}

// 插入:实现insert: NSMutableOrderedSet中的insert方法很像 NSMutableArray的，它接受一个整数索引作为参数:
/*
 class NSOrderedSet: NSObject { // 在 Foundation 中 ...
 func insert(_ object: Any, at idx: Int)
 ...
 }
 */

extension OrderedSet {
    fileprivate func index(for value: Element) -> Int {
        return storage.index(of: value, inSortedRange: NSRange(0 ..< storage.count), options: .insertionIndex, usingComparator: OrderedSet.compare)
    }
}

extension OrderedSet {
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let index = self.index(for: newElement)
        if index < storage.count,
            storage[index] as! Element == newElement {
            return (false, storage[index] as! Element)
        }
        makeUniuqe() // 重要!!!
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
}

// 测试:
var oset = OrderedSet<Int>()
for i in (1 ... 20).shuffled() {
    oset.insert(i)
}
print(oset)
