//
//  UIView+ProgrammaticalyTap.swift
//  
//
//  Created by Jesus++ on 08.04.2024.
//

import UIKit

extension UIView
{
	// TSP is target-selector pair:
	typealias TSP = (target: Any, selector: Selector)

	private func tsp(`for`: UIControl.Event) -> [TSP]
	{
		let tspFromSubviews = self.subviews.reduce([TSP]()) { $0 + $1.tsp(for: `for`) }

		guard let control = self as? UIControl else { return tspFromSubviews }

		let tsp = control.allTargets.reduce([TSP]())
		{ partial, target in
			partial + (control.actions(forTarget: target, forControlEvent: `for`) ?? [])
				.map { TSP(target: target, selector: Selector($0)) }
		}

		return tsp + tspFromSubviews
	}

	func programmaticalyTap()
	{
		let pairs = tsp(for: .touchUpInside)
		pairs.forEach { ($0.target as? NSObject)?.perform($0.selector, with: self) }
	}
}
