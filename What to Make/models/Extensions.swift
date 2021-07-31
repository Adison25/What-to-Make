//
//  Extensions.swift
//  DismissTabBarDemo
//
//  Created by Diego Bustamante on 7/15/20.
//  Copyright © 2020 Diego Bustamante. All rights reserved.
//

import UIKit

extension UIViewController {
    //for the upper title
    func setupClearNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: dynamicColorText]
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


func fetchData() -> [PhotoModel]{
    return [
        PhotoModel(title: "Cupcake",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal1"),
        PhotoModel(title: "File me yon with a spec of Rosemary",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt."],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal2"),
        PhotoModel(title: "Dinner3",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal3"),
        PhotoModel(title: "Dinner4",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal4"),
        PhotoModel(title: "Dinner5",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal5"),
        PhotoModel(title: "Dinner6",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal6"),
        PhotoModel(title: "Dinner7",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal7"),
        PhotoModel(title: "Dinner8",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal8"),
        PhotoModel(title: "Dinner9",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal9"),
        PhotoModel(title: "Dinner10",
                   ingredients: ["5 ounces white chocolate (finely chopped)",
                                                                    "1 1/4 cups unbleached all purpose flour",
                                                                    "1/4 cup cake flour (preferably unbleached)",
                                                                    "1 teaspoon baking powder",
                                                                    "1/2 teaspoon salt",
                                                                    "1 cup whole milk",
                                                                    "1 tablespoon vanilla extract",
                                                                    "2/3 cup granulated sugar",
                                                                    "4 tablespoons salted butter (at room temperature)",
                                                                    "2 large eggs (at room temperature)",
                                                                    "3/4 cup raspberry jam (or other gooey filling, optional)",
                                                                    "cream cheese frosting"],
                   directions: ["Preheat the oven to 350°F (176°C). Position an oven rack in the center position and line a pan of twelve 3-by-1 1/2-inch muffin cups with paper liners.",
                                "In a heatproof bowl, dump the chocolate. Bring a wide saucepan of water to a simmer over medium heat. Turn off the heat and place the bowl in the hot water. Let it stand, stirring occasionally, until the chocolate is completely melted and smooth. Be careful not to let any water get in the bowl or the chocolate will seize and clump. Remove the bowl from the water and let cool until tepid",
                                "In a small bowl, whisk together the all-purpose flour, cake flour, baking powder, and salt.",
                                "In a glass measuring cup, stir together the milk and vanilla.",
                                "In the bowl of a stand mixer or in a large bowl with a handheld electric mixer on high speed, beat the sugar and butter until light and fluffy, about 3 minutes. Beat in the eggs, 1 at a time, scraping the sides of the bowl as needed. Beat in the tepid chocolate.","Reduce the speed to low and beat in the flour mixture in 3 additions, alternating with the milk mixture in 2 additions, and mix until smooth.",
                                "Using a 2-inch diameter ice cream scoop or a 1/3 cup measuring cup, scoop the batter into the prepared cups. The cups shouldn’t be more than 2/3 full. (If you overfill the cups, they’ll end up flat rather than domed.)",
                                "Bake the white chocolate cupcakes until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Do not overbake. Don’t be alarmed if the cupcakes don’t rise appreciably or if they fail to turn golden brown.",
                                "Let the cupcakes cool in the pan on a wire rack for 10 to 15 minutes. Remove the cupcakes from the pan, place them on the wire rack, and cool completely.",
                                "Just before serving, frost your white chocolate cupcakes with the white chocolate cream cheese frosting. (For an especially professional look, use an ice-cream scoop to top each cupcake with the frosting, then use a small spatula to smooth each portion of frosting into a dome.)"],
                                url: "https://leitesculinaria.com/83100/recipes-white-chocolate-cupcakes.html?utm_campaign=yummly&utm_medium=yummly&utm_source=yummly#recipe",
                                photoFileName: "meal10"),
        
    ]
}
