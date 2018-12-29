//
//  ClassifySubHorizontalCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/17.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class ClassifySubHorizontalCell: UICollectionViewCell {
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 子标题
    private var subLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI(){
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(20)
        }
        
        addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
    var classifyVerticalModel: ClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            imageView.kf.setImage(with: URL(string: model.coverMiddle!))
            titleLabel.text = model.title
            subLabel.text = model.intro
        }
    }
    
    var classifyModuleType20Model:ClassifyModuleType20List? {
        didSet {
            guard let model = classifyModuleType20Model else {return}
            imageView.kf.setImage(with: URL(string: model.albumCoverUrl290!))
            titleLabel.text = model.title
            subLabel.text = model.intro
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
