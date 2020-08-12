//
//  BannerAdView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/11/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    var bannerId : String
    let banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    func makeCoordinator() -> Coordinator   {
        Coordinator(self)
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<BannerAdView>) -> GADBannerView {
        banner.adUnitID = bannerId
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        banner.delegate  = context.coordinator
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<BannerAdView>) {
        
    }
    
    class Coordinator : NSObject, GADBannerViewDelegate {
        var parent : BannerAdView
        init(_ parent: BannerAdView){
            self.parent = parent
        }
        
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Did recieve ad")
        }
        
        func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
            print("failed to get AD")
        }
        
        
    }
}
