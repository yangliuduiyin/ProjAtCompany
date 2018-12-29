//
//  KeyNote.swift
//  K3FMDemo
//
//  Created by admin-3k on 2018/12/20.
//  Copyright © 2018 admin-3k. All rights reserved.
//

import UIKit

// MARK: - 2018-12-20
class KeyNote: NSObject {
    // MARK: - A.Moya的使用方式可以参考此处:
    /**
     1. 定义一个API的枚举(关联类型即为API的参数)
     2. 枚举实现TargetType协议
     3. ex: let ClassifySubMenuProvider = MoyaProvider<ClassifySubMenuAPI>()
     4. 发起请求时直接调用:
     ClassifySubMenuProvider.request(ClassifySubMenuAPI.headerCategoryList(categoryId: categoryId)) { result in
     }
     */
    
    
    // MARK: - B.HandyJSON && SwifttyJSON的使用方式可以参考此处:
    /**
     * 1. 声明结构体ClassifySubMenuKeywords: HandyJSON
     * 2. let data = try? response.mapJSON();  let json = JSON(data) //  避免强制解包
     * 3. ex:if let mappedObject = JSONDeserializer<ClassifySubMenuKeywords>.deserializeModelArrayFrom(json: json["keywords"].description) {}
     
     ClassifySubMenuProvider.request(ClassifySubMenuAPI.headerCategoryList(categoryId: categoryId)) { result in
     //result: .success(Status Code: 200, Data Length: 718)
     if case let .success(response) = result {
     //解析数据
     guard let data = try? response.mapJSON() else {
     print("网络请求返回的状态码为: \(response.statusCode)")
     return
     }
     let json = JSON(data) //  避免强制解包
     
     if let mappedObject = JSONDeserializer<ClassifySubMenuKeywords>.deserializeModelArrayFrom(json: json["keywords"].description) { // 从字符串转换为对象实例
     self.Keywords = (mappedObject as? [ClassifySubMenuKeywords]) ?? []
     for keyword in self.Keywords {
     self.nameArray.add(keyword.keywordName!)
     }
     
     
     self.initHeaderView()
     }
     }
     }
     */
    
    // MARK: - C. StreamingKit(播放网络音频)的使用:
    /**
     * 1. lazy var audioPlayer = STKAudioPlayer()
     * 2. audioPlayer.play(URL(string: self.playUrl!)!)
          audioPlayer.pause()
          audioPlayer.resume()
          audioPlayer.stop()
     */
    
    // MARK: - D. MJRefresh的封装,参见UIScrollView+MJRefresh.swift

}
