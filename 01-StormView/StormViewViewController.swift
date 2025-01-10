//
//  StormViewViewController.swift
//  01-StormView
//
//  Created by Igor Cotrim on 16/12/24.
//

import UIKit

class StormViewViewController: UITableViewController {
    private var pictures = [String]()
    private let defaults = UserDefaults.standard
    private let clickCountKey = "pictureClickCounts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        
        // Começamos o carregamento imediatamente em uma thread background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Todas as operações de arquivo acontecem aqui na thread background
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            // Criamos um array temporário para armazenar as imagens encontradas
            var tempPictures: [String] = []
            
            // Processamos os arquivos na thread background
            for item in items.sorted() {
                if item.hasPrefix("nssl") {
                    tempPictures.append(item)
                }
            }
            
            // Voltamos para a main thread para atualizar a UI
            DispatchQueue.main.async {
                // Usamos self? porque estamos em um closure com [weak self]
                self?.pictures = tempPictures
                // Recarregamos a tableView depois que as imagens foram carregadas
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getClickCount(for picture: String) -> Int {
        let counts = defaults.dictionary(forKey: clickCountKey) as? [String: Int] ?? [:]
        return counts[picture] ?? 0
    }
    
    private func incrementClickCount(for picture: String) {
        var counts = defaults.dictionary(forKey: clickCountKey) as? [String: Int] ?? [:]
        counts[picture] = (counts[picture] ?? 0) + 1
        defaults.set(counts, forKey: clickCountKey)
    }
    
    @objc private func shareTapped() {
        guard let appURL = URL(string: "https://stormviewer.app") else { return }
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }
}

// MARK: - TableView
extension StormViewViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        let clickCount = getClickCount(for: picture)
        cell.textLabel?.text = picture
        cell.detailTextLabel?.text = "Visualizado \(clickCount) vez\(clickCount == 1 ? "" : "es")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? StormViewDetailViewController {
            let picture = pictures[indexPath.row]
            incrementClickCount(for: picture)
            tableView.reloadRows(at: [indexPath], with: .none)
            
            viewController.selectedImage = pictures[indexPath.row]
            viewController.currentImageIndex = indexPath.row + 1
            viewController.totalOfImages = pictures.count
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

