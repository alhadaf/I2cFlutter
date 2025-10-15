//
//  CommonAlertUtil.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import Foundation
import UIKit

class CommonAlertUtil {
    static func editAlert(
        title: String,
        message: String,
        keyboardType: UIKeyboardType,
        delegate: UITextFieldDelegate?,
        callback: @escaping (String) -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) -> Void in
            textField.keyboardType = keyboardType
            textField.text = message
            if delegate != nil {
                textField.delegate = delegate
            }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
            let text = alertController.textFields?.first
            callback(text?.text ?? message)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }

    static func waitingAlert(cancelCallback: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("waiting", comment: ""),
                                                message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in
            cancelCallback()
        })
        alertController.addAction(cancelAction)
        return alertController
    }

    static func cancelingAlert() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("canceling", comment: ""),
                                                message: nil, preferredStyle: .alert)
        return alertController
    }

    static func connectPrinterAlert() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("select_printer_message", comment: ""),
                                                message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }

    static func showSearchingAlert(callback: @escaping() -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("searching", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {_ in
            callback()
        })
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        alertController.view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        alertController.addAction(cancelAction)
        return alertController
    }
}
