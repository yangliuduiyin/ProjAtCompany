//
//  K3FMHomeViewController.swift
//  K3FMDemo
//
//  Created by admin-3k on 2018/12/18.
//  Copyright © 2018 admin-3k. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import DNSPageView

class K3FMHomeViewController: UIViewController {

    private var categoryId: Int = 18
    private var isVipPush:Bool = false
    
    convenience init(categoryId: Int = 18,isVipPush:Bool = false) {
        self.init()
        self.categoryId = categoryId
        self.isVipPush = isVipPush
    }
    
    private var Keywords:[ClassifySubMenuKeywords]?
    private lazy var nameArray = NSMutableArray()
    private lazy var keywordIdArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "IT科技"
        loadHeaderCategoryData()
    }
    

    deinit {
        
    }
    
    
    fileprivate func loadHeaderCategoryData(){
        //分类二级界面顶部分类接口请求
        ClassifySubMenuProvider.request(ClassifySubMenuAPI.headerCategoryList(categoryId: self.categoryId)) { result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                print("加载IT科技类返回的数据: \(json)")
                
                
                if let mappedObject = JSONDeserializer<ClassifySubMenuKeywords>.deserializeModelArrayFrom(json: json["keywords"].description) { // 从字符串转换为对象实例
                    self.Keywords = mappedObject as? [ClassifySubMenuKeywords]
                    for keyword in self.Keywords! {
                        self.nameArray.add(keyword.keywordName!)
                    }
                    if !self.isVipPush{
                        self.nameArray.insert("推荐", at: 0)
                    }
                    self.initHeaderView()
                }
            }
        }
    }
    
    fileprivate func initHeaderView(){
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleViewScrollEnabled = true
        //style.isTitleScrollEnable = true
        style.isTitleScaleEnabled = true
        //style.isScaleEnable = true
        style.isShowBottomLine = true
        style.titleSelectedColor = UIColor.black
        style.titleColor = UIColor.gray
        style.bottomLineColor = .dominantColor
        style.bottomLineHeight = 2
        style.titleViewBackgroundColor = .footerViewColor
        
        // 创建每一页对应的controller
        var viewControllers = [UIViewController]()
        for keyword in self.Keywords! {
            let controller = ClassifySubContentController(keywordId:keyword.keywordId, categoryId:keyword.categoryId)
            viewControllers.append(controller)
        }
        if !self.isVipPush{
            // 这里需要插入推荐的控制器，因为接口数据中并不含有推荐
            let categoryId = self.Keywords?.last?.categoryId
            viewControllers.insert(ClassifySubRecommendController(categoryId:categoryId!), at: 0)
        }
        
        for vc in viewControllers {
            addChild(vc)
        }
        
        let pageView = DNSPageView(frame: CGRect(x: 0, y: .navigationBarHeight, width: .YYScreenWidth, height: .YYScreenHeigth - .navigationBarHeight), style: style, titles: nameArray as! [String], childViewControllers: viewControllers)
        view.addSubview(pageView)
    }

}


extension CGFloat {
    static let YYScreenWidth = UIScreen.main.bounds.size.width
    static let YYScreenHeigth = UIScreen.main.bounds.size.height
    static let navigationBarHeight : CGFloat = Bool.isIphoneX ? 88 : 64
    static let tabBarHeight : CGFloat = Bool.isIphoneX ? 49 + 34 : 49
}

extension UIColor {
    static let dominantColor = UIColor.init(red: 242/255.0, green: 77/255.0, blue: 51/255.0, alpha: 1)
    static let footerViewColor = UIColor.init(red: 240/255.0, green: 241/255.0, blue: 244/255.0, alpha: 1)
}

extension Bool {
    static let isIphoneX = CGFloat.YYScreenHeigth == 812 ? true : false
}

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

