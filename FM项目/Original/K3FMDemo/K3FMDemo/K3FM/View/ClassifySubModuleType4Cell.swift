//
//  ClassifySubModuleType4Cell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/20.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class ClassifySubModuleType4Cell: UICollectionViewCell {
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
    
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    // 声音数量
    private var listenView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "listen")
        return imageView
    }()
    
    // 声音数
    private var listenLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI(){
        addSubview(picView)
        picView.image = UIImage(named: "pic1.jpeg")
        picView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(picView.snp.right).offset(10)
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
        
        addSubview(listenView)
        listenView.snp.makeConstraints { (make) in
            make.left.equalTo(subLabel)
            make.bottom.equalToSuperview().offset(-25)
            make.width.height.equalTo(17)
        }
        
        addSubview(listenLabel)
        listenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listenView.snp.right).offset(5)
            make.bottom.equalTo(listenView)
            make.width.equalTo(60)
        }
    }
    
    var classifyVerticalModel: ClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            picView.kf.setImage(with: URL(string: model.coverPathSmall!))
            titleLabel.text = model.title
            subLabel.text = model.subtitle
            listenLabel.text = model.footnote
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
