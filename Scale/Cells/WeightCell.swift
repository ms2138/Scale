//
//  WeightCell.swift
//  Scale
//
//  Created by mani on 2020-06-07.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class WeightCell: UITableViewCell {
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [percentageLabel, numberOfDaysLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        return stackView
    }()
    private(set) lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)

        return label
    }()
    private(set) lazy var numberOfDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.textColor = UIColor(red: 0.0/255.0,
                                  green: 51.0/255.0,
                                  blue: 51.0/255.0,
                                  alpha: 1.0)

        return label
    }()
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, weightLabel, horizontalStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        return stackView
    }()
    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)

        return label
    }()
    private(set) lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .systemBlue

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = self.contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
}
