//
//  PSLoopScrollView.swift
//  LoopScrooView
//
//  Created by 杨志强 on 2017/12/18.
//  Copyright © 2017年 sheep. All rights reserved.
//

import UIKit
import Kingfisher
import Foundation
@objc public protocol LoopScrollDelegate:NSObjectProtocol {
    func contentForLoop() -> Array<String>
    @objc optional func didSelectViewAtIndex(index:Int)
    @objc optional func pageIndicatorColor() -> UIColor
    @objc optional func currentPageIndicatorColor() -> UIColor
}

public class PSLoopScrollView: UIView, UIScrollViewDelegate {
    private var firstImageView:UIImageView!
    private var secondImageView:UIImageView!
    private var thirdImageView:UIImageView!
    weak open var delegate: LoopScrollDelegate?
    public var enableTimer:Bool! = false
    public var pageControl_y:CGFloat {
        set {
            pageControl.frame = CGRect(x: 0, y: newValue, width: self.frame.size.width, height: 30)
        }
        get {
            return pageControl.frame.origin.y
        }
    }
    private var imageArray:Array<String>!
    private var index = 0
    var pageControl:UIPageControl!
    private var scrollView:UIScrollView!
    private var timer:Timer!
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.addSubview(self.scrollView)
        
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.size.height-25, width: frame.size.width, height: 30))
        self.addSubview(self.pageControl)
        
        firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.scrollView.addSubview(firstImageView)
        firstImageView.isUserInteractionEnabled = true
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        firstImageView.addGestureRecognizer(tapFirst)
        
        secondImageView = UIImageView(frame: CGRect(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height))
        self.scrollView.addSubview(secondImageView)
        secondImageView.isUserInteractionEnabled = true
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        secondImageView.addGestureRecognizer(tapSecond)
        
        thirdImageView = UIImageView(frame: CGRect(x: 2*frame.size.width, y: 0, width: frame.size.width, height: frame.size.height))
        self.scrollView.addSubview(thirdImageView)
        thirdImageView.isUserInteractionEnabled = true
        let tapThird = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstImageView))
        thirdImageView.addGestureRecognizer(tapThird)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapFirstImageView() {
        delegate?.didSelectViewAtIndex?(index: self.index)
    }
    
    public func reloadData() {
        self.pageControl.currentPageIndicatorTintColor = delegate?.currentPageIndicatorColor?()
        self.pageControl.pageIndicatorTintColor = delegate?.pageIndicatorColor?()
        imageArray = delegate?.contentForLoop()
        self.pageControl.numberOfPages = imageArray.count
        if imageArray.count > 1 {
            self.pageControl.isHidden = false
        } else {
            self.pageControl.isHidden = true
        }
        if imageArray.count >= 3 {
            if enableTimer {
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            }
            firstImageView.kf.setImage(with: URL(string: imageArray[imageArray.count-1]))
            secondImageView.kf.setImage(with: URL(string: imageArray[0]))
            thirdImageView.kf.setImage(with: URL(string: imageArray[1]))
            self.scrollView.contentSize = CGSize(width: self.frame.size.width*3, height: self.frame.size.height)
            self.scrollView.scrollRectToVisible(CGRect(x:frame.size.width,y:0,width: frame.size.width, height: frame.size.height), animated: false)
        } else if imageArray.count == 2 {
            if enableTimer {
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            }
            firstImageView.kf.setImage(with: URL(string: imageArray[1]))
            secondImageView.kf.setImage(with: URL(string: imageArray[0]))
            thirdImageView.kf.setImage(with: URL(string: imageArray[1]))
            self.scrollView.contentSize = CGSize(width: self.frame.size.width*3, height: self.frame.size.height)
            self.scrollView.scrollRectToVisible(CGRect(x:self.frame.size.width,y:0,width: frame.size.width, height: frame.size.height), animated: false)
        } else if imageArray.count == 1 {
            firstImageView.kf.setImage(with: URL(string: imageArray[0]))
            self.scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    @objc func startTimer() {
        self.scrollView.scrollRectToVisible(CGRect(x:self.frame.size.width*2,y:0,width: self.frame.size.width, height: self.frame.size.height), animated: true)
        self.loopResult()
    }
    
    func loopResult() {
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
        self.pageControl.currentPage = index
        firstImageView.kf.setImage(with: URL(string: picName1))
        secondImageView.kf.setImage(with: URL(string: picName2))
        thirdImageView.kf.setImage(with: URL(string: picName3))
        self.scrollView.scrollRectToVisible(CGRect(x:self.frame.size.width,y:0,width: self.frame.size.width, height: self.frame.size.height), animated: false)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if imageArray.count > 1 {
            if enableTimer {
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.loopResult()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.loopResult()
    }
}
