//
//  FMPlayFooterView.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/24.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class FMPlayFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .footerViewColor
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
