//
//  ScrollViewController.swift
//  ISHPullUpSample
//
//  Created by Felix Lamouroux on 25.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

import UIKit
import ISHPullUp
import MapKit

class BottomVC: UIViewController, ISHPullUpSizingDelegate, ISHPullUpStateDelegate {
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var buttonLock: UIButton?

    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    
    // we allow the pullUp to snap to the half way point
    private var halfWayPoint = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
    }

    private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        if pullUpController.isLocked {
            return
        }

        pullUpController.toggleState(animated: true)
    }

    @IBAction private func buttonTappedLearnMore(_ sender: AnyObject) {
        // for demo purposes we replace the bottomViewController with a web view controller
        // there is no way back in the sample app though
        // This also highlights the behaviour of the pullup view controller without a sizing and state delegate
        let webVC = WebViewController()
        webVC.loadURL(URL(string: "https://iosphere.de")!)
        pullUpController.bottomViewController = webVC
    }

    @IBAction private func buttonTappedLock(_ sender: AnyObject) {
        pullUpController.isLocked  = !pullUpController.isLocked
        buttonLock?.setTitle(pullUpController.isLocked ? "Unlock" : "Lock", for: .normal)
    }

    // MARK: ISHPullUpSizingDelegate

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height

        // we allow the pullUp to snap to the half way point
        // we "calculate" the cached value here 
        // and perform the snapping in ..targetHeightForBottomViewController..
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;
    }

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        // if around 30pt of the half way point -> snap to it
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        
        // default behaviour
        return height
    }

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
        // we update the scroll view's content inset 
        // to properly support scrolling in the intermediate states
        scrollView.contentInset = edgeInsets;
    }

    // MARK: ISHPullUpStateDelegate

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        topLabel.text = textForState(state);
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)

        // Hide the scrollview in the collapsed state to avoid collision
        // with the soft home button on iPhone X
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.scrollView.alpha = (state == .collapsed) ? 0 : 1;
        }
    }

    private func textForState(_ state: ISHPullUpState) -> String {
        switch state {
        case .collapsed:
            return "Drag up or tap"
        case .intermediate:
            return "Intermediate"
        case .dragging:
            return "Hold on"
        case .expanded:
            return "Drag down or tap"
        }
    }
}

class ModalViewController: UIViewController {

    @IBAction func buttonTappedDone(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
