//
//  PlayAnchorIntroCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
// 主播简介
class PlayAnchorIntroCell: UITableViewCell {
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "主播介绍"
        return label
    }()
    //icon
    private lazy var iconView:UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    // 昵称
    private lazy var nickNameL:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // 关注
    private lazy var attentionL:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // 加关注
    private lazy var attentionBtn:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "np_headview_nofollow_n_23x36_"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    private func setUpUI(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        addSubview(iconView)
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = 24
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(48)
        }
        
        addSubview(nickNameL)
        nickNameL.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(iconView.snp.top).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        addSubview(attentionL)
        attentionL.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(nickNameL)
            make.top.equalTo(nickNameL.snp.bottom).offset(8)
        }
        
        addSubview(attentionBtn)
        attentionBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(36)
            make.width.equalTo(23)
            make.top.equalTo(iconView)
        }
        // MARK: - 隐藏"关注"按钮
        attentionBtn.isHidden = true
    }
    
    var playDetailUserModel:FMPlayDetailUserModel? {
        didSet{
            guard let model = playDetailUserModel else {return}
            iconView.kf.setImage(with: URL(string: model.smallLogo!))
            nickNameL.text = model.nickname
            var tagString:String
            if model.followers > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.followers) / 100000000)
            } else if model.followers > 10000 {
                tagString = String(format: "%.1f万", Double(model.followers) / 10000)
            } else {
                tagString = "\(model.followers)"
            }
            self.attentionL.text = "已被\(tagString)人关注"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
