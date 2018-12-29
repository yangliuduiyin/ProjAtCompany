//
//  FMPlayViewModel.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/24.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class FMPlayViewModel: NSObject {
    // 外部传值请求接口如此那
    var albumId: Int = 0
    var trackUid: Int = 0
    var uid: Int = 0
    convenience init(albumId: Int = 0, trackUid: Int = 0,uid:Int = 0) {
        self.init()
        self.albumId = albumId
        self.trackUid = trackUid
        self.uid = uid
    }
    
    
    var playTrackInfo: FMPlayTrackInfo?
    var playCommentInfo: [FMPlayCommentInfo]?
    var userInfo: FMPlayUserInfo?
    var communityInfo: FMPlayCommunityInfo?
    
    // MARK: - 数据源更新
    typealias AddDataBlock = () -> Void
    var updataBlock: AddDataBlock?
}


extension FMPlayViewModel {
    // MARK: - 请求数据
    func refreshDataSource() {
        FMPlayProvider.request(FMPlayAPI.fmPlayData(albumId:albumId,trackUid:trackUid,uid:uid)) { result in
           
            if case let .success(response) = result {
                //解析数据
                guard let data = try? response.mapJSON() else {
                    print("请求FM数据返回的状态码: \(response.statusCode)")
                    return
                }
                let json = JSON(data)
                print("-----------请求FM返回的数据: \(json)")
                if let playTrackInfo = JSONDeserializer<FMPlayTrackInfo>.deserializeFrom(json: json["trackInfo"].description) { // 从字符串转换为对象实例
                    self.playTrackInfo = playTrackInfo
                }
               
                // FIXME: 接口返回的数据处理
                // 1. 最新的API中并没有评论的相关数据:
                if let commentInfo = JSONDeserializer<FMPlayCommentInfoList>.deserializeFrom(json: json["noCacheInfo"]["commentInfo"].description) { // 从字符串转换为对象实例
                    self.playCommentInfo = commentInfo.list
                }
                if let userInfoData = JSONDeserializer<FMPlayUserInfo>.deserializeFrom(json: json["userInfo"].description) { // 从字符串转换为对象实例
                    self.userInfo = userInfoData
                }
                // 2.最新的API中并没有communityInfo相关数据
                if let communityInfoData = JSONDeserializer<FMPlayCommunityInfo>.deserializeFrom(json: json["noCacheInfo"]["communityInfo"].description) { // 从字符串转换为对象实例
                    self.communityInfo = communityInfoData
                }
                self.updataBlock?()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FMPlayViewModel {
    func numberOfSections(collectionView: UICollectionView) ->Int {
        return 1
    }
    
    func numberOfItemsIn(section: NSInteger) -> NSInteger {
        if section == 3 {
            return playCommentInfo?.count ?? 0 // 评论数据
        }
        return 1
    }
    //每个分区的内边距
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //最小 item 间距
    func minimumInteritemSpacingForSectionAt(section: Int) -> CGFloat {
        return 0
    }
    
    //最小行间距
    func minimumLineSpacingForSectionAt(section: Int) -> CGFloat {
        return 0
    }
    
    // item 尺寸
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return .init(width:.YYScreenWidth, height: .YYScreenHeigth * 1.0 - CGFloat.navigationBarHeight)
        }else if indexPath.section == 3 {
            let textHeight = height(for: playCommentInfo?[indexPath.row])+100
            return .init(width:.YYScreenWidth,height:textHeight)
        }else {
            return .init(width:.YYScreenWidth,height:140)
        }
    }
    
    // 分区头视图size
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return .init(width: .YYScreenHeigth, height:40)
    }
    
    // 分区尾视图size
    func referenceSizeForFooterInSection(section: Int) -> CGSize {
        return .init(width: .YYScreenWidth, height: 10.0)
    }
    
    // 计算文本高度
    fileprivate func height(for commentModel: FMPlayCommentInfo?) -> CGFloat {
        var height: CGFloat = 10
        guard let model = commentModel else { return height }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = model.content
        height += label.sizeThatFits(CGSize(width: .YYScreenWidth - 80, height: CGFloat.infinity)).height
        return height
    }
}

