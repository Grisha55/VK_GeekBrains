//
//  NewsViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit

protocol NewsView {
    func onItemsRetrieval(news: [News])
    func getProfiles(profiles: [Profile])
}

class NewsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var news = [News]()
    private var profiles = [Profile]()
    private var newsPresenter: NewsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsPresenter = NewsPresenter(view: self)
        newsPresenter?.viewDidLoad(tableView: tableView)
        
        tableView.rowHeight = 450
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCellTwo")
    }

}

extension NewsViewController: NewsView {
    func onItemsRetrieval(news: [News]) {
        self.news = news
        tableView.reloadData()
    }
    
    func getProfiles(profiles: [Profile]) {
        self.profiles = profiles
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        
        let news = news[indexPath.row]
        let profile = profiles[indexPath.row]
        
        let imageView = UIImageView()
        let profileImageView = UIImageView()
        
        let attachments = news.attachments
        
        attachments?.forEach({ attachment in
            attachment.photo?.sizes?.forEach({ size in
                imageView.sd_setImage(with: URL(string: size.url ?? ""), completed: .none)
                //profileImageView.sd_setImage(with: URL(string: attachment.photo?.photo75 ?? ""), completed: .none)
            })
        })
        
        profileImageView.sd_setImage(with: URL(string: profile.photo ?? ""), completed: .none)
        
        var text = ""
        if news.sourceName == "" {
            text = "Not found"
        } else {
            text = news.text ?? ""
        }
        
        cell.configure(imageForPhoto: profileImageView.image, labelForImage: text, bigText: text, bigImage: imageView.image, secondBigImage: imageView.image)
        cell.labelToLikes.text = "\(news.likes?.count ?? 0)"
        cell.labelToComments.text = "\(news.comments?.count ?? 0)"
        cell.labelToShare.text = "\(news.reposts?.count ?? 0)"
        
        return cell
        
    }
    
}

