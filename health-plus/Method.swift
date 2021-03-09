//
//  Method.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/09.
//

import Foundation
import UIKit

class Method: UIViewController {
    class func empty(_ str: String?) -> Bool {
        if str == nil {
            return true
        } else if str!.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    class func keyFromNowDate() -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let nowMixString = f.string(from: now)
        let nowSplitNum = (nowMixString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)).joined()
        return nowSplitNum
    }
}

class Alert: UIAlertController {
    class func show(title: String, content: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            viewController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
