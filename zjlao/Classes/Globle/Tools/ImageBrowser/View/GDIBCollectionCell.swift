//
//  GDIBCollectionCell.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
class GDIBCollectionCell: UICollectionViewCell {
    let scrollView  = GDIBScrollView()
    let videoIcon = UIImageView(image: UIImage(named : "VideoOverlayPlay"))
    var avPlayerVC : AVPlayerViewController?
    var player : MPMoviePlayerController?
    var photo : GDIBPhoto?{
//        willSet{
//                scrollView.photo = newValue
//        }
        didSet{
                scrollView.photo = photo
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.configScrollView()
        self.configVideoIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        scrollView.prepareForReuse()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.photo?.isVideo ?? false  {
            self.videoIcon.isHidden = false
            self.scrollView.isHidden = true
            self.videoIcon.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }else{
            self.videoIcon.isHidden = true
            self.scrollView.isHidden = false
        }
    }
    func creatMoviePlayer(urlStr:String)  {
        if let url = URL.init(string:urlStr ) {
            let player = MPMoviePlayerController.init(contentURL:url)
            self.player = player
            player?.controlStyle = MPMovieControlStyle.embedded
            player?.view.frame = self.bounds
            
            player?.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight , UIViewAutoresizing.flexibleWidth]
            self.addSubview(player?.view ?? UIView())
//            player?.shouldAutoplay  = false
            player?.play()
            player?.pause()
            
        }
    }

}


extension GDIBCollectionCell {
    func configScrollView ()  {
        self.addSubview(scrollView)
        scrollView.frame = self.bounds
    }
    func configVideoIcon()   {
        self.addSubview(videoIcon)
        videoIcon.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        videoIcon.isUserInteractionEnabled = true
    }
}
