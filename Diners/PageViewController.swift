//
//  PageViewController.swift
//  Diners
//
//  Created by Александра Гольде on 30/01/2017.
//  Copyright © 2017 Александра Гольде. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = ["Write", "Find"]
    var subheadersArray = ["Create your diner's list", "Find and check your diners on map"]
    var imagesArray = ["food", "mapfood"]
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = displayViewControler(atIndex: 0){
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewControler(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else {return nil}
        guard index < headersArray.count else {return nil}
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else {return nil}
        
        contentVC.header = headersArray[index]
        contentVC.subheader = subheadersArray[index]
        contentVC.imageFile = imagesArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndex index: Int){
        if let contentVC = displayViewControler(atIndex: index + 1){
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension PageViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index =  (viewController as! ContentViewController).index
        index -= 1
        return displayViewControler(atIndex: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index =  (viewController as! ContentViewController).index
        index += 1
        return displayViewControler(atIndex: index)
    }
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.cont
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//    }
}
