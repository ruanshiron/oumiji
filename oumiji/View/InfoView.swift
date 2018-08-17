//
//  InfoView.swift
//  oumiji
//
//  Created by ominext on 8/16/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit

class InfoView: UIView, UIScrollViewDelegate {
    
    
    @IBOutlet var content: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var tut1 = ["content": "Màn hình Hello", "image" : "1"]
    var tut2 = ["content": "Màn hình Kết thúc", "image" : "2"]
    var tut3 = ["content": "Màn hình cài đặt", "image" : "3"]
    var tut4 = ["content": "Màn hình của chế độ Khách", "image" : "4"]
    var tut5 = ["content": "Màn hình của chế độ cho nhân viên", "image" : "5"]
    
    var tutArray = [Dictionary<String, String>]()
    
    var imageFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()    
        scrollViewSetting()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        //
    }
    
    func customInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func scrollViewSetting() {
        tutArray = [tut1, tut2, tut3, tut4, tut5]
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: content.frame.size.width * CGFloat(tutArray.count), height: content.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false        
        
        scrollView.delegate = self

        pageControl.numberOfPages = tutArray.count
        
        for (index, tut) in tutArray.enumerated() {
           
            imageFrame.origin.x = content.frame.size.width * CGFloat(index)
            imageFrame.size = content.bounds.size

            let imageView = UIImageView(frame: imageFrame)

            imageView.image = UIImage(named: tut["image"]!)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            scrollView.addSubview(imageView)
        }
        
        
    }
    
    
    // scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func back(_ sender: Any) {
        UIView.transition(with: self.superview!,
                          duration: 0.5,
                          options: [UIViewAnimationOptions.transitionFlipFromLeft],
                          animations: {
                            self.removeFromSuperview()
        },
                          completion: { (_) in
                            
        })
        
    }
}
