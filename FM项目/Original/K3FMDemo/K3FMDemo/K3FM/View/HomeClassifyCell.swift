//
//  HomeClassifyCell.swift
//  YYSwiftProject
//
//  Created by Domo on 2018/7/24.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HomeClassifyCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.top.bottom.equalTo(imageView)
            make.width.equalToSuperview().offset(-imageView.frame.width)
        }
    }
    
    var itemModel:ItemList? {
        didSet {
            guard let model = itemModel else { return }
            if model.itemType == 1 {// 如果是第一个item,是有图片显示的，并且字体偏小
                titleLabel.text = model.itemDetail?.keywordName
            }else{
                titleLabel.text = model.itemDetail?.title
                imageView.kf.setImage(with: URL(string: model.coverPath!))
            }
        }
    }
    
    // 前三个分区第一个item的字体较小
    var indexPath: IndexPath? {
        didSet {
            guard let indexPath = indexPath else { return }
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2  {
                if indexPath.row == 0 {
                    self.titleLabel.font = UIFont.systemFont(ofSize: 13)
                }else {
                    imageView.snp.updateConstraints { (make) in
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    titleLabel.snp.updateConstraints { (make) in
                        make.left.equalTo(imageView.snp.right)
                        make.width.equalToSuperview()
                    }
                    titleLabel.textAlignment = NSTextAlignment.center
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

