//
//  CustomAnimationPresentor.swift
//  InstaFirebase
//
//  Created by YouSS on 12/13/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        containerView.addSubview(toView)
        
        toView.frame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (completed) in
            transitionContext.completeTransition(true)
        }
    }
}
