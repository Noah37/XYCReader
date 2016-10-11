//
//  RootViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var progressView:UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initSubview(){
        let btn = UIButton(type: .Custom)
        btn.frame = CGRectMake(self.view.bounds.size.width/2 - 90, self.view.bounds.size.height/2 + 30, 180, 30)
        btn.setTitle("阅读TXT", forState: .Normal)
        btn.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(readTXT(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btn)
        view.backgroundColor = UIColor.greenColor()
        progressView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progressView?.center = view.center
        
        view.addSubview(self.progressView!)
        
    }
    
    @objc private func readTXT(btn:UIButton){
        self.progressView?.startAnimating()
        btn.setTitle("正在解析，请稍候...", forState: .Normal)
        btn.enabled = false
        let vc = ViewController()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            vc.pageInfoModel = PageInfoModel().getModelWithContent(vc.testString)
            dispatch_async(dispatch_get_main_queue(), {
                self.progressView?.stopAnimating()
                btn.setTitle("阅读TXT", forState: .Normal)
                btn.enabled = true
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
