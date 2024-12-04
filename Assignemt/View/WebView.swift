//
//  WebView.swift
//  Assignemt
//
//  Created by ANUJ KUMAR on 03/12/24.
//

import SwiftUI
import WebKit
import Foundation

struct IdentifiableURL: Identifiable {
    var id: String { url.absoluteString } // Make it identifiable by the URL string
    let url: URL
}


// SwiftUI wrapper for WebView
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
