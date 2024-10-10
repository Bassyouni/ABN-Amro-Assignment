//
//  UIApplicationURLOpener.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import UIKit

extension UIApplication: URLOpener {
    public func open(_ url: URL) {
        self.open(url, options: [:], completionHandler: nil)
    }
}
