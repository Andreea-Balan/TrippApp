//
//  ThingsToDoViewController.swift
//  TravelApp
//
//  Created by Demo on 5/16/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class ThingsToDoViewController: UIViewController {
    @IBOutlet weak var slideShowImage1: UIImageView!
    @IBOutlet weak var slideShowImage2: UIImageView!
    @IBOutlet weak var slideShowImage3: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tappedCity: City?
    var objectives = [Objectiv]()
    //var objectives = Objectiv.fetchObjectivs()
    let cellScaling: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        slideShowImage1.alpha = 1
        slideShowImage2.alpha = 0
        slideShowImage3.alpha = 0
       
        ImageService.getImage(withURL: (tappedCity?.photoURL[0])!) { image in
            self.slideShowImage1.image = image
        }
        ImageService.getImage(withURL: (tappedCity?.photoURL[1])!) { image in
            self.slideShowImage2.image = image
        }
        ImageService.getImage(withURL: (tappedCity?.photoURL[2])!) { image in
            self.slideShowImage3.image = image
        }
        self.perform(#selector(self.slide1), with: nil, afterDelay: 3)
        
        objectives = (tappedCity?.objectives)!
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: 25, bottom: insetY, right: 25)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    @objc func slide1(){
        slideShowImage1.alpha = 1
        slideShowImage2.alpha = 0
        slideShowImage3.alpha = 0
        
          self.perform(#selector(self.slide2), with: nil, afterDelay: 3)
    }
    
    @objc func slide2(){
        slideShowImage1.alpha = 0
        slideShowImage2.alpha = 1
        slideShowImage3.alpha = 0
        
        self.perform(#selector(self.slide3), with: nil, afterDelay: 3)
    }
    
    @objc func slide3(){
        slideShowImage1.alpha = 0
        slideShowImage2.alpha = 0
        slideShowImage3.alpha = 1
        
        self.perform(#selector(self.slide1), with: nil, afterDelay: 3)
    }
    
    
    private func indexOfMajorCell() -> Int {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let proportionalOffset = collectionView!.contentOffset.x / cellWidth
        return Int(round(proportionalOffset))
    }
    
    

}

extension ThingsToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objectives.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "objectivcell", for: indexPath) as! cityCollectionViewCell
        
        cell.objectives = objectives[indexPath.item]
        
        return cell
    }
  
}
