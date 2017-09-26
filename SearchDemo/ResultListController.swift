//
//  ResultListController.swift
//  SearchDemo
//
//  Created by Patrick Lin on 26/09/2017.
//  Copyright © 2017 Soocii. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RxCocoa
import RxSwift

class ResultListController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var results: [ResultItem] = []
    
    @IBOutlet var searchBar: UISearchBar!

    // MARK: Table Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultItemCell", for: indexPath) as! ResultItemCell
        
        let item = self.results[indexPath.row]
        
        if let url = item.artworkUrl60, let imageUrl = URL(string: url) {
            
            cell.iconView.kf.setImage(with: imageUrl)
            
        }
        
        cell.appTitle.text = item.trackName
        
        cell.appTags.text = item.genres?.reduce("") { $0 + (($0 != "") ? ", " : "") + $1 }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.results[indexPath.row]
        
        if let url = item.trackViewUrl, let appUrl = URL(string: url) {
            
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            
        }
        
    }
    
    // MARK: Init Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView
        .rx.didScroll
        .throttle(0.5, scheduler: MainScheduler.instance)
        .subscribe(onNext: { _ in
            
            self.view.endEditing(false)
            
        }).addDisposableTo(self.disposeBag)
        
        self.searchBar
        .rx.text
        .orEmpty
        .throttle(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .subscribe(onNext: { (searchText: String) in
          
            guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            Alamofire.request("https://itunes.apple.com/search?term=\(searchText)&limit=20&entity=software&country=tw").responseJSON { (result: DataResponse<Any>) in
                
                if let json = result.value as? [String: Any], let results = json["results"] as? [[String: Any]] {
                    
                    print(results.count)
                    
                    var new_results = [ResultItem]()
                    
                    for (_, jsonItem) in results.enumerated() {
                        
                        if let resultItem = ResultItem(JSON: jsonItem) { new_results.append(resultItem) }
                        
                    }
                    
                    self.results = new_results
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }).addDisposableTo(self.disposeBag)

    }

}

extension ResultListController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
    }
    
}
