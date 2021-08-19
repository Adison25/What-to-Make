//
//  dynamicColor.swift
//  What to Make
//
//  Created by Adison Emerick on 7/25/21.
//

import UIKit

//ill edit these later

let dynamicColorText = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    switch traitCollection.userInterfaceStyle {
    case
      .unspecified,
      .light: return .black
    case .dark: return .white
    @unknown default:
        fatalError("unkown default")
    }
}
let dynamicColorBackground = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    switch traitCollection.userInterfaceStyle {
    case
      .unspecified,
        .light: return .white//return UIColor(red: 0.94, green: 0.92, blue: 0.80, alpha: 1.00)
    case .dark: return .black
    @unknown default:
        fatalError("unkown default")
    }
}
let dynamicColorTextLink = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    switch traitCollection.userInterfaceStyle {
    case
      .unspecified,
        .light: return UIColor(red: 0.09, green: 0.35, blue: 0.86, alpha: 1.00)
    case .dark: return UIColor(red: 0.09, green: 0.35, blue: 0.86, alpha: 1.00)
    @unknown default:
        fatalError("unkown default")
    }
}
