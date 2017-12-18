//
//  PSLoopScrollView.swift
//  LoopScrooView
//
//  Created by 杨志强 on 2017/12/18.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
import Kingfisher
@objc public protocol LoopScrollDelegate:NSObjectProtocol {
    func contentForLoop() -> Array<String>
    @objc optional func didSelectViewAtIndex(index:Int)
}

public class PSLoopScrollView: UIScrollView, UIScrollViewDelegate {
    private var firstImageView:UIImageView!
    private var secondImageView:UIImageView!
    private var thirdImageView:UIImageView!
    weak open var loopDelegate: LoopScrollDelegate?
    private var imageArray:Array<String>!
    private var index = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.isPagingEnabled = true
        firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(firstImageView)
        firstImageView.isUserInteractionEnabled = true
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        firstImageView.addGestureRecognizer(tapFirst)
        
        secondImageView = UIImageView(frame: CGRect(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(secondImageView)
        secondImageView.isUserInteractionEnabled = true
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        secondImageView.addGestureRecognizer(tapSecond)
        
        thirdImageView = UIImageView(frame: CGRect(x: 2*frame.size.width, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(thirdImageView)
        thirdImageView.isUserInteractionEnabled = true
        let tapThird = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        thirdImageView.addGestureRecognizer(tapThird)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapFirstImageView() {
        loopDelegate?.didSelectViewAtIndex?(index: self.index)
    }
    
    public func reloadData() {
        imageArray = loopDelegate?.contentForLoop()
        if imageArray.count >= 3 {
            firstImageView.kf.setImage(with: URL(string: imageArray[imageArray.count-1]))
            secondImageView.kf.setImage(with: URL(string: imageArray[0]))
            thirdImageView.kf.setImage(with: URL(string: imageArray[1]))
            self.contentSize = CGSize(width: self.frame.size.width*3, height: self.frame.size.height)
            self.scrollRectToVisible(CGRect(x:frame.size.width,y:0,width: frame.size.width, height: frame.size.height), animated: false)
        } else if imageArray.count == 2 {
            firstImageView.kf.setImage(with: URL(string: imageArray[1]))
            secondImageView.kf.setImage(with: URL(string: imageArray[0]))
            thirdImageView.kf.setImage(with: URL(string: imageArray[1]))
            self.contentSize = CGSize(width: self.frame.size.width*3, height: self.frame.size.height)
            self.scrollRectToVisible(CGRect(x:self.frame.size.width,y:0,width: frame.size.width, height: frame.size.height), animated: false)
        } else if imageArray.count == 1 {
            firstImageView.kf.setImage(with: URL(string: imageArray[0]))
            self.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset_x = scrollView.contentOffset.x
        let width = self.frame.size.width
        if offset_x > width {
            index = index + 1
        } else if offset_x < width {
            index = index - 1
        }
        var picName1 = ""
        var picName2 = ""
        var picName3 = ""
        if index < 0 {
            index = imageArray.count-1
            if imageArray.count >= 3 {
                picName1 = imageArray[imageArray.count-2]
                picName2 = imageArray[imageArray.count-1]
                picName3 = imageArray[0]
            } else {
                picName1 = imageArray[0]
                picName2 = imageArray[imageArray.count-1]
                picName3 = imageArray[0]
            }
        } else if index > (imageArray.count-1) {
            index = 0
            if imageArray.count >= 3 {
                picName1 = imageArray[imageArray.count-1]
                picName2 = imageArray[0]
                picName3 = imageArray[1]
            } else {
                picName1 = imageArray[imageArray.count-1]
                picName2 = imageArray[0]
                picName3 = imageArray[imageArray.count-1]
            }
        } else if index == 0 {
            if imageArray.count >= 3 {
                picName1 = imageArray[imageArray.count-1]
                picName2 = imageArray[index]
                picName3 = imageArray[index+1]
            } else {
                picName1 = imageArray[imageArray.count-1]
                picName2 = imageArray[index]
                picName3 = imageArray[imageArray.count-1]
            }
        } else if index == (imageArray.count - 1) {
            if imageArray.count >= 3 {
                picName1 = imageArray[index-1]
                picName2 = imageArray[index]
                picName3 = imageArray.first!
            } else {
                picName1 = imageArray[0]
                picName2 = imageArray[index]
                picName3 = imageArray[0]
            }
        } else {
            if imageArray.count >= 3 {
                picName1 = imageArray[index-1]
                picName2 = imageArray[index]
                picName3 = imageArray[index+1]
            } else {
                picName1 = imageArray[index-1]
                picName2 = imageArray[index]
                picName3 = imageArray[index-1]
            }
        }
        firstImageView.kf.setImage(with: URL(string: picName1))
        secondImageView.kf.setImage(with: URL(string: picName2))
        thirdImageView.kf.setImage(with: URL(string: picName3))
        self.scrollRectToVisible(CGRect(x:self.frame.size.width,y:0,width: self.frame.size.width, height: self.frame.size.height), animated: false)
    }
}
