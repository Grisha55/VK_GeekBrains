//
//  NewsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.06.2021.
//

import UIKit

protocol NewsPresenterProtocol {
    init(view: NewsView)
    func viewDidLoad(tableView: UITableView)
}

class NewsPresenter: NewsPresenterProtocol {
    
    private var news: [NewsModel]?
    private var view: NewsView
    
    required init(view: NewsView) {
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        loadNewsFromServer()
    }
    
    private func loadNewsFromServer() {
        NetworkingService().getNewsfeed { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let news):
                self.view.onItemsRetrieval(news: news)
            }
            
        }
        
    }
}
