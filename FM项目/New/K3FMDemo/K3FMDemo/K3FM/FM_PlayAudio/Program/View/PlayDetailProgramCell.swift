//
//  PlayDetailProgramCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/21.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class PlayDetailProgramCell: UITableViewCell {
    // 序号
    private lazy var numLabel:UILabel = {
       let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    //标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    //播放图标
    private lazy var playImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sound_playtimes_14x14_")
        return imageView
    }()
    //播放数量
    private lazy var playCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //评论图标
    private lazy var commentImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sound_comments_9x8_")
        return imageView
    }()
    //评论数量
    private lazy var commentNumLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //时长图标
    private lazy var timeImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feed_later_duration_14x14_")
        return imageView
    }()
    //时长
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //日期
    private lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //下载按钮
    private lazy var downloadBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "downloadAlbum_30x30_"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    private func setUpUI(){
        addSubview(numLabel)
        numLabel.text = "2"
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.text = "金瓶梅第三回"
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numLabel.snp.right).offset(10)
            make.top.equalTo(10)
            make.width.equalTo(240)
            make.height.equalTo(40)
        }
        addSubview(playImage)
        playImage.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(17)
        }
        addSubview(playCountLabel)
        playCountLabel.text = "175.4万"
        playCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playImage.snp.right).offset(2)
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.bottom.equalTo(-12)
        }
        
        addSubview(commentImage)
        commentImage.snp.makeConstraints { (make) in
            make.left.equalTo(playCountLabel.snp.right).offset(8)
            make.bottom.equalTo(playImage)
            make.width.height.equalTo(14)
        }
        commentImage.isHidden = true
        
        addSubview(commentNumLabel)
        commentNumLabel.text = "350"
        commentNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentImage.snp.right).offset(2)
            make.width.height.bottom.equalTo(playCountLabel)
        }
        commentNumLabel.isHidden = true
        
        addSubview(timeImage)
        timeImage.snp.makeConstraints { (make) in
            make.left.equalTo(commentNumLabel.snp.right).offset(8)
            make.width.height.equalTo(commentImage)
            make.bottom.equalTo(playImage)
        }
        
        addSubview(timeLabel)
        timeLabel.text = "10:47"
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeImage.snp.right).offset(2)
            make.width.height.bottom.equalTo(playCountLabel)
        }
        
        addSubview(dateLabel)
        dateLabel.text = "2017-12"
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(15)
        }
        // MARK: - 隐藏下载按钮
//        addSubview(downloadBtn)
//        downloadBtn.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-15)
//            make.bottom.equalToSuperview().offset(-10)
//            make.width.height.equalTo(30)
//        }
    }
    
    var playDetailTracksList: FMPlayDetailTracksListModel? {
        didSet{
            guard let model = playDetailTracksList else {return}
             titleLabel.text = model.title
             commentNumLabel.text = "\(model.comments)"
        
            let time = getMMSSFromSS(duration: model.duration)
            timeLabel.text = time
            
            var tagString:String?
            if model.playtimes > 100000000 {
                tagString = String(format: "%.1f亿", Double(model.playtimes) / 100000000)
            } else if model.playtimes > 10000 {
                tagString = String(format: "%.1f万", Double(model.playtimes) / 10000)
            } else {
                tagString = "\(model.playtimes)"
            }
            playCountLabel.text = tagString
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            let num:Int = (indexPath?.row)!
            numLabel.text = "\(num + 1)"
        }
    }
    
    func getMMSSFromSS(duration:Int)->(String){
        let str_minute = duration / 60
        let str_second = duration % 60
        let format_time = "\(str_minute):\(str_second)"
        return format_time
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
