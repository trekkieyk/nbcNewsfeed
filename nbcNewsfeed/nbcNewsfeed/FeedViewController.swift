//
//  ViewController.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var sections: [NewsSection] {
        return NewsItemFactory.shared.sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notifications.Factory.sectionsUpdated, object: nil)
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    private var showWithoutImage: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = self.sections
        guard indexPath.section < sections.count else {
            return UITableViewCell()
        }
        guard let newsItem = sections[indexPath.section].getItem(at: indexPath.row) else {
            return UITableViewCell()
        }
        var cell: SectionItemTableViewCell?
        if newsItem is NewsArticle {
            cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath) as? SectionItemTableViewCell
        }
        if newsItem is NewsVideo {
            cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.reuseIdentifier, for: indexPath) as? SectionItemTableViewCell
        }
        if newsItem is NewsSlideshow {
            cell = tableView.dequeueReusableCell(withIdentifier: SlideshowTableViewCell.reuseIdentifier, for: indexPath) as? SectionItemTableViewCell
        }
        cell?.populate(newsItem: newsItem, withMedia: !showWithoutImage.contains(indexPath))
        showWithoutImage.remove(indexPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let newsItem = newsItem(forIndexPath: indexPath) else {
            return 0
        }
        let hasImage = newsItem.teaseImage != nil || (newsItem as? NewsVideo)?.videoAsset != nil || !((newsItem as? NewsSlideshow)?.images.isEmpty ?? true)
        if hasImage {
            showWithoutImage.remove(indexPath)
        } else {
            showWithoutImage.insert(indexPath)
        }
        if newsItem is NewsArticle {
            return ArticleTableViewCell.heightForDetails(headline: newsItem.headline, summary: newsItem.summary, withImage: hasImage, imageHeightToWidth: newsItem.mediaHeightToWidth)
        }
        if newsItem is NewsVideo {
            return VideoTableViewCell.heightForDetails(headline: newsItem.headline, summary: newsItem.summary, withImage: hasImage, imageHeightToWidth: newsItem.mediaHeightToWidth)
        }
        if newsItem is NewsSlideshow {
            return SlideshowTableViewCell.heightForDetails(headline: newsItem.headline, summary: newsItem.summary, withImage: hasImage, imageHeightToWidth: newsItem.mediaHeightToWidth)
        }
        return 0
    }
    
    private func newsItem(forIndexPath indexPath: IndexPath) -> NewsSectionItem? {
        let sections = self.sections
        guard indexPath.section < sections.count else {
            return nil
        }
        return sections[indexPath.section].getItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.count <= section {
            return 0
        }
        return sections[section].itemCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsItem = newsItem(forIndexPath: indexPath) {
            UIApplication.shared.open(newsItem.url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        return sections[section].header
    }
}

