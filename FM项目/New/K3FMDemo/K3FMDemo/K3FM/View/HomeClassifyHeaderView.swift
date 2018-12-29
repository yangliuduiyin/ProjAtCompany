//
//  HomeClassifyHeaderView.swift
//  YYSwiftProject
//
//  Created by Domo on 2018/7/24.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class HomeClassifyHeaderView: UICollectionReusableView {
    lazy var view : UIView = {
        let view = UIView()
        view.backgroundColor = .dominantColor
        return view
    }()
    
    lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .footerViewColor
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.width.equalTo(4)
        }
        
        addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.right).offset(10)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    var titleString: String? {
        didSet{
            guard let str = titleString else { return }
            titleLabel.text = str
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
