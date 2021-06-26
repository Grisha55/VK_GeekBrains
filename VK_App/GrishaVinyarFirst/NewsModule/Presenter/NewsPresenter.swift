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
    
    private var news: [News]?
    private var view: NewsView
    
    required init(view: NewsView) {
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        loadNewsFromServer()
    }
    
    private func loadNewsFromServer() {
        NetworkingService().getNewsfeed { [weak self] news, groups, profiles in
            guard let self = self else { return }
            self.view.onItemsRetrieval(news: news)
            self.view.getProfiles(profiles: profiles)
        }
        
    }
}
