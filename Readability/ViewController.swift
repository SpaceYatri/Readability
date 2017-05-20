//
//  ViewController.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchListTableView: UITableView!
    //let fetchManager: FetchManager = FetchManager()
    var resultList:[Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.separatorStyle = .none
        self.searchListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let searchString = searchField.text else {
            return;
        }
        FetchManager.getDataFor(searchString.replacingOccurrences(of: " ", with: "%20")) {
            [unowned self] (resultList: [Result]) in
            self.resultList = resultList
            self.searchListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell {
            cell.create(resultList[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 56, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "AvenirNext-Regular", size: 13)
        label.text = resultList[indexPath.row].headline
        label.sizeToFit()
        return label.frame.height + 75 > 95 ? label.frame.height + 75 : 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let link = resultList[indexPath.row].link else {
            return
        }
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

