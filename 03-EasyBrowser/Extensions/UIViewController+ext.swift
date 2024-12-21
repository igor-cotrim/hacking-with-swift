//
//  UIViewController+ext.swift
//  03-EasyBrowser
//
//  Created by Igor Cotrim on 20/12/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}
