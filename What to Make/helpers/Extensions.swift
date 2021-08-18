//
//  Extensions.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
}

extension CATransition {

//New viewController will appear from bottom of screen.
func segueFromBottom() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromTop
    return self
}
//New viewController will appear from top of screen.
func segueFromTop() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromBottom
    return self
}
 //New viewController will appear from left side of screen.
func segueFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromLeft
    return self
}
//New viewController will pop from right side of screen.
func popFromRight() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromRight
    return self
}
//New viewController will appear from left side of screen.
func popFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromLeft
    return self
   }
}


extension UIView {
    func setupGradient(height: CGFloat, topColor: CGColor, bottomColor: CGColor) ->  CAGradientLayer {
         let gradient: CAGradientLayer = CAGradientLayer()
         gradient.colors = [topColor,bottomColor]
         gradient.locations = [0.0 , 1.0]
         gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
         gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
         gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: height)
         return gradient
    }
}

extension UITabBarController {
    func setTabBar( hidden: Bool, animated: Bool = true, along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
        guard isTabBarHidden != hidden else { return }

        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc: UIViewController? = viewControllers?[selectedIndex]
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY

        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }

        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }

        guard animated else {
            tabBar.frame = endFrame
            return
        }

        // Perform animation with coordinato if one is given. Update safe area insets _after_ the animation is complete,
        // if we're showing the tab bar.
        weak var tabBarRef = self.tabBar
        if let tc = transitionCoordinator {
            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        }
    }

    /// `true` if the tab bar is currently hidden.
    var isTabBarHidden: Bool {
        return !tabBar.frame.intersects(view.frame)
    }
}
