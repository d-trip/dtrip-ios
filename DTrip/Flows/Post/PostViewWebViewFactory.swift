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
        let viewportScriptString = """
                var meta = document.createElement('meta');
                meta.setAttribute('name', 'viewport');
                meta.setAttribute('content', 'width=device-width');
                meta.setAttribute('initial-scale', '1.0');
                meta.setAttribute('maximum-scale', '1.0');
                meta.setAttribute('minimum-scale', '1.0');
                meta.setAttribute('user-scalable', 'no');
                document.getElementsByTagName('head')[0].appendChild(meta);
        """
        let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
        let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
        
        // 1 - Make user scripts for injection
        let viewportScript = WKUserScript(source: viewportScriptString,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString,
                                                  injectionTime: .atDocumentEnd,
                                                  forMainFrameOnly: true)
        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString,
                                                injectionTime: .atDocumentEnd,
                                                forMainFrameOnly: true)
        
        // 2 - Initialize a user content controller
        // From docs: "provides a way for JavaScript to post messages and inject user scripts to a web view."
        let controller = WKUserContentController()
        
        // 3 - Add scripts
        controller.addUserScript(viewportScript)
        controller.addUserScript(disableSelectionScript)
        controller.addUserScript(disableCalloutScript)
        
        // 4 - Initialize a configuration and set controller
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        // 5 - Initialize webview with configuration
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        // 6 - Webview options
        webView.scrollView.isScrollEnabled = true             // Make sure our view is interactable
        webView.scrollView.bounces = false                    // Things like this should be handled in web code
        webView.allowsBackForwardNavigationGestures = false   // Disable swiping to navigate
        webView.contentMode = .scaleToFill                    // Scale the page to fill the web view
        
        return webView
    }
}
