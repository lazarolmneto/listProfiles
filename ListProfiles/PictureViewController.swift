//
//  ViewController.swift
//  ListProfiles
//
//  Created by Lazaro Neto on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var picture     : UIImageView?
    var imageUrl    : String?
    
    var firstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !firstTime{
            self.scrollView.minimumZoomScale               = 1.0
            self.scrollView.maximumZoomScale               = 8.0
            self.scrollView.delegate                       = self
            self.scrollView.showsVerticalScrollIndicator   = false
            self.scrollView.showsHorizontalScrollIndicator = false
            
            self.picture                = UIImageView.init()
            self.picture?.contentMode   = .ScaleAspectFit
            self.picture?.clipsToBounds = true
            
            if let imageUrl = imageUrl, let url = NSURL(string: imageUrl){
                picture?.frame = CGRectMake(CGRectGetMidX(self.scrollView.frame), CGRectGetMidY(self.scrollView.frame), self.scrollView.frame.size.width, self.scrollView.frame.size.height)
                picture?.af_setImageWithURL(url)
                //            picture?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                picture?.center.x = CGRectGetMidX(self.scrollView.bounds)
                picture?.center.y = CGRectGetMidY(self.scrollView.bounds)
                
                scrollView.addSubview(self.picture!)
                scrollView.updateConstraints()
                scrollView.layoutSubviews()
                
                firstTime = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PictureViewController : UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.picture;
    }
}

