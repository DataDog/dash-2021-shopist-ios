/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import UIKit

internal final class Cell: UICollectionViewCell {
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    func setImage(url: URL) {
        imageView.setImage(with: url)
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    private let labelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.opacity = 0.35
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.cover(contentView)
        contentView.addSubview(labelBackground)
        label.center(in: contentView)
        labelBackground.keepSize(of: label, paddign: 12)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
