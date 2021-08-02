//
//  NewsViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit
import SDWebImage

protocol NewsView {
    func onItemsRetrieval(news: [NewsModel])
}

class NewsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var news = [NewsModel]()
    private var profiles = [ProfileNews]()
    private var newsPresenter: NewsPresenter?
    private var refreshControll = UIRefreshControl()
    private var nextFrom = ""
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControll()
        
        newsPresenter = NewsPresenter(view: self)
        newsPresenter?.viewDidLoad(tableView: tableView)
        
        tableView.rowHeight = 300
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCellTwo")
        tableView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellReuseIdentifier: "authorCell")
        tableView.register(UINib(nibName: "LikesAndCommentsCell", bundle: nil), forCellReuseIdentifier: "likesAndCommentsCell")
    }
    
    //MARK: - Methods
    
    private func setupRefreshControll() {
        self.tableView.refreshControl = self.refreshControll
        refreshControll.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControll.tintColor = .systemGreen
        refreshControll.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc private func refreshNews() {
        
        self.refreshControll.beginRefreshing()
        
        let mostFreshNewsData = self.news.first?.date ?? Date().timeIntervalSince1970
        
        NetworkingService().getNewsfeed(startTime: String(mostFreshNewsData + 1.0)) { [weak self] news,_ ,_, _  in
            guard let self = self else { return }
            
            self.refreshControll.endRefreshing()
            
            guard let news = news, news.count > 0 else { return }
            
            self.news = news + self.news
            
            let indexSet = IndexSet(integersIn: 0 ..< news.count)
            
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }
}

// MARK: - NewsView
extension NewsViewController: NewsView {
    func onItemsRetrieval(news: [NewsModel]) {
        self.news = news
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension NewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        
        if maxSection > news.count - 3, !isLoading {
            isLoading = true
            
            NetworkingService().getNewsfeed(startTime: nextFrom) { [weak self] news, profiles, nextFrom, error  in
                guard let self = self, let news = news else { return }
                
                let indexSet = IndexSet(integersIn: self.news.count ..< self.news.count + news.count)
                self.news.append(contentsOf: news)
                
                self.tableView.insertSections(indexSet, with: .automatic)
                
                self.isLoading = false
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = news[indexPath.section]
        
        switch indexPath.row {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
            
            cell.configure(bigText: news.text)
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellTwo", for: indexPath) as? NewsCell else { return UITableViewCell() }
            
            guard let url = URL(string: news.photosURL?.first ?? "") else { return UITableViewCell() }
            
            cell.configure(photoURL: url)
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath) as? AuthorCell else { return UITableViewCell() }
            
            guard let url = URL(string: news.avatarURL ?? "") else { return UITableViewCell() }
            
            cell.configureAuthorCell(authorImageURL: url, data: "1.05.1990")
            
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "likesAndCommentsCell", for: indexPath) as? LikesAndCommentsCell else { return UITableViewCell() }
            
            cell.configureCell(likesCount: news.likes.count, commentsCount: news.comments.count)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}

