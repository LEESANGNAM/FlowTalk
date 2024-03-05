//
//  SlideInTransition.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import UIKit


class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = false
    // 동작시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    // 동작 정의
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {
            // Add the 'to' view controller's view to the container view
            let targetWidth = fromViewController.view.frame.width
            toViewController.view.frame = CGRect(x: targetWidth * -1, y: 0, width: targetWidth, height: fromViewController.view.frame.height)
                containerView.addSubview(toViewController.view)

            // Animate the 'to' view controller's view sliding in from left to right
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toViewController.view.frame.origin.x = 0
                toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(0.5)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            // Animate the 'from' view controller's view sliding out from right to left
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromViewController.view.frame.origin.x = -containerView.frame.width
                fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.withAlphaComponent(0.0)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
