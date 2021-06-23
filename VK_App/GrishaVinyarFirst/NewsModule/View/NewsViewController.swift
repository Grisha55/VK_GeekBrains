//
//  NewsViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit

protocol NewsView {
    func onItemsRetrieval(news: [News])
}

class NewsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var news = [News]()
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
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellTwo", for: indexPath) as? NewsCell else { return UITableViewCell() }
        
        guard let attachments = news[indexPath.row].attachments else { return UITableViewCell() }
        let photoImageView = UIImageView()
        
        attachments.forEach { new in
            guard let photoStr = new.photo else { return }
            guard let url = URL(string: photoStr.photo75 ?? "") else { return }
            photoImageView.sd_setImage(with: url, completed: .none)
            cell.configure(name: new.type ?? "N/A", photo: photoImageView.image)
            
        }
        
        return cell
        
    }
    
}

