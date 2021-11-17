//
//  UITableViewExtensions.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

extension UITableView {
    func register<Cell: UITableViewCell>(_: Cell.Type) where Cell: ReuseIdentifiable {
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }

    func register<View: UITableViewHeaderFooterView>(_: View.Type) where View: ReuseIdentifiable {
        register(View.self, forHeaderFooterViewReuseIdentifier: View.identifier)
    }

    func dequeue<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell where Cell: ReuseIdentifiable {
        if let cell = dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell {
            return cell
        } else {
            fatalError("Could not cast value of type 'UITableViewCell' to '\(String(describing: Cell.self))'")
        }
    }

    func dequeue<View: UITableViewHeaderFooterView>() -> View where View: ReuseIdentifiable {
        if let view = dequeueReusableHeaderFooterView(withIdentifier: View.identifier) as? View {
            return view
        } else {
            let viewName = String(describing: View.self)
            fatalError("Could not cast value of type 'UITableViewHeaderFooterView' to '\(viewName)'")
        }
    }
}

