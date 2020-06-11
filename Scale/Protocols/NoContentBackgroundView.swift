//
//  NoContentBackgroundView.swift
//  Scale
//
//  Created by mani on 2020-05-02.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

protocol NoContentBackgroundView where Self: UIViewController {
    var tableView: UITableView! { get set }
    var backgroundView: DTTableBackgroundView { get }
    func showBackgroundView()
    func hideBackgroundView()
}

extension NoContentBackgroundView {
    func showBackgroundView() {
        tableView.separatorStyle = .none
        self.tableView.backgroundView?.isHidden = false
    }
    
    func hideBackgroundView() {
        tableView.separatorStyle = .singleLine
        self.tableView.backgroundView?.isHidden = true
    }
}
