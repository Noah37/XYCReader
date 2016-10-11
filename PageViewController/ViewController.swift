//
//  ViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/9.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,ToolBarDelegate {
    var currentChapter:Int = 0
    var currentPage:Int = 0
    private var isToolBarShow:Bool = false
    var pageInfoModel:PageInfoModel?
    lazy var pageController:UIPageViewController = {
       let pageController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.setViewControllers([self.pageViewWithChapter(self.pageInfoModel!.chapter,page:self.pageInfoModel!.pageIndex)], direction: .Forward, animated: true, completion: nil)
        return pageController
    }()
    
    lazy var testString:String = {
        let path = NSBundle.mainBundle().pathForResource("743.txt", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        let encodingGB_18030_2000 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let encodingUTF8 = NSUTF8StringEncoding
        var testString:String = (NSString(data: data!, encoding: encodingGB_18030_2000) ?? "") as String
        if (testString as NSString).length == 0{
            testString = (NSString(data: data!, encoding: encodingUTF8) ?? "") as String
        }
        return testString
    }()
    
    //工具栏，阅读时点击屏幕弹出
    private lazy var navBar:ToolBar = {
        let navView:ToolBar = ToolBar(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
        navView.hidden = true
        navView.toolBarDelegate = self
        return navView
    }()
    
    private lazy var pageView:PageView = {
       let pageView = PageView()
        pageView.frame = CGRectMake(20, 30, self.view.bounds.size.width - 40, self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.whiteColor()
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(tap:UITapGestureRecognizer){
        
        navBar.showWithAnimations(true)
    }
    
    //MARK: - ToolBarDelegate
    func backButtonDidClicked(){
        let model = self.pageInfoModel
        model?.chapter = currentChapter
        model?.pageIndex = currentPage
        model!.updateModel(WithModel: model!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func catagoryClicked(){
        
    }
    
    func toolBarDidShow(){
        isToolBarShow = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func toolBarDidHidden(){
        isToolBarShow = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return !isToolBarShow
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.grayColor()
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
        view.addSubview(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageViewController).pageIndex
        index -= 1
        currentPage = index
        if currentChapter < 0 {
            return nil
        }
        if index < 0 && currentChapter == 0 {
            return nil
        }
        if index < 0 {
            currentChapter -= 1
            index = (pageInfoModel?.chapters![currentChapter].pageCount)! - 1
        }
        return pageViewWithChapter(currentChapter,page:index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageViewController).pageIndex
        index += 1
        currentPage = index
        if currentChapter  > pageInfoModel!.chapters!.count - 1 {
            return nil
        }
        if index >=  pageInfoModel?.chapters![currentChapter].pageCount && currentChapter == pageInfoModel!.chapters!.count - 1{
            return nil
        }
        if index >= pageInfoModel?.chapters![currentChapter].pageCount {
            currentChapter += 1
            index = 0
        }
        return pageViewWithChapter(currentChapter,page: index)
    }
    
    func pageViewWithChapter(chapter:Int,page:Int)->UIViewController{
        let vc1 = PageViewController()
        vc1.pageIndex = page
        var vc1Attibutestring = NSMutableAttributedString(string: "")
        vc1Attibutestring = NSMutableAttributedString(string: (pageInfoModel?.chapters![chapter].stringOfPage(page)) ?? "", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(20)])
        vc1.pageView.attributedText = vc1Attibutestring
        vc1.totalPage = (pageInfoModel?.chapters![chapter].pageCount)!
        return vc1
    }
    
    deinit{
        print("释放内存")
    }
}

