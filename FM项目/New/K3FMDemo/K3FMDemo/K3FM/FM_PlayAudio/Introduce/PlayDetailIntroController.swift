//
//  PlayDetailIntroController.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import LTScrollView

class PlayDetailIntroController: UIViewController, LTTableViewProtocal{
   
    private var playDetailAlbum: FMPlayDetailAlbumModel?
    private var playDetailUser: FMPlayDetailUserModel?

    private let PlayContentIntroCellID = "PlayContentIntroCell"
    private let PlayAnchorIntroCellID  = "PlayAnchorIntroCell"
    private lazy var tableView: UITableView = {
        let table = tableViewConfig(CGRect(x: 0, y: 0, width:.YYScreenWidth, height: .YYScreenHeigth), self, self, nil)
        table.register(PlayContentIntroCell.self, forCellReuseIdentifier: PlayContentIntroCellID)
        table.register(PlayAnchorIntroCell.self, forCellReuseIdentifier: PlayAnchorIntroCellID)
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    // 内容简介model
    var playDetailAlbumModel: FMPlayDetailAlbumModel? {
        didSet {
            guard let model = playDetailAlbumModel else { return }
            self.playDetailAlbum = model
            // 防止刷新分区的时候界面闪烁
            UIView.performWithoutAnimation {
                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
            }
        }
    }
    // 主播简介model
    var playDetailUserModel:FMPlayDetailUserModel? {
        didSet{
            guard let model = playDetailUserModel else {return}
            self.playDetailUser = model
            // 防止刷新分区的时候界面闪烁
            UIView.performWithoutAnimation {
                self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
            }        }
        
    }
}

extension PlayDetailIntroController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:PlayContentIntroCell = tableView.dequeueReusableCell(withIdentifier: PlayContentIntroCellID, for: indexPath) as! PlayContentIntroCell
            cell.selectionStyle = .none
            cell.playDetailAlbumModel = self.playDetailAlbum
            return cell
        }else {
            let cell: PlayAnchorIntroCell = tableView.dequeueReusableCell(withIdentifier: PlayAnchorIntroCellID, for: indexPath) as! PlayAnchorIntroCell
            cell.selectionStyle = .none
            cell.playDetailUserModel = self.playDetailUser
            return cell
        }
    }
}


