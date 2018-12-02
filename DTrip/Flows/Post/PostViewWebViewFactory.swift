//
//  PostViewWebViewFactory.swift
//  DTrip
//
//  Created by Artem Semavin on 30/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import WebKit

enum PostViewWebViewFactory {
    static func makeWebView() -> WKWebView {
        let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
        let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
        
        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString,
                                                  injectionTime: .atDocumentEnd,
                                                  forMainFrameOnly: true)
        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString,
                                                injectionTime: .atDocumentEnd,
                                                forMainFrameOnly: true)
        
        let controller = WKUserContentController()
        controller.addUserScript(disableSelectionScript)
        controller.addUserScript(disableCalloutScript)
        
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        
        return webView
    }
}
