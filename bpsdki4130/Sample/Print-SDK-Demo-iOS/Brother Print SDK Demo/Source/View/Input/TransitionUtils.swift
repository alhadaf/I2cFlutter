//
//  TransitionUtils.swift
//  Brother Print SDK Demo
//
//  Created by matsuo yu on 2024/04/02.
//

import Foundation
import UIKit

class TransitionUtils {
    static func showResult(viewController: UIViewController, string: String) {
        DispatchQueue.main.async {
            if let coordinator = viewController.navigationController?.transitionCoordinator {
                // during another transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showResult(viewController: viewController, string: string)
                }
            }
            else {
                let resultViewController = ResultViewController()
                resultViewController.dataSource.resultMessage = string
                viewController.navigationController?.pushViewController(resultViewController, animated: true)
            }
        }
    }
    
    static func launchInputIntListView(viewController: UIViewController, title: String, decisionCaption: String, rightButtonAction: @escaping (([Int])->Void)) {
        let getIntListViewController = GetIntListViewController(onReturnBlock:{(intList:[Int])->Void in
            DispatchQueue.global().async {
                rightButtonAction(intList)
            }
        }, titleName: title,decisionCaption: decisionCaption)
        viewController.navigationController?.pushViewController(getIntListViewController, animated: true)
    }
    
    private static var alerts = [UIAlertController]()
    private static var alertsAliveFlags = [UIAlertController:Bool]()
    private static var alertsDismissReserveFlags = [UIAlertController:Bool]()
    private static var alertsCount = 0
    static func showWaitingAlert(viewController: UIViewController) {
        DispatchQueue.main.async {
            objc_sync_enter(self)
            alertsCount += 1
            if alertsCount <= 0 {
                objc_sync_exit(self)
                return
            }
            let alertController = UIAlertController(title: NSLocalizedString("waiting", comment: ""), message: nil, preferredStyle: .alert)
            viewController.present(alertController, animated: true) {
                if (alertsDismissReserveFlags.keys.contains(alertController) && alertsDismissReserveFlags[alertController] == true) {
                    alertController.dismiss(animated: true)
                    alertsDismissReserveFlags.removeValue(forKey: alertController)
                    _ = alerts.popLast()
                }
                else {
                    alertsAliveFlags[alertController] = true
                }
            }
            
            alerts.append(alertController)
            objc_sync_exit(self)
        }
    }
    static func dismissWaitingAlert() {
        DispatchQueue.main.async {
            objc_sync_enter(self)
            alertsCount -= 1
            if alertsCount < 0 {
                objc_sync_exit(self)
                return
            }
            
            guard let alertController = alerts.last else {
                objc_sync_exit(self)
                return
            }

            if (alertsAliveFlags.keys.contains(alertController) && alertsAliveFlags[alertController] == true) {
                alertController.dismiss(animated: true)
                alertsAliveFlags.removeValue(forKey: alertController)
                _ = alerts.popLast()
            }
            else {
                alertsDismissReserveFlags[alertController] = true
            }
            
            objc_sync_exit(self)
        }
    }
}
