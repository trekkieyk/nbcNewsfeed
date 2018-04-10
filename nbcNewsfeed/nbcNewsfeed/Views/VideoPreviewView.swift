//
//  VideoPreviewView.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/10/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import AVKit

class VideoPreviewView: UIView {
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(url: URL) {
        player = AVPlayer(url: url)
        player?.isMuted = true
        configureLayer()
    }
    
    func configure(item: AVPlayerItem) {
        player = AVPlayer(playerItem: item)
        player?.isMuted = true
        configureLayer()
    }
    
    func configure(player: AVPlayer) {
        self.player = player
        player.isMuted = true
        configureLayer()
    }
    
    private func configureLayer() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachEndOfVideo(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    func unconfigure() {
        pause()
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
        playerLayer = nil
        player = nil
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
        if let time = player?.currentTime() {
            player?.currentItem?.seek(to: time, completionHandler: nil)
        }
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
    }
    
    @objc func reachEndOfVideo(_ notification: Notification) {
        if isLoop {
            stop()
            player?.play()
        }
    }
}
