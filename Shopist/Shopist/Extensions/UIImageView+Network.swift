/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import UIKit
import ShopistNetworking

internal extension UIImageView {
    private static var cancellationTokenKey: UInt8 = 0
    private var cancellationToken: RequestCancellationToken? {
        get {
            return objc_getAssociatedObject(self, &Self.cancellationTokenKey) as? RequestCancellationToken
        }
        set {
            objc_setAssociatedObject(self, &Self.cancellationTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(with url: URL) {
        cancellationToken = api.getImageData(with: url) { [weak self] imageData in
            guard let image = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
