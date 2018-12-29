//
//  ClassifySubRecommendViewModel.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/28.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ClassifySubRecommendViewModel: NSObject {
    // 外部传值请求接口如此那
    var categoryId :Int = 0
    convenience init(categoryId: Int = 0) {
        self.init()
        self.categoryId = categoryId
    }
    
    var classifyCategoryContentsList:[ClassifyCategoryContentsList]?
    var classifyModuleType14List:[ClassifyModuleType14Model]?
    var classifyModuleType19List:[ClassifyModuleType19Model]?
    var classifyModuleType20Model:[ClassifyModuleType20Model]?
    var classifyVerticalModel:[ClassifyVerticalModel]?
    var focus:FocusModel?
    // Mark: -数据源更新
    typealias AddDataBlock = () ->Void
    var updataBlock:AddDataBlock?
}

// Mark:-请求数据
extension ClassifySubRecommendViewModel {
    func refreshDataSource() {
        //分类二级界面推荐接口请求
        ClassifySubMenuProvider.request(ClassifySubMenuAPI.classifyRecommendList(categoryId: self.categoryId)) { result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<ClassifyCategoryContentsList>.deserializeModelArrayFrom(json:json["categoryContents"]["list"].description) { // 从字符串转换为对象实例
                    self.classifyCategoryContentsList = mappedObject as? [ClassifyCategoryContentsList]
                }
                // 顶部滚动视图数据
                if let focusModel = JSONDeserializer<FocusModel>.deserializeFrom(json:json["focusImages"].description) { // 从字符串转换为对象实例
                    self.focus = focusModel
                }
                self.updataBlock?()
            }
        }
    }
}

// Mark:-collectionview数据
extension ClassifySubRecommendViewModel {
    func numberOfSections(collectionView:UICollectionView) ->Int {
        return (self.classifyCategoryContentsList?.count) ?? 0
    }
    // 每个分区显示item数量
    func numberOfItemsIn(section: NSInteger) -> NSInteger {
        let moduleType = self.classifyCategoryContentsList?[section].moduleType
        if moduleType == 14 || moduleType == 19 || moduleType == 20{
            return 1
        }else {
            return self.classifyCategoryContentsList?[section].list?.count ?? 0
        }
    }
    //每个分区的内边距
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        let cardClass = self.classifyCategoryContentsList?[section].cardClass
        let moduleType = self.classifyCategoryContentsList?[section].moduleType
        if cardClass == "horizontal" || moduleType == 16 {
            return UIEdgeInsets(top: 5,left: 15, bottom: 5, right: 15)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //最小 item 间距
    func minimumInteritemSpacingForSectionAt(section:Int) ->CGFloat {
        let cardClass = self.classifyCategoryContentsList?[section].cardClass
        let moduleType = self.classifyCategoryContentsList?[section].moduleType
        if cardClass == "horizontal" || moduleType == 16{
            return 5
        }
        return 0
    }
    
    //最小行间距
    func minimumLineSpacingForSectionAt(section:Int) ->CGFloat {
        let cardClass = self.classifyCategoryContentsList?[section].cardClass
        let moduleType = self.classifyCategoryContentsList?[section].moduleType
        if cardClass == "horizontal" || moduleType == 16 {
            return 5
        }
        return 0
    }
    
    // item 尺寸
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        let moduleType = self.classifyCategoryContentsList?[indexPath.section].moduleType
        let cardClass = self.classifyCategoryContentsList?[indexPath.section].cardClass
        if moduleType == 14 {
            let num:Int = (self.classifyCategoryContentsList?[indexPath.section].list?.count)!
            if num >= 10 { // 这里是判断推荐页面滚动banner下面的分类按钮的高度
                return CGSize.init(width:.YYScreenWidth,height:310)
            }else {
                return CGSize.init(width:.YYScreenWidth,height:230)
            }
        }else if moduleType == 3 || moduleType == 5 || moduleType == 18{
            if cardClass == "horizontal" {
                return CGSize.init(width:(.YYScreenWidth-50)/3,height:180)
            }else{
                return CGSize.init(width:.YYScreenWidth,height:120)
            }
        }else if moduleType == 20{
            return CGSize.init(width:.YYScreenWidth,height:300)
        }else if moduleType == 19{
            return CGSize.init(width: .YYScreenWidth, height: 200)
        }else if moduleType == 17{
            return CGSize.init(width: .YYScreenWidth, height: 180)
        }else if moduleType == 16{
            return CGSize.init(width:(.YYScreenWidth-50)/3,height:180)
        }else if moduleType == 4{
            return CGSize.init(width:.YYScreenWidth,height:120)
        }else {
            return .zero
        }
    }
    
    // 分区头视图size
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        let moduleType = self.classifyCategoryContentsList?[section].moduleType
        if moduleType == 14 || moduleType == 17 || moduleType == 20{
            return .zero
        }
        return CGSize.init(width:.YYScreenWidth,height:40)
    }
    
    // 分区尾视图size
    func referenceSizeForFooterInSection(section: Int) -> CGSize {
       return CGSize.init(width:.YYScreenWidth,height:10)
    }
}

