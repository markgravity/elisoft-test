//
//  PageController.swift
//  elisoft-test
//
//  Created by Mark G on 09/11/2020.
//

import UIKit

class PageController: UIPageViewController {
    fileprivate var _numberOfImages = Constant.maximum
    fileprivate var _maxPage: Int {
        let value = CGFloat(_numberOfImages) / (Constant.size.width * Constant.size.height)
        return Int(ceil(value))
    }
    fileprivate var _currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        _reload()
    }
    

    @IBAction func refreshAllButtonTap(_ sender: Any) {
        
        _numberOfImages = Constant.maximum
        StorageManager.shared.clean()
        _reload()
    }
    
    @IBAction func addButtonTap(_ sender: Any) {
        guard let controller = viewControllers?.first as? ContentController
        else { return }
        
        _numberOfImages += 1
        
        // When in the page
        // which can insert more
        if !controller.isFulfill,
           controller.page == _currentPage {
            controller.add()
            return
        }
        
        setViewControllers(
            [controller],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    fileprivate func _createPage(at page: Int) -> ContentController {
        let controller = storyboard?.instantiateViewController(identifier: "\(ContentController.self)") as! ContentController
        controller.configure(page: page, numberOfImages: _numberOfImages)
        
        return controller
    }
    
    fileprivate func _reload() {
        
        _numberOfImages = Constant.maximum
        _currentPage = 1
        
        let controller = _createPage(at: _currentPage)
        setViewControllers(
            [controller],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }

}

// MARK: -
extension PageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? ContentController,
              controller.page > 1
        else { return nil }
        
        return _createPage(at: controller.page - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? ContentController,
              controller.page < _maxPage
        else { return nil }
        
        return _createPage(at: controller.page + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let controller = pageViewController.viewControllers?.first as? ContentController
        else { return }
        _currentPage = controller.page
    }
    
}
