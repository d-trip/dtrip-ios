//
//  RouterImp.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

final class RouterImp: NSObject, Router {
    
    private(set) weak var _rootController: UINavigationController?
    private var topNavController: UINavigationController {
        var presented = _rootController
        while (presented?.presentedViewController as? UINavigationController != nil) {
            presented = presented?.presentedViewController as? UINavigationController
        }
        return presented!
    }

    private var completions: [UIViewController: (() -> Void)?]

    init(rootController: UINavigationController) {
        self._rootController = rootController
        completions = [:]
    }

    func toPresent() -> UIViewController? {
        return topNavController
    }

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        topNavController.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        topNavController.dismiss(animated: animated, completion: completion)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        if let completion = completion {
            completions[controller] = completion
        }

		for subController in topNavController.viewControllers as Array {
			if object_getClassName(subController) == object_getClassName(controller) {
                popModule(to: controller)
				return
			}
		}
		if topNavController.presentedViewController == nil {
			topNavController.pushViewController(controller, animated: animated)
		} else {
			assertionFailure("Top nav controller has a presented controller already.")
		}
    }

    func popModule() {
        popModule(animated: true)
    }

	func popModule(to module: Presentable) {
		if let controller = module.toPresent() {
			topNavController.popToViewController(controller, animated: true)
		}
	}

    func popModule(animated: Bool) {
		if let controller = topNavController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false, animated: false)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        topNavController.setViewControllers([controller], animated: animated)
        topNavController.isNavigationBarHidden = hideBar
    }

    func popToRootModule(animated: Bool) {
        if let controllers = topNavController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion?()
        completions.removeValue(forKey: controller)
    }
}
