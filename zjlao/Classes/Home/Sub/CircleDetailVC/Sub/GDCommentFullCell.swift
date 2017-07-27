//
//  GDCommentFullCell.swift
//  zjlao
//
//  Created by WY on 20/04/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//评论视图

import UIKit

class GDCommentFullCell: UITableViewCell {

    
    let commentLogo = UIButton()
    let commentIcon = UIImageView()
    let nameLable = UILabel()
    let commentContent = UILabel()
    
    var model : GDFullMediaComment? {
        willSet{
            self.nameLable.text = newValue?.comment_user_name
            self.commentContent.text = newValue?.content
            self.commentIcon.sd_setImage(with: URL(string: newValue?.comment_user_avatar ?? ""))
            self.layoutIfNeeded()
            self.setNeedsDisplay()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupsubviews()
    }
    func setupsubviews()  {
        
        self.contentView.addSubview(commentLogo)
        self.contentView.addSubview(commentIcon)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(commentContent)
        self.commentContent.numberOfLines = 100
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        self.commentLogo.frame = CGRect(x: 0, y: 0, width: 40, height: 40 )
        self.commentIcon.frame = CGRect(x: self.commentLogo.frame.maxX, y: margin, width: 64, height: 64 )
        self.nameLable.frame = CGRect(x: self.commentIcon.frame.maxX + 10, y: self.commentIcon.frame.minY, width: 200, height: 20 )
        let fetureSize = self.model?.content?.sizeWith(font: self.commentContent.font, maxSize: CGSize(width: SCREENWIDTH - self.nameLable.frame.minX - margin - margin * 2, height: 888))
        
        self.commentContent.frame = CGRect(x: self.nameLable.frame.minX , y: self.nameLable.frame.maxY + margin / 2 , width: fetureSize?.width ?? 0, height: fetureSize?.height  ?? 0)
        
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
