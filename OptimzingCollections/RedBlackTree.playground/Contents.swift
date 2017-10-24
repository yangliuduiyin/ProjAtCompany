//: Playground - noun: a place where people can play

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


// MARK: - 红黑树
import UIKit
/**
 * 红黑树总是保持它的节点的按照一定顺序排布，并以恰当的颜色着色，从而始终满足下述几条
    性质:
 * 1. 根节点是黑色的。
 * 2. 红色节点只拥有黑色的子节点。(只要有，就一定是。)
 * 3. 从根节点到一个空位，树中存在的每一条路径都包含相同数量的黑色节点。(空位指的是在树中所有可以插入新节点的空间，即，一个左右子节点都没有的节点。要让增⻓一个节点，我们只需要用一个新节点替换它的一个空位即可)
 */

public enum Color {
    case black
    case red
}

public enum RedBlackTree<Element: Comparable> {
    case empty
    indirect case node(Color,Element,RedBlackTree,RedBlackTree)
}

// 模式匹配和递归
// contains的实现:
public extension RedBlackTree {
    func contains(_ element: Element) -> Bool {
        switch self {
        case .empty:
            return false
        case .node(_, element, _, _):
            return true
        case let .node(_, value, left, _) where value > element:
            return left.contains(element)
        case let .node(_, _, _, right):
            return right.contains(element)
        }
    }
}

// forEach:
/**
 * 在 forEach 中，我们想按照升序在树中对所有元素调用一个闭包。如果树为空，没有任何难度 就可以做到:因为根本就什么都不用做。除此之外，我们需要先访问所有左子树中的元素，然 后是存储在根节点中的元素，最后访问右子树中的元素。
 * 这样的场合很适合使用switch语句的另一种递归方法:
 */
public extension RedBlackTree {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        switch self {
        case .empty:
            break
        case let .node(_, value, left, right): // 对树进行了中序遍历:
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
}

extension Color {
    var symbol: String {
        switch self {
        case .black:
            return "⚫️"
        case .red:
            return "🔴"
        }
    }
}

extension RedBlackTree: CustomStringConvertible {
    func diagram(_ top: String, _ root: String, _ bottom: String) -> String {
        switch self {
        case .empty:
            return root + ".\n"
        case let .node(color, value, .empty, .empty):
            return root + "\(color.symbol)\(value)\n"
        case let .node(color, value, left, right):
            return right.diagram(top + " ", top + "⌜", top + "⎮") + root + "\(color.symbol)\(value)\n" + left.diagram(bottom + "⎮", bottom + "⌋", bottom + " ")
        }
    }
    
    public var description: String {
        return self.diagram("", "", "")
    }
}

let emptyTree: RedBlackTree<Int> = .empty
print(emptyTree.description) // .

let tinyTree: RedBlackTree<Int> = .node(.black, 42, .empty, .empty)
print(tinyTree)

let smallTree: RedBlackTree<Int> = .node(.black, 2, .node(.red, 1, .empty, .empty), .node(.red, 3, .empty, .empty))
print(smallTree)

let bigTree: RedBlackTree<Int> = .node(.black, 9,
                                       .node(.red, 5,
                                             .node(.black, 1, .empty, .node(.red,4,.empty,.empty)),
                                             .node(.black, 8, .empty, .empty)),
                                       .node(.red, 12,
                                             .node(.black, 11, .empty, .empty),
                                             .node(.black, 16,
                                                   .node(.red, 14, .empty, .empty),
                                                   .node(.red, 17, .empty, .empty))))

print(bigTree)

// 插入:
/**
 * 在SortedSet中，我们将插入定义为了一个可变函数。不过，对于红黑树的例子来说，我们将会定义一个更简单的函数式版本，该版本不会对已经存在的树进行修改，它将返回一棵全新的树。下面是为它量身打造的函数签名:
 */

/*
extension RedBlackTree {
    public func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) {
    }
}
 */


extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let (tree, old) = inserting(element)
        self = tree
        return (old == nil, old ?? element)
        
    }
}

// 对于inserting,我们将参照由 Chris Okasaki 在 1999年首次发表的一个非常出色的模式匹配算法来进行实现:

extension RedBlackTree {
    public func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) {
        let (tree, old) = _inserting(element)
        switch tree {
        case let .node(.red, value, left, right):
            return (.node(.black, value, left, right), old)
        default:
            return (tree, old)
        }
    }
}

