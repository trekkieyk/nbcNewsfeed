//
//  NewsVideo.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/9/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreData
import AVFoundation

class NewsVideo: NewsSectionItem {
    
    @NSManaged private(set) var duration: String
    @NSManaged private(set) var previewURL: URL
    private(set) var videoAsset: AVAsset?
    private(set) var videoPlayerItem: AVPlayerItem?
    private(set) var videoPlayer: AVPlayer?
    private(set) var videoHeightToWidth: CGFloat?
    
    override var type: NewsItemType {
        return .video
    }
    
    override var mediaHeightToWidth: CGFloat? {
        return videoHeightToWidth ?? imageHeightToWidth
    }
    
    override class var entityName: String {
        return "NewsVideoEntity"
    }
    
    override func fatalErrorIfBase() {}
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        fetchPreview()
    }
    
    init(id: String, teaseURL: URL, teaseImageData: Data? = nil, entity: NSEntityDescription? = nil, headline: String, published: Date, url: URL, summary: String, breakingLabel: String? = nil, duration: String, previewURL: URL) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsVideo.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: teaseURL, teaseImageData: teaseImageData, entity: entityToUse, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
        self.duration = duration
        self.previewURL = previewURL
        fetchPreview()
    }
    
    func updateFromNetwork(teaseURL: URL, headline: String, published: Date, url: URL, summary: String, breakingLabel: String?, duration: String, previewURL: URL) {
        updateFromNetwork(teaseURL: teaseURL, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
        self.duration = duration
        if self.previewURL != previewURL {
            self.previewURL = previewURL
            videoAsset = nil
            fetchPreview()
        }
    }
    
    private func fetchPreview() {
        guard videoAsset == nil else {
            createPlayer(asset: videoAsset!)
            return
        }
        NetworkHandler.fetchVideo(url: previewURL) { [weak self] (asset) in
            self?.videoAsset = asset
            self?.createPlayer(asset: asset)
        }
    }
    
    private func createPlayer(asset: AVAsset) {
        let playerItem = AVPlayerItem(asset: asset)
        videoPlayerItem = playerItem
        let player = AVPlayer(playerItem: playerItem)
        videoPlayer = player
        guard playerItem.presentationSize.width != 0.0 else {
            return
        }
        videoHeightToWidth = playerItem.presentationSize.height / playerItem.presentationSize.width
    }
}
