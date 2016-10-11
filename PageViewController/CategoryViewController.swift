//
//  CategoryViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func categoryDidSelectAtIndex(index:Int)
}

class CategoryViewController: UITableViewController {

    var categoryDelegate:CategoryDelegate?
    var titles:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .SingleLineEtched
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .Plain, target: self, action: #selector(dismiss(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Category",forIndexPath: indexPath) as! CategoryTableViewCell
        cell.count.text = "\(indexPath.row)."
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        categoryDelegate?.categoryDidSelectAtIndex(indexPath.row)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func dismiss(sender:AnyObject){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
