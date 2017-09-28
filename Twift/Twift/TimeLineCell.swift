//
//  TimeLineCell.swift
//  Twift
//
//  Created by 豊川廉 on 2017/07/18.
//  Copyright © 2017年 Raptor Inc. All rights reserved.
//

import Foundation
import UIKit

class TimeLineCell: UITableViewCell {
    var accountIconView: UIImageView!
    var accountName: UILabel!
    var tweet: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // SelectShopFieldを配置する
        self.installationLabel()
    }
    
    private func installationLabel(){
        labelInitialize()
        imageViewInitialize()
        
        contentView.addSubview(accountIconView)
        contentView.addSubview(accountName)
        contentView.addSubview(tweet)
    }
    
    private func labelInitialize(){
        accountName = UILabel()
        accountName.textAlignment = .justified
        tweet = UILabel()
        tweet.textAlignment = .justified
        tweet.numberOfLines = 0
    }
    private func imageViewInitialize(){
        accountIconView = UIImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountIconView.frame = CGRect(x: (frame.width / 10) * 2 , y: 10, width: (frame.width / 10) * 2.5, height: frame.height)
//        accountName.frame = CGRect(x: 110, y: 0, width: frame.width, height: frame.height)
//        tweet.frame = CGRect(x: (frame.width / 10) * 2 , y: 10, width: (frame.width / 10) * 7.5, height: frame.height)
    }

}
