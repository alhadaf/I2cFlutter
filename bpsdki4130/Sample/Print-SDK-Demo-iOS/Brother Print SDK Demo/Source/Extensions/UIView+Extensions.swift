//
//  UIView+Extensions.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/16.
//

import UIKit

extension UIView {
    /// 引数のViewを、現在のViewと同じサイズで追加する
    ///
    /// - Parameter view: 追加するView
    func addSubViewFull(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        // オートレイアウトの設定
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
