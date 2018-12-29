//
//  PlayDetailProgramHeaderView.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class PlayDetailProgramHeaderView: UIView {
    private lazy var playBtn:UIButton = {
        // 收听全部
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("收听全部", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.backgroundColor = .dominantColor
        button.isHidden = true
        return button
    }()
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        setUpUI()
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUpUI(){
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
