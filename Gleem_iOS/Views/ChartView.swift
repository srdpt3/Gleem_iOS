//
//  ChartView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import AAInfographics

struct ChartView: UIViewRepresentable {
    
    @Binding var data : [Double]
    @Binding var totalNum : Int
    var categories : [String]
    let hexColor = "#757AF9"
    //        "#A3ADF9"
    let areaType = AAChartType.area
    let aaChartView = AAChartView()
    let animationType : AAChartAnimationType = AAChartAnimationType.bounce
    let gradientColorArr = [
        AAGradientColor.oceanBlue,
        AAGradientColor.sanguine,
        AAGradientColor.lusciousLime,
        AAGradientColor.purpleLake,
        AAGradientColor.freshPapaya,
        AAGradientColor.ultramarine,
        AAGradientColor.pinkSugar,
        AAGradientColor.lemonDrizzle,
        AAGradientColor.victoriaPurple,
        AAGradientColor.springGreens,
        AAGradientColor.mysticMauve,
        AAGradientColor.reflexSilver,
        AAGradientColor.newLeaf,
        AAGradientColor.cottonCandy,
        AAGradientColor.pixieDust,
        AAGradientColor.fizzyPeach,
        AAGradientColor.sweetDream,
        AAGradientColor.firebrick,
        AAGradientColor.wroughtIron,
        AAGradientColor.deepSea,
        AAGradientColor.coastalBreeze,
        AAGradientColor.eveningDelight,
    ]
    //Animation type
    //    case linear
    //    case easeInQuad
    //    case easeOutQuad
    //    case easeInOutQuad
    //    case easeInCubic
    //    case easeOutCubic
    //    case easeInOutCubic
    //    case easeInQuart
    //    case easeOutQuart
    //    case easeInOutQuart
    //    case easeInQuint
    //    case easeOutQuint
    //    case easeInOutQuint
    //    case easeInSine
    //    case easeOutSine
    //    case easeInOutSine
    //    case easeInExpo
    //    case easeOutExpo
    //    case easeInOutExpo
    //    case easeInCirc
    //    case easeOutCirc
    //    case easeInOutCirc
    //    case easeOutBounce
    //    case easeInBack
    //    case easeOutBack
    //    case easeInOutBack
    //    case elastic
    //    case swingFromTo
    //    case swingFrom
    //    case swingTo
    //    case bounce
    //    case bouncePast
    //    case easeFromTo
    //    case easeFrom
    //    case easeTo
    
    
    //    let gradientColorArr = [
    //        AAGradientColor.oceanBlue,
    //        AAGradientColor.sanguine,
    //        AAGradientColor.lusciousLime,
    //        AAGradientColor.purpleLake,
    //        AAGradientColor.freshPapaya,
    //        AAGradientColor.ultramarine,
    //        AAGradientColor.pinkSugar,
    //        AAGradientColor.lemonDrizzle,
    //        AAGradientColor.victoriaPurple,
    //        AAGradientColor.springGreens,
    //        AAGradientColor.mysticMauve,
    //        AAGradientColor.reflexSilver,
    //        AAGradientColor.newLeaf,
    //        AAGradientColor.cottonCandy,
    //        AAGradientColor.pixieDust,
    //        AAGradientColor.fizzyPeach,
    //        AAGradientColor.sweetDream,
    //        AAGradientColor.firebrick,
    //        AAGradientColor.wroughtIron,
    //        AAGradientColor.deepSea,
    //        AAGradientColor.coastalBreeze,
    //        AAGradientColor.eveningDelight,
    //    ]
    func updateUIView(_ uiView: AAChartView, context:  UIViewRepresentableContext<Self>) {
        
        //        let aaChartModel = AAChartModel()
        //            .chartType(areaType)
        //            .title("")
        //            .legendEnabled(false)
        //            .dataLabelsEnabled(true)
        //            
        //            //            .xAxisVisible(true)
        //            .animationType(animationType)
        //            .colorsTheme([hexColor])
        //            //            .colorsTheme(gradientColorArr as [Any])
        //            .touchEventEnabled(true)
        //            
        //            
        //            .markerRadius(2)
        //            .borderRadius(10)
        //            .polar(true)
        //            .axesTextColor(AAColor.rgbaColor(117, 122, 249, 1))
        //
        //            //            .axesTextColor("Red")
        //            //            .xAxisGridLineWidth(30)
        //            
        //            .yAxisGridLineWidth(4)
        //            .categories(categories).dataLabelsFontSize(15)
        //            .dataLabelsFontWeight(AAChartFontWeightType.bold)
        //            //            .marginRight(5)
        //            //            .marginLeft(5)
        //            .marginBottom(50)
        //            .backgroundColor(Color.black.opacity(0.06))
        //            //            .titleFontWeight(AAChartFontWeightType)
        //            .series([
        //                AASeriesElement().name(SERIES_TITLE)
        //                    .data([data[0],data[1],data[2],data[3],data[4]]),
        //                
        //                
        //            ])
        //            .yAxisMax(Float(totalNum))
        //            .yAxisVisible(true)
        //        //        uiView.
        //        //        uiView.aa_updateChart(options: aaChartModel, redraw: true)
        //        //
        //        
        //        uiView.aa_refreshChartWholeContentWithChartModel(aaChartModel)
        
        uiView.aa_onlyRefreshTheChartDataWithChartModelSeries([
            AASeriesElement().name(SERIES_TITLE)
                .data([data[0],data[1],data[2],data[3],data[4]]),
            
        ])
        //        uiView.aa_onlyRefreshTheChartDataWithChartModelSeries([["data": [data[0],data[1],data[2],data[3],data[4]] as AnyObject]])
        
    }
    
    func makeUIView(context: Context) -> AAChartView {
        
        let aaChartModel = AAChartModel()
            .chartType(areaType)
            .title("")
            .legendEnabled(false)
            .dataLabelsEnabled(true)
            
            //            .xAxisVisible(true)
            .animationType(animationType)
            .colorsTheme([hexColor])
            //            .colorsTheme(gradientColorArr as [Any])
            .touchEventEnabled(true)
            
            
            .markerRadius(1)
            .borderRadius(10)
            .polar(true)
            .axesTextColor(AAColor.rgbaColor(117, 122, 249, 1))
            
            //            .axesTextColor("Red")
            //            .xAxisGridLineWidth(30)
            
            .yAxisGridLineWidth(4)
            .categories(categories).dataLabelsFontSize(12)
            .dataLabelsFontWeight(AAChartFontWeightType.bold)
            //            .marginRight(5)
            //            .marginLeft(5)
            .marginBottom(50)
            .backgroundColor(Color.black.opacity(0.06))
            //            .titleFontWeight(AAChartFontWeightType)
            .series([
                AASeriesElement().name(SERIES_TITLE)
                    .data([data[0],data[1],data[2],data[3],data[4]]),
                
                
            ])
            .yAxisMax(Float(totalNum))
            .yAxisVisible(true)
        
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        
        return aaChartView
    }
}

