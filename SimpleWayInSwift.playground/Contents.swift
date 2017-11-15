//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Swift简洁之道"

// 我将会采用一种非常简洁的方式来添加界面元素、完成布局、配置界面属性但是不会用到 `Storybards`.

class OurAwesomeViewController: UIViewController {
    // 懒加载的方式初始化一些UI元素:
    lazy var titleLabel: UILabel = {
        // 初始化 label
        let label = UILabel()
        // 将下面的属性禁止掉，否则会有很多布局的错误日志输出.
        // 我也不清楚为什么默认值是 "true"，反正现在用不到它了.
        label.translatesAutoresizingMaskIntoConstraints = false
        // 给 label 设置字体
        label.font = UIFont(name: "Menlo", size: 14)
        // 设置字体颜色(注意，这里我们不会牵扯到设计的东西)
        label.textColor = .white
        // 当然也可以设置 label 的显示内容
        label.text = "Awesome"
        // 让文字内容居中
        label.textAlignment = .center
        return label
    }()
    // Button 设置也大同小异
    lazy var button: UIButton = {
        // 初始化
        let button = UIButton()
        // 禁用掉这个多余的属性
        button.translatesAutoresizingMaskIntoConstraints = false
        // 设置按钮的标题内容
        button.setTitle("Press Me", for: .normal)
        // 给按钮绑定事件函数
        button.addTarget(self,
                         action: #selector(OurAwesomeViewController.buttonTest),
                         for: .touchUpInside)
        return button
    }()

    // 在这里添加布局代码，当界面准备显示在屏幕上的时候这个方法就会在 UIKit 中被调用
    override func loadView() {
        // 如果要采用UIKit默认提供的view,请别忘了调用 super 的 loadView 方法,如果不用的话，也要给self.view赋值
        super.loadView()
        // 自定义 view 的背景色
        view.backgroundColor = .blue
        // StackView 控件会节省很多时间. 它会自动管理子界面的布局方式并且可以结合一些属性设置就可以避免臃余的界面约束
        // StackView 控件还可以嵌套甚至设置一些边距以满足各种复杂的布局情况.在我看来，这种布局方式要比设置约束简单有效的多.
        let verticalLayout = UIStackView(arrangedSubviews: [titleLabel, button])
        // 同样的禁用掉这个属性
        verticalLayout.translatesAutoresizingMaskIntoConstraints = false
        // 设置垂直方向布局，并且设置填充和对齐方式.
        // 这里不用记到底用了哪个属性，只要大体有个印象，用的时候查下也可以了.
        verticalLayout.axis = .vertical
        verticalLayout.alignment = .fill
        verticalLayout.distribution = .fill
        // 如果你要设置一些边距，可以像下面这样做
        verticalLayout.isLayoutMarginsRelativeArrangement = true
        verticalLayout.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        // 我们给 StackView 控件设置一些布局约束来矫正它的位置
        // 这部分代码可以抽象一下写成一个类库来简化代码.在下面文章中我会展示出来
        let topConstraint = NSLayoutConstraint(item: verticalLayout,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: verticalLayout,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        let leftConstraint = NSLayoutConstraint(item: verticalLayout,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let rightConstraint = NSLayoutConstraint(item: verticalLayout,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        // 现在添加到view中...
        view.addSubview(verticalLayout)
        // 添加上面的约束.
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    // 当按钮被点击时，这个测试方法会被调用.
    @objc func buttonTest(sender: UIButton) {
        // 这里只是改变了界面的颜色
        view.backgroundColor = .red
    }
}

// 将上面的 view controller 绑定到 playground 上.
PlaygroundPage.current.liveView = OurAwesomeViewController()
PlaygroundPage.current.needsIndefiniteExecution = true

// 工具封装
extension UIView { // 布局扩展
    // 这个函数能够缩短自动布局的代码行数，让代码更简洁
    func constrainTo(view: UIView) {
        // 打开 autolayout 配置
        view.translatesAutoresizingMaskIntoConstraints = false
        // 根据函数名称, 我们可以判断参数 view 是当前 view 的父视图
        // 在这里可能看起来有点奇怪, 但是当你看到如何使用时就会豁然开朗了
        view.addSubview(self)
        // 上篇文章之后，我发现了 NSLayoutAnchor 布局系统，它让自动布局的约束构建更加简洁明了，所以我们这里使用它
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}

extension UIStackView {
    // UIStackView 控件有很多经常修改的配置属性. 下面的便利构造函数，可以做到只用一行代码来完成这些事
    convenience init(arrangedSubviews: [UIView],
                     axis: UILayoutConstraintAxis,
                     distribution: UIStackViewDistribution,
                     alignment: UIStackViewAlignment) {
        // 调用原来的构造器
        self.init(arrangedSubviews: arrangedSubviews)
        // 给配置属性赋值
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        // 由于该属性经常设置，所以在这我们直接给隐蔽的封装进去
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIButton {
    class func standardAwesomeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
extension UILabel {
    class func standardAwesomeLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 14)
        label.textColor = .white
        label.text = title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}


























