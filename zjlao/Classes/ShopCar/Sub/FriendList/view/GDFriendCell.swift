//
//  GDFriendCell.swift
//  zjlao
//
//  Created by WY on 2017/9/24.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDFriendCell: UITableViewCell {
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let backView = UIView()
    var model = GDFriendModel.init(dict: nil){
        didSet{
            if let url  = URL.init(string: model.avatar ?? "") {
                self.iconView.sd_setImage(with: url )
            }
            nameLabel.text = model.name
            timeLabel.text = model.create_at
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(backView)
        self.backView.addSubview(iconView)
        self.backView.addSubview(nameLabel)
        self.backView.addSubview(timeLabel)
        backView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        nameLabel.textColor = UIColor.lightGray
        timeLabel.textColor = UIColor.lightGray

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat  = 10
        backView.frame = CGRect(x: margin, y: margin/2, width: self.bounds.width - margin * 2 , height: self.bounds.height - margin )
        self.iconView.frame = CGRect(x : margin  , y : margin , width : backView.bounds.height - margin * 2 , height : backView.bounds.height - margin * 2 )
        self.nameLabel.frame = CGRect(x : iconView.frame.maxX + margin , y : iconView.frame.minY , width : backView.bounds.width - iconView.frame.maxX - margin * 2  , height : iconView.frame.width/2)
        self.timeLabel.frame = CGRect(x : iconView.frame.maxX + margin , y : iconView.frame.midY , width : backView.bounds.width - iconView.frame.maxX - margin * 2  , height : iconView.frame.width/2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
