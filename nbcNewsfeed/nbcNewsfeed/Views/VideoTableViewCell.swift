//
//  VideoTableViewCell.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/9/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import UIKit
import AVFoundation.AVPlayer

class VideoTableViewCell: SectionItemTableViewCell {
    static let reuseIdentifier: String = "videoCell"
    
    @IBOutlet weak var videoView: VideoPreviewView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(newsItem: NewsSectionItem, withMedia: Bool) {
        guard let videoItem = newsItem as? NewsVideo else {
            return
        }
        if let player = videoItem.videoPlayer {
            videoView.configure(player: player)
        }
        let hasVideo: Bool = (videoView.player?.currentItem?.status ?? .failed) != AVPlayerItemStatus.failed && withMedia
        super.populate(newsItem: newsItem, withMedia: withMedia)
        if hasVideo {
            videoView.play()
            videoView.alpha = 0
            videoView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.videoView.alpha = 1
            })
        } else {
            videoView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.unconfigure()
        videoView.isHidden = true
    }
}
