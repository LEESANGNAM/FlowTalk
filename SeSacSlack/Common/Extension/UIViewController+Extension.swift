//
//  UIViewController+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/26/24.
//

import UIKit


extension UIViewController {
    func showCustomAlert(titleText: String, messageText: String, okTitle: String, okAction: @escaping () -> Void) {
        let vc = CustomAlertViewController(type: .onlyOk, titleText: titleText, messageText: messageText, okTitle: okTitle, okAction: okAction)
            
           present(vc, animated: true)
       }

       func showCustomAlert(titleText: String, messageText: String, okTitle: String, cancelTitle: String, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
           let vc = CustomAlertViewController(type: .CancelOk, titleText: titleText, messageText: messageText, okTitle: okTitle, cancelTitle: cancelTitle, okAction: okAction, cancelAction: cancelAction)
           present(vc, animated: true)
       }
}
