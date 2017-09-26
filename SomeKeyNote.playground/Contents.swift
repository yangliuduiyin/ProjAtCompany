//: Playground - noun: a place where people can play

import UIKit
import CoreImage


// MARK: - protocol
protocol FullNameProtocol {
    var fullName: String { get set }
}


struct Person: FullNameProtocol {
    
    var fullName: String
}

let p = Person(fullName: "Yin")
print(p.fullName)


class Dog: FullNameProtocol {
    var firstName: String
    var lastName: String
    init(firstName: String, lastName: String/*, englishName: String*/) {
        self.firstName = firstName
        self.lastName = lastName
        //self.englishName = englishName
    }
    
    var fullName: String {
        get {
            return firstName + lastName
        }
        set {
            firstName = newValue
            lastName = newValue
            //fullName = newValue // 警告:Attempting to modify "fullName" within its own setter
        }
    }
    
    var englishName: String! {
        willSet(newEnName) {
            print("running willSet.")
            print(newEnName)
        }
        didSet {
            print("running didSet..")
            print("\(oldValue)")
        }
    }
}

var d = Dog.init(firstName: "ZH", lastName: "LBJ")
print(d.fullName)
print(d.lastName)

d.englishName = "MMMM" // 调用属性观察器...
d.englishName = "NNNNN"

var i1 = 1, i2 = 1
var FStrong = {
    i1 += 1
    i2 += 2
}
var fCopy = {[i1] in
    print(i1, i2)
}
FStrong()
print(i1,i2) // 2,3

fCopy() // 1,3

class aClass {
    var value = 1
}

var c1 = aClass()
var c2 = aClass()

var fSpec = {
    [unowned c1, weak c2] in
    // 两个 aClass 捕获实例的不同的定义方式，决定了它们在闭包中不同的使用方式
    c1.value += 1
    if let c2 = c2 {
        c2.value += 1
    }
}

fSpec()
print(c1.value, c2.value) // 2, 2

// unowned 使用的场景是:原始实例永远不会为nil,闭包可以直接使用它,并且直接定义为显式解包可选值。当原始实例被析构后，在闭包中使用这个捕获值将导致崩溃。
// 如果捕获原始实例在使用过程中可能为 nil ，必须将引用声明为 weak， 并且在使用之前验证这个引用的有效性。


MemoryLayout<Character>.size // 9 1个Character的长度为九个字节
// MARK: - XCPlayground A

// XCPlaygroundPage.currentPage.needsIndefiniteExecution = true 
// XCPlaygroundPage.currentPage.finishExecution()

// NSRunLoop.currentRunLoop().runUntilDate(NSDate().dateByAddingTimeInterval(30)) 


// MARK: - 随机数生成器
protocol Arbitrary {
    static func arbitrary() -> Self // 返回的是遵守该协议的类型
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

print(Int.arbitrary()) // 1829230007
print(Int.arbitrary())

let aArray = ["A","B","C"]
let bArray = ["C","D","E"]
print(aArray + bArray) // ["A", "B", "C", "C", "D", "E"]

// MARK: - Reduce 的使用
let numbers = [1,3,5,7,90]
let strings = ["Hello","world","I","am","a","Farmer."]
let sum = numbers.reduce(0) { (result, i) -> Int in
    return result + i
}
print(sum) // 106

let combineStr = strings.reduce("") { (result, str) in
    return result + str + " "
}
print(combineStr)

