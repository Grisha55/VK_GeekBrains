//
//  NewsViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var likes = 155
    var comments = 26
    var shares = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 450
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCellTwo")
    }

}

extension NewsViewController: UITableViewDelegate {}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell()}
            
            cell.configure(imageForPhoto: UIImage(named: "винни1"), labelForImage: "Василий Пупкин", bigText: "Hello my name is Krosh .kljfdklfkkfkdsflkdklfjaklsdjfskladjsklfjkajsdfweiropqwioikjgfkldskfweirowqithjifl;adskflksl;fksloikopioprewio21231fg354g564r5ger454g5reg5r541r54tg56er4grte45rer5e46er456r4554terwe14gteqrw5647t84t5644rew5464q658rt454fg4545r45645445erw45rew45r64rt5erw54", bigImage: UIImage(named: "крош"), secondBigImage: UIImage(named: "крош2"))
            cell.delegate = self
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellTwo", for: indexPath) as? NewsCell else { return UITableViewCell() }
        
        cell.configure(name: "Мишки в сосновом бору", photo: UIImage(named: "мишки"))
        
       return cell
    }
    
}

extension NewsViewController: NewsTableViewCellDelegate {
    
    func likesAction(sender: UIButton, label: UILabel) {
        if sender.titleLabel?.text == "🤍" {
            sender.setTitle("❤️", for: .normal)
            likes += 1
            label.text = String(likes)
        } else {
            sender.setTitle("🤍", for: .normal)
            likes -= 1
            label.text = String(likes)
        }
    }
    
    func commentsAction(label: UILabel) {
        comments += 1
        label.text = String(comments)
    }
    
    func shareAction(label: UILabel) {
        shares += 1
        label.text = String(shares)
    }
    
}
