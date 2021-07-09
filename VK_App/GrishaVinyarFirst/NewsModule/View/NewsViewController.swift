//
//  NewsViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit

protocol NewsView {
    func onItemsRetrieval(news: [NewsModel])
}

class NewsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var news = [NewsModel]()
    private var newsPresenter: NewsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsPresenter = NewsPresenter(view: self)
        newsPresenter?.viewDidLoad(tableView: tableView)
        
        tableView.rowHeight = 150
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCellTwo")
        tableView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellReuseIdentifier: "authorCell")
        tableView.register(UINib(nibName: "LikesAndCommentsCell", bundle: nil), forCellReuseIdentifier: "likesAndCommentsCell")
    }

}

extension NewsViewController: NewsView {
    func onItemsRetrieval(news: [NewsModel]) {
        self.news = news
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let news = news[indexPath.row]
        //let profile = profiles[indexPath.row]
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
            
            cell.configure(bigText: "At the next lesson there will be data of news from server, but now it is not")
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellTwo", for: indexPath) as? NewsCell else { return UITableViewCell() }
            
            cell.configure(photo: UIImage(named: "еда"))
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath) as? AuthorCell else { return UITableViewCell() }
            
            cell.configureAuthorCell(authorImage: UIImage(systemName: "person") ?? UIImage(), data: "1.05.1990")
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "likesAndCommentsCell", for: indexPath) as? LikesAndCommentsCell else { return UITableViewCell() }
            
            cell.configureCell(likesCount: 999, commentsCount: 100)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}

