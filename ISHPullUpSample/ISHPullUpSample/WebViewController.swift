//
//  WebViewController.swift
//  ISHPullUpSample
//
//  Created by Felix Lamouroux on 30.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private weak var webView: WKWebView?
    private weak var topLabel: UILabel?

    override func loadView() {
        // we use an ISHPullUpRoundedView as the view for this view controller
        // ISHPullUpController will automatically adjust the dimming view to match
        let roundedView = ISHPullUpRoundedView(frame: UIScreen.main.bounds)
        roundedView.backgroundColor = .white
        roundedView.cornerRadius = 20
        view = roundedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup webview
        let wkWebView = WKWebView()
        let labelHeight: CGFloat = 40.0;
        let webViewFrame = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsetsMake(labelHeight, 0, 0, 0))
        wkWebView.frame = webViewFrame
        wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(wkWebView)
        webView = wkWebView

        // setup a label
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: labelHeight)
        label.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.backgroundColor = .clear
        label.textAlignment = .center
        view.addSubview(label)
        topLabel = label
    }

    func loadURL(_ url: URL) {
        // ensure view is loaded (
        if #available(iOS 9.0, *) {
            loadViewIfNeeded()
        } else {
            _ = view
        }

        _ = webView?.load(URLRequest(url: url))
        topLabel?.text = url.host
    }
}