extension RedBlackTree {
    func _inserting(_ element: Element) -> (tree: RedBlackTree, old: Element?) {
        switch self {
        case .empty:
            return (.node(.red, element, .empty, .empty), nil)
        case let .node(_, value, _, _) where value == element:
            return (self, value)
        case let .node(color, value, left, right) where value > element:
            let (l, old) = left._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, l, right), nil)
        case let .node(color, value, left, right):
            let (r, old) = right._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, left, r), nil)
        }
    }
}

// 平衡
// balanced方法的工作是检测现有的树是否违反了平衡的要求，如果是，则巧妙地重排节点，随即返回符合标准的树来进行修复。
extension RedBlackTree {
    func balanced(_ color: Color, _ value: Element, _ left: RedBlackTree, _ right: RedBlackTree) -> RedBlackTree {
        switch (color, value, left, right) {
        case let (.black, z, .node(.red, y, .node(.red, x, a, b), c), d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, z, .node(.red, x, a, .node(.red, y, b, c)), d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, z, .node(.red, y, b, c), d)):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, y, b, .node(.red, z, c, d))):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        default:
            return .node(color, value, left, right)
        }
    }
}

var set = RedBlackTree<Int>.empty
for i in (0 ... 20).shuffled(){
    set.insert(i)
}
print(set)

// 集合类型
/**
 实现像 Collection 一样的协议恐怕是代数数据类型开始显得不那么方便的地方。我们需要定义 一个合适的索引类型，而最简单的方法就是直接使用一个元素本身作为索引，就像这样:
 */
extension RedBlackTree {
    public struct Index {
        fileprivate var value: Element?
    }
}
extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        return left.value == right.value
    }
    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        if let lv = left.value, let rv = right.value {
            return lv < rv
        }
        return left.value != nil
    }
}

extension RedBlackTree {
    func min() -> Element? { // 查找最小元素:
        switch self {
        case .empty:
            return nil
        case let .node(_, value, left, _):
            return left.min() ?? value
        }
    }
    
    func max() -> Element? { // 或者按照上面的查找最小元素的方法:
        var node = self
        var maximum: Element? = nil
        while case let .node(_, value, _, right) = node {
            maximum = value
            node = right
        }
        return maximum
    }
}

extension RedBlackTree: Collection {
    
    public var startIndex: Index { return Index(value: self.min()) }
    public var endIndex: Index { return Index(value: self.max()) }
    
    public subscript(i: Index) -> Element {
        return i.value!
    }
}

extension RedBlackTree: BidirectionalCollection {
    public func formIndex(after i: inout Index) {
        let v = self.value(following: i.value!)
        precondition(v.found)
        i.value = v.next
    }
    
    public func index(after i: Index) -> Index {
        let v = self.value(following: value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}

// value(following:) 函数是一个 contains 的巧妙变体。虽然它的逻辑非常复杂，但是绝对值得你 再看一次:
extension RedBlackTree {
    func value(following element: Element) -> (found: Bool, next: Element?) {
        switch self {
        case .empty:
            return (false, nil)
        case .node(_, element, _, let right):
            return (true, right.min())
        case let .node(_, value, left, _) where value > element:
            let v = left.value(following: element)
            return (v.found, v.next ?? value)
        case let .node(_, _, _, right):
            return right.value(following: element)
        }
    }
}

extension RedBlackTree {
    func value(preceding element: Element) -> (found: Bool, next: Element?) {
        var node = self
        var previous: Element? = nil
        while case let .node(_, value, left, right) = node {
            if value > element {
                node = left
            }else if value < element {
                previous = value
                node = right
            }else {
                return (true, left.max())
            }
        }
        return (false, previous)
    }
}

extension RedBlackTree {
    public func formIndex(before i: inout Index) {
        let v = self.value(preceding: i.value!)
        precondition(v.found)
        i.value = v.next
    }
    
    public func index(before i: Index) -> Index {
        let v = self.value(preceding: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}

extension RedBlackTree {
    public var count: Int { // 果我们忘记专⻔实现count，它的默认实现将会计算startIndex和endIndex之间的步数， 这样O(nlogn)比起我们的O(n)会慢得多。但是我们的实现也并没有什么值得宣扬的:它仍然需要访问树中每一个节点。
        switch self {
        case .empty:
            return 0
        case let .node(_, _, left, right):
            return left.count + 1 + right.count
        }
    }
}

let newSet = set.lazy.filter {
    $0 % 2 == 0
    }.map {
        "\($0)"
}.joined(separator: ",")

print(newSet)















