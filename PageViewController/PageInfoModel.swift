//
//  PageInfoModel.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class PageInfoModel: NSObject ,NSCoding{
    
    var pageIndex:Int = 0
    var chapter:Int = 0
    var chapters:[ChapterModel]?
    
    static let userPath:String? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    var filePath:String? = "\(userPath!)/\(NSStringFromClass(PageInfoModel.self)).archive"
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.chapters, forKey: "chapters")
        aCoder.encodeObject(self.chapter, forKey: "chapter")
        aCoder.encodeObject(self.pageIndex, forKey: "pageIndex")
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.pageIndex = aDecoder.decodeObjectForKey("pageIndex") as! Int
        self.chapter = aDecoder.decodeObjectForKey("chapter") as! Int
        self.chapters = aDecoder.decodeObjectForKey("chapters") as? [ChapterModel]
    }
    
    override init() {
        
    }
    
    func getLocalModel(content:String)->PageInfoModel{
        var model = PageInfoModel()
        if self.chapters?.count == 0 || self.chapters == nil {
            model = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath!) as! PageInfoModel
            if model.chapters?.count == 0 || model.chapters == nil {
                return getChapter(WithContent: content)
            }
            return model
        }
        return getChapter(WithContent: content)
    }

    func getModelWithContent(content:String)->PageInfoModel{
        let pageModel = getLocalModel(content)
        return pageModel
    }
    
    func getChapter(WithContent content:String)->PageInfoModel{
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        do{
            let reg = try NSRegularExpression(pattern: parten, options: .CaseInsensitive)
            let match = reg.matchesInString(content, options: .ReportCompletion, range: NSMakeRange(0, (content as NSString).length))
            if match.count != 0 {
                let model = PageInfoModel()
                var lastRange:NSRange?
                let chapterArr:NSMutableArray = NSMutableArray()
                for index in 0..<match.count {
                    let range = match[index].range
                    let chapterModel = ChapterModel()
                    if index == 0 {
                        chapterModel.title = "开始"
                        chapterModel.content = ""
                    } else if index <= match.count - 1{
                        chapterModel.title = (content as NSString).substringWithRange(lastRange!)
                        chapterModel.content = (content as NSString).substringWithRange(NSMakeRange(lastRange!.location, range.location - lastRange!.location))
                        chapterArr.addObject(chapterModel)
                    }
                    lastRange = range
                }
                model.chapters = chapterArr.copy() as? [ChapterModel]
                updateModel(WithModel: model)
                return model
            }else{
                
                let model = PageInfoModel()
                let chapterModel = ChapterModel()
                chapterModel.title = ""
                chapterModel.content = content
                model.chapters = [chapterModel]
                updateModel(WithModel: model)
                return model
            }
        }catch{
            
        }
        return PageInfoModel()
    }
    
    func updateModel(WithModel model:PageInfoModel){
        
        let success = NSKeyedArchiver.archiveRootObject(model, toFile: filePath!)
        if success {
            print("更新成功")
        }
    }
}
