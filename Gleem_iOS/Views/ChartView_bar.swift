//
//  ChartView_bar.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 9/12/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//


import SwiftUI
import AAInfographics

struct ChartView_BAR: UIViewRepresentable {
    
    @Binding var data : [Double]
    @Binding var numVote : [Int]

    @Binding var totalNum : Int
    var categories : [String]
    let hexColor = "#757AF9"
    //        "#A3ADF9"
    let areaType = AAChartType.area
    let aaChartView = AAChartView()
    let animationType : AAChartAnimationType = AAChartAnimationType.bounce
    let gradientColorDic = [
          "linearGradient": [
              "x1": 0,
              "y1": 0,
              "x2": 0,
              "y2": 1
          ],
          "stops": [[0,"#f093fb"],
                    [1,"#f5576c"]]//颜色字符串设置支持十六进制类型和 rgba 类型
          ] as [String : AnyObject]
    
    
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
    
    func updateUIView(_ uiView: AAChartView, context:  UIViewRepresentableContext<Self>) {
        
        
        uiView.aa_onlyRefreshTheChartDataWithChartModelSeries([
            AASeriesElement().name(SERIES_TITLE)
//                .dataSorting(AADataSorting()
//               .enabled(true).matchByName(true))
                .data([data[0],data[1],data[2],data[3],data[4]]),
            AASeriesElement()
            .name("받은 투표순")
            .type(.line)
//            .yAxis(0)
//                .dataSorting(AADataSorting()
//            .enabled(true).matchByName(true))
            .data([numVote[0],numVote[1],numVote[2],numVote[3],numVote[4]]).color(AAGradientColor.mysticMauve)
//            .data([numVote[0], numVote[1], numVote[2], numVote[3], numVote[4]])
        ])
        //        uiView.aa_onlyRefreshTheChartDataWithChartModelSeries([["data": [data[0],data[1],data[2],data[3],data[4]] as AnyObject]])
        
    }
    
    func makeUIView(context: Context) -> AAChartView {
        let element3 = AASeriesElement()
             .name("받은 투표순")
             .type(.line)
//             .yAxis(0)
//            .dataSorting(AADataSorting()
//             .enabled(true).matchByName(true))
             .data([numVote[0],numVote[1],numVote[2],numVote[3],numVote[4]]).color(AAGradientColor.mysticMauve)
        
        
        let aaChartModel = AAChartModel()
            .chartType(.bar)
            .title("").titleFontColor(AAColor.rgbaColor(86, 98, 112, 1)).titleFontSize(17)
            //            .subtitle("gradient color bar")
            .yAxisGridLineWidth(0)
            .borderRadius(5)
            .categories(categories)
            .xAxisReversed(true)
            .series([
                AASeriesElement().name(SERIES_TITLE)
//                    .dataSorting(AADataSorting()
//                .enabled(true).matchByName(true))
                    .data([data[0],data[1],data[2],data[3],data[4]]).color(gradientColorDic),
            
             element3
            
            ])
  
                 
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        return aaChartView
    }
   
    
}

