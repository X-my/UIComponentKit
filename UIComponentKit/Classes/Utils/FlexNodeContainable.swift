//
//  FlexNodeContainable.swift
//  BizMoon
//
//  Created by xmy on 2023/12/21.
//

import UIKit

public protocol FlexNodeContainable {
    var flexNode: FlexNode? { get }
    var flexViewContainer: UIView { get }
    func buildFlexNode()
}

public extension FlexNodeContainable {
    func reloadFlexView() {
        buildFlexNode()
        guard var flexNode = flexNode else { return }
        flexViewContainer.subviews.forEach { $0.removeFromSuperview() }
        let flexView = flexNode.generateUIView()
        flexView.translatesAutoresizingMaskIntoConstraints = false
        flexViewContainer.addSubview(flexView)
        NSLayoutConstraint.activate([
            flexView.leadingAnchor.constraint(equalTo: flexViewContainer.leadingAnchor),
            flexView.trailingAnchor.constraint(equalTo: flexViewContainer.trailingAnchor),
            flexView.topAnchor.constraint(equalTo: flexViewContainer.topAnchor),
            flexView.bottomAnchor.constraint(equalTo: flexViewContainer.bottomAnchor),
            flexView.widthAnchor.constraint(equalToConstant: flexView.bounds.width),
            flexView.heightAnchor.constraint(equalToConstant: flexView.bounds.height)
        ])
    }
}

public extension FlexNodeContainable where Self: UIView {
    var flexViewContainer: UIView {
        self
    }
}

public extension FlexNodeContainable where Self: UIViewController {
    var flexViewContainer: UIView {
        view
    }
}

public extension FlexNodeContainable where Self: UITableViewCell {
    var flexViewContainer: UIView {
        contentView
    }
}

public extension FlexNodeContainable where Self: UICollectionViewCell {
    var flexViewContainer: UIView {
        contentView
    }
}

//extension FlexNodeContainable where Self: ScrollViewController {
//    var flexViewContainer: UIView {
//        contentView
//    }
//}
