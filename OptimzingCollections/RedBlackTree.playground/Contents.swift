//: Playground - noun: a place where people can play

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
        let (tree, old) =
    }
}

extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let (tree, old) = insert(element)
        self = tree
        return (old == nil, old ?? element)
        
    }
}
*/













