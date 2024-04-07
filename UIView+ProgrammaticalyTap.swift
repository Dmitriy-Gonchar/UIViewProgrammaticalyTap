//
//  UIView+ProgrammaticalyTap.swift
//  
//
//  Created by Jesus++ on 08.04.2024.
//

import UIKit

extension UIView
{
	func allTargetSelectors(`for`: UIControl.Event) -> [(target: Any, selector: Selector)]
	{
		var pairs = [(target: Any, selector: Selector)]()

		let control = self as? UIControl

		for target in control?.allTargets
		{
			if let actions = control?.actions(forTarget: target, forControlEvent: `for`)
			{
				for action in actions
				{
					pairs.append((target: target, selector: Selector(action)))
				}
			}
		}

		for subview in self.subviews
		{
			pairs += subview.allTargetSelectors(for: `for`)
		}

		return pairs

	}

	func programmaticalyTap()
	{
		let pairs = allTargetSelectors(for: .touchUpInside)
		pairs.forEach { ($0.target as? NSObject)?.perform($0.selector, with: self) }
	}
}
