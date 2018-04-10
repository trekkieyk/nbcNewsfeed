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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func populate(newsItem: NewsSectionItem, withMedia: Bool) {
        guard let videoItem = newsItem as? NewsVideo else {
            return
        }
        if let player = videoItem.videoPlayer {
            videoView.configure(player: player)
        }
        let hasVideo: Bool = (videoView.player?.status ?? .failed) != AVPlayerStatus.failed
        super.populate(newsItem: newsItem, withMedia: withMedia || hasVideo)
        if hasVideo {
            videoView.play()
            videoView.isHidden = false
        } else {
            videoView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.unconfigure()
    }
}
