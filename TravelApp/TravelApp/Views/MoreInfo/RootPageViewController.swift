//
//  RootPageViewController.swift
//  TravelApp
//
//  Created by Demo on 5/24/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var tappedCity: City?
    lazy var viewControllersList:[UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! CoverPhotoViewController
        vc1.tappedCity = tappedCity
        
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "secondVC")  as! CityDetailViewController
        vc2.tappedCity = tappedCity
        return [vc1, vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstVC = viewControllersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllersList.index(of: viewController) else {return nil}
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else {return nil}
        guard viewControllersList.count > prevIndex else {return nil}

        return viewControllersList[prevIndex]
    }
  
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllersList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllersList.count != nextIndex else {return nil}
        guard viewControllersList.count > nextIndex else {return nil}
        
        return viewControllersList[nextIndex]
    }

}
