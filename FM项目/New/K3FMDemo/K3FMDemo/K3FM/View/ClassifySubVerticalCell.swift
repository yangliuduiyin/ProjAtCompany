//
//  ClassifySubVerticalCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/17.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class ClassifySubVerticalCell: UICollectionViewCell {
    // 图片
    private var picView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // 是否完结
    private var paidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.init(r: 248, g: 210, b: 74)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 播放数量
    private var numLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 集数
    private var tracksLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 播放数量图片
    private var numView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "playcount.png")
        return imageView
    }()
    
    // 集数图片
    private var tracksView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "track.png")
        return imageView
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
   
    private func setUpUI(){
        addSubview(self.picView)
        picView.image = UIImage(named: "pic1.jpeg")
        picView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
        }
        
        addSubview(self.paidLabel)
        paidLabel.text = "完结"
        paidLabel.snp.makeConstraints { (make) in
            make.left.equalTo(picView.snp.right).offset(10)
            make.top.equalTo(picView).offset(2)
            make.height.equalTo(16)
            make.width.equalTo(30)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(paidLabel.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(picView)
            make.height.equalTo(20)
        }
        
        addSubview(subLabel)
        subLabel.text = "说服力的积分乐山大佛大"
        subLabel.snp.makeConstraints { (make) in
            make.right.height.equalTo(titleLabel)
            make.left.equalTo(picView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        addSubview(numView)
        numView.snp.makeConstraints { (make) in
            make.left.equalTo(subLabel)
            make.bottom.equalToSuperview().offset(-25)
            make.width.height.equalTo(17)
        }
        
        addSubview(numLabel)
        numLabel.text = "> 2.5亿 1284集"
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numView.snp.right).offset(5)
            make.bottom.equalTo(numView)
            make.width.equalTo(60)
        }
        
        addSubview(tracksView)
        tracksView.snp.makeConstraints { (make) in
            make.left.equalTo(numLabel.snp.right).offset(5)
            make.bottom.equalTo(numLabel)
            make.width.height.equalTo(20)
        }
        
        addSubview(tracksLabel)
        tracksLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tracksView.snp.right).offset(5)
            make.bottom.equalTo(tracksView)
            make.width.equalTo(80)
        }
        
    }
    
    var classifyVerticalModel: ClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
             picView.kf.setImage(with: URL(string: model.coverMiddle!))
            if model.isPaid {
                paidLabel.isHidden = true
                paidLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
                titleLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(self.paidLabel.snp.right)
                }
            }
            titleLabel.text = model.title
            subLabel.text = model.intro
            tracksLabel.text = "\(model.tracks)集"
            var tagString:String?
            if model.playsCounts > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playsCounts) / 100000000)
            } else if model.playsCounts > 10000 {
                tagString = String(format: "%.1f万", Double(model.playsCounts) / 10000)
            } else {
                tagString = "\(model.playsCounts)"
            }
            numLabel.text = tagString
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
