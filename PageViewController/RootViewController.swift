
//
//  RootViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire

let BaseUrl = "http://chapter2.zhuishushenqi.com"
let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"
let chapterContent = "http://chapter2.zhuishushenqi.com/chapter/http://vip.zhuishushenqi.com/chapter/57df797d864946e5195ff068?cv=1474263421423?k=19ec78553ec3a169&t=1476188085"

class RootViewController: UIViewController {

    var progressView:UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let str = "%2F"
//        let str2 = str.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
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
        
        let btn2 = UIButton(type: .Custom)
        btn2.frame = CGRectMake(self.view.bounds.size.width/2 - 90, self.view.bounds.size.height/2 + 70, 180, 30)
        btn2.setTitle("在线阅读", forState: .Normal)
        btn2.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn2.addTarget(self, action: #selector(readOnline(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)

    }
    
    @objc private func readOnline(btn:UIButton){
        self.progressView?.startAnimating()
        btn.setTitle("正在解析，请稍候...", forState: .Normal)
        btn.enabled = false
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.requestAllChapters()
           
            dispatch_async(dispatch_get_main_queue(), {
                self.progressView?.stopAnimating()
                btn.setTitle("在线阅读", forState: .Normal)
                btn.enabled = true
            })
        }

    }
    
    @objc private func readTXT(btn:UIButton){
        self.progressView?.startAnimating()
        btn.setTitle("正在解析，请稍候...", forState: .Normal)
        btn.enabled = false
        let vc = ViewController()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let model = PageInfoModel().getModelWithContent(vc.testString,bookName: "")
            vc.pageInfoModel = model
            vc.currentPage = model.pageIndex
            vc.currentChapter = model.chapter
            dispatch_async(dispatch_get_main_queue(), {
                self.progressView?.stopAnimating()
                btn.setTitle("阅读TXT", forState: .Normal)
                btn.enabled = true
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }
    
    func requestAllChapters(){
        Alamofire.request(.GET, AllChapterUrl, parameters: ["view":"chapters"])
            .validate()
            .responseJSON { response in
                HUD.hide()
                print("request:\(response.request)")  // original URL request
                print("response:\(response.response)") // URL response
//                print("data:\(response.data)")     // server data
                print("result:\(response.result.value)")   // result of response serialization
                switch response.result {
                case .Success:
                    let vc = OnlineViewController()
                    let model = PageInfoModel()
                    model.type = .Online
                    vc.currentPage = model.pageIndex
                    vc.currentChapter = model.chapter
                    vc.chapters = (response.result.value as! NSDictionary)["chapters"] as! NSArray
                    vc.bookName = (response.result.value as! NSDictionary)["_id"] as! String
                    print("Validation Successful")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.progressView?.stopAnimating()
                        self.presentViewController(vc, animated: true, completion: nil)
                    })
                
                case .Failure(let error):
                    print(error)
                    
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
