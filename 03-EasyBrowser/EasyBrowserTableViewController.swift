//
//  EasyBrowserTableViewController.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import UIKit

class EasyBrowserTableViewController: UITableViewController {
    var websites: [String] = [
        "Google",
        "Github",
        "Stackoverflow",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Easy Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - TableView
extension EasyBrowserTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Webview", for: indexPath)
        let website = websites[indexPath.row]
        cell.textLabel?.text = website
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Webview") as? EasyBrowserViewController {
            viewController.selectedWebsite = websites[indexPath.row]
//            viewController.currentImageIndex = indexPath.row + 1
//            viewController.totalOfImages = pictures.count
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
