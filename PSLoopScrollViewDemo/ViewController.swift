//
//  ViewController.swift
//  LoopScrooView
//
//  Created by 杨志强 on 2017/12/15.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
class ViewController: UIViewController, LoopScrollDelegate {
    
    var scrollView:PSLoopScrollView!
    let imageArr = ["http://img.sdjjia.com/fdc/2017/20171024/40/59eea80887bbc.png", "http://img.sdjjia.com/uploads/20170120/5881b42b39cec.jpg","http://img.shandjj.com/uploads/20160414/570f6cb80ec10.jpg", "http://img.shandjj.com/uploads/20160520/573eb6130c294.jpg","http://img.shandjj.com/uploads/20160414/570f6b8bb2a14.jpg","http://img.sdjjia.com/uploads/20170301/58b64be36cdcd.jpg","http://img.sdjjia.com/uploads/20170925/59c8adff74e4a.png","http://img.sdjjia.com/uploads/20170516/591ae5b008410.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = PSLoopScrollView(frame: self.view.bounds)
        self.view.addSubview(self.scrollView)
        self.scrollView.loopDelegate = self
        self.scrollView.reloadData()
    }
    
    func contentForLoop() -> Array<String> {
        return imageArr
    }
    
    func didSelectViewAtIndex(index: Int) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

