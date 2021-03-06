//
//  FMPlayDetailController.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import LTScrollView
import HandyJSON
import SwiftyJSON

class FMPlayDetailController: UIViewController {
    // 外部传值请求接口如此那
    private var albumId: Int = 0
    
    convenience init(albumId: Int = 0) {
        self.init()
        self.albumId = albumId
    }
    
    private var playDetailAlbum: FMPlayDetailAlbumModel?
    private var playDetailUser: FMPlayDetailUserModel?
    private var playDetailTracks: FMPlayDetailTracksModel?
    //Mark:- headerView
    
    private lazy var headerView: FMPlayDetailHeaderView = {
        let header = FMPlayDetailHeaderView.init(frame: CGRect(x:0, y:0, width: .YYScreenWidth, height:240))
        header.backgroundColor = UIColor.white
        return header
    }()
   
    private let oneVc = PlayDetailIntroController()   // 简介
    private let twoVc = PlayDetailProgramController() // 节目
    private let threeVc = PlayDetailLikeController()  // 找相似
    private lazy var viewControllers: [UIViewController] = [oneVc, twoVc, threeVc]

    private lazy var titles: [String] = ["简介", "节目", "找相似"]

    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.sliderWidth = 80
        layout.titleViewBgColor = UIColor.white
        layout.titleColor = UIColor(r: 178, g: 178, b: 178)
        layout.titleSelectColor = UIColor(r: 16, g: 16, b: 16)
        layout.bottomLineColor = UIColor.red
        layout.sliderHeight = 56
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()

    private lazy var advancedManager: LTAdvancedManager = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let advancedManager = LTAdvancedManager(frame: CGRect(x: 0, y: 0, width: .YYScreenWidth, height: .YYScreenHeigth + .navigationBarHeight), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headerView
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        /* 设置悬停位置 */
        advancedManager.hoverY = .navigationBarHeight
        /* 点击切换滚动过程动画 */
        //        advancedManager.isClickScrollAnimation = true
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        return advancedManager
    }()
    
    //Mark: - 导航栏右边按钮
    private lazy var rightBarButton1:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "icon_more_h_30x31_"), for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonClick1), for: .touchUpInside)
        return button
    }()
    
    //Mark: - 导航栏右边按钮
    private lazy var rightBarButton2:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "icon_share_h_30x30_"), for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonClick2), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navBarBackgroundAlpha = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarBackgroundAlpha = 0
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(advancedManager)
        advancedManagerConfig()
        
//        let rightBarButtonItem1:UIBarButtonItem = UIBarButtonItem.init(customView: rightBarButton1)
//        let rightBarButtonItem2:UIBarButtonItem = UIBarButtonItem.init(customView: rightBarButton2)
//        navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]

        loadData()
    }
    
    fileprivate func loadData(){
        FMPlayDetailProvider.request(FMPlayDetailAPI.playDetailData(albumId:self.albumId)) { result in
            if case let .success(response) = result {
                //解析数据
                guard let data = try? response.mapJSON() else {
                    
                    return
                }
                let json = JSON(data)
                print("************当前专辑:\(self.albumId)的详情数据为: \(json)************")
                if let playDetailAlbum = JSONDeserializer<FMPlayDetailAlbumModel>.deserializeFrom(json: json["data"]["album"].description) { //  专辑信息
                    self.playDetailAlbum = playDetailAlbum
                }
                if let playDetailUser = JSONDeserializer<FMPlayDetailUserModel>.deserializeFrom(json: json["data"]["user"].description) { // 电台用户信息
                    self.playDetailUser = playDetailUser
                }
                if let playDetailTracks = JSONDeserializer<FMPlayDetailTracksModel>.deserializeFrom(json: json["data"]["tracks"].description) { // 节目内容
                    self.playDetailTracks = playDetailTracks
                }
                //传值给 headerView
                self.headerView.playDetailAlbumModel = self.playDetailAlbum
                //传值给 简介界面
                self.oneVc.playDetailAlbumModel = self.playDetailAlbum
                self.oneVc.playDetailUserModel = self.playDetailUser
                //传值给节目界面
                self.twoVc.playDetailTracksModel = self.playDetailTracks
            }
        }
    }
    
    //Mark: - 导航栏左边消息点击事件
    @objc func rightBarButtonClick1() {
        
    }
    
    //Mark: - 导航栏左边消息点击事件
    @objc func rightBarButtonClick2() {
        
    }

    deinit {
        print("\(self) deinit.")
    }
}

extension FMPlayDetailController : LTAdvancedScrollViewDelegate {
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
        advancedManager.advancedDidSelectIndexHandle = {
            print("选中了 -> \($0)")
        }
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        if (offsetY > 5)
        {
            let alpha = offsetY / CGFloat.navigationBarHeight
            navBarBackgroundAlpha = alpha
            self.rightBarButton1.setImage(UIImage(named: "icon_more_n_30x31_"), for: .normal)
            self.rightBarButton2.setImage(UIImage(named: "icon_share_n_30x30_"), for: .normal)
        }else{
            navBarBackgroundAlpha = 0
            self.rightBarButton1.setImage(UIImage(named: "icon_more_h_30x31_"), for: .normal)
            self.rightBarButton2.setImage(UIImage(named: "icon_share_h_30x30_"), for: .normal)
        }
    }
}
