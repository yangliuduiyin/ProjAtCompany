//
//  ClassifySubContentController.swift
//  K3FMDemo
//
//  Created by admin-3k on 2018/12/18.
//  Copyright © 2018 admin-3k. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ClassifySubContentController: UIViewController {
    // Mark: - 上页面传过来请求接口必须的参数
    private var keywordId: Int = 0
    private var categoryId: Int = 0
    convenience init(keywordId: Int = 0, categoryId:Int = 0) {
        self.init()
        self.keywordId = keywordId
        self.categoryId = categoryId
    }
    //Mark: - 定义接收的数据模型
    private var classifyVerticallist:[ClassifyVerticalModel]?
    
    private let ClassifySubVerticalCellID = "ClassifySubVerticalCell"
   
    //Mark: - 懒加载
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width:.YYScreenWidth - 15, height:120)
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        // MARK -注册不同分区cell
        collection.register(ClassifySubVerticalCell.self, forCellWithReuseIdentifier: ClassifySubVerticalCellID)
        collection.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.top.bottom.equalToSuperview()
        }
        collectionView.uHead.beginRefreshing()
        loadData()
    }
    
    fileprivate func loadData(){
        //分类二级界面其他分类接口请求
        ClassifySubMenuProvider.request(ClassifySubMenuAPI.classifyOtherContentList(keywordId: keywordId,categoryId: categoryId)) { result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                print("**************IT科技下某一子分类的数据:\(json)**************")
                
                if let mappedObject = JSONDeserializer<ClassifyVerticalModel>.deserializeModelArrayFrom(json:json["list"].description) { // 从字符串转换为对象实例
                    self.classifyVerticallist = mappedObject as? [ClassifyVerticalModel]
                    self.collectionView.uHead.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ClassifySubContentController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classifyVerticallist?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubVerticalCellID, for: indexPath) as! ClassifySubVerticalCell
        cell.classifyVerticalModel = self.classifyVerticallist?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumId = self.classifyVerticallist?[indexPath.row].albumId ?? 0
        let vc = FMPlayDetailController(albumId:albumId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

