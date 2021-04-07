//
//  DetailTableViewCellViewController.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 14/03/21.
//

import UIKit

class DetailTableViewCellViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil) , forCellReuseIdentifier: "detailTableviewCell")
    }

}

extension DetailTableViewCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailTableviewCell") as! DetailTableViewCell
        cell.setTableviewCell(post: post)
        return cell
    }
    
    
}
