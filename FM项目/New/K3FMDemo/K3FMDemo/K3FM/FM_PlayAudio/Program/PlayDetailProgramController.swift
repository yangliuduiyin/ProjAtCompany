//
//  PlayDetailProgramController.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import LTScrollView

class PlayDetailProgramController: UIViewController, LTTableViewProtocal {
    
    var playDetailTracksModel: FMPlayDetailTracksModel? {
        didSet{
            guard let model = playDetailTracksModel else { return }
            self.playDetailTracks = model
            self.tableView.reloadData()
        }
    }
    
    private var playDetailTracks: FMPlayDetailTracksModel?

    private let PlayDetailProgramCellID = "PlayDetailProgramCell"
    private lazy var tableView: UITableView = {
        let table = tableViewConfig(CGRect(x: 0, y:0, width:.YYScreenWidth, height: .YYScreenHeigth), self, self, nil)
        table.register(PlayDetailProgramCell.self, forCellReuseIdentifier: PlayDetailProgramCellID)
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
    
}

extension PlayDetailProgramController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playDetailTracks?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PlayDetailProgramCell = tableView.dequeueReusableCell(withIdentifier: PlayDetailProgramCellID, for: indexPath) as! PlayDetailProgramCell
        cell.selectionStyle = .none
        cell.playDetailTracksList = playDetailTracks?.list?[indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumId = playDetailTracks?.list?[indexPath.row].albumId ?? 0
        let trackUid = playDetailTracks?.list?[indexPath.row].trackId ?? 0
        let uid = playDetailTracks?.list?[indexPath.row].uid ?? 0
//        let vc = YYNavigationController.init(rootViewController: FMPlayController(albumId:albumId, trackUid:trackUid, uid:uid))
         let vc = K3DataNavigationController.init(rootViewController: FMPlayController(albumId:albumId, trackUid:trackUid, uid:uid))
        present(vc, animated: true, completion: nil)
    }
}


