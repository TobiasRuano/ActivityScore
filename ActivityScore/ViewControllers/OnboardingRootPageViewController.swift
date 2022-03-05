//
//  OnboardingRootPageViewController.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 03/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
class OnboardingRootPageViewController: UIPageViewController,
										UIPageViewControllerDataSource,
										UIPageViewControllerDelegate {

    lazy var viewControllerList: [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)

        let vc1 = sb.instantiateViewController(withIdentifier: "FirstVC")
        let vc2 = sb.instantiateViewController(withIdentifier: "SecondVC")
        let vc3 = sb.instantiateViewController(withIdentifier: "ThirdVC")

        return [vc1, vc2, vc3]
    }()

    var pageControllerView = UIView()
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        self.view.backgroundColor = UIColor.white

        self.dataSource = self
        self.delegate = self

        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        configureView()
        configurePageControl()
    }

    func configureView() {
        pageControllerView.backgroundColor = UIColor(named: "pink")!
        // pageControllerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 67)
        self.view.addSubview(pageControllerView)
        pageControllerView.translatesAutoresizingMaskIntoConstraints = false
        // Pin the leading edge of myView to the margin's leading edge
//        pageControllerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        // Pin the trailing edge of myView to the margin's trailing edge
        // pageControllerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        pageControllerView.heightAnchor.constraint(equalToConstant: 67).isActive = true
//        pageControllerView.bottomAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        pageControllerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,
												   constant: 0).isActive = true
        pageControllerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }

    func configurePageControl() {
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: pageControllerView.centerXAnchor).isActive = true
        pageControl.centerYAnchor.constraint(equalTo: pageControllerView.centerYAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.pageControl.numberOfPages = viewControllerList.count
        self.pageControl.currentPage = 0
        let pinkColor = UIColor(displayP3Red: 236/255, green: 67/255, blue: 100/255, alpha: 1)
        self.pageControl.tintColor = pinkColor
        self.pageControl.pageIndicatorTintColor = .white
        self.pageControl.currentPageIndicatorTintColor = .black
        self.pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        return viewControllerList[nextIndex]
    }

    // MARK: Delegate functions
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.firstIndex(of: pageContentViewController)!
    }
}
