//
//  ViewController.swift
//  ISHPullUpSample
//
//  Created by Felix Lamouroux on 25.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

import UIKit
import ISHPullUp

class ViewController: ISHPullUpViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    private func commonInit() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "content") as! ContentVC
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottom") as! BottomVC
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        contentDelegate = contentVC
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }
}
