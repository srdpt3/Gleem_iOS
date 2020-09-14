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
    
    let gradientColorDic1 = AAGradientColor.linearGradient(
           direction: .toTop,
           startColor: "#f093fb",
           endColor: "#f5576c"//颜色字符串设置支持十六进制类型和 rgba 类型
       )
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
                .dataSorting(AADataSorting()
                    .enabled(true).matchByName(true))
                .data(randomDataArray())
            //            AASeriesElement()
            //            .name("받은 투표순")
            //            .type(.line)
            ////            .yAxis(0)
            ////                .dataSorting(AADataSorting()
            ////            .enabled(true).matchByName(true))
            //            .data([numVote[0],numVote[1],numVote[2],numVote[3],numVote[4]]).color(AAGradientColor.mysticMauve)
            //            .data([numVote[0], numVote[1], numVote[2], numVote[3], numVote[4]])
        ])
        //        uiView.aa_onlyRefreshTheChartDataWithChartModelSeries([["data": [data[0],data[1],data[2],data[3],data[4]] as AnyObject]])
        
    }
    
    func makeUIView(context: Context) -> AAChartView {
        //        let element3 = AASeriesElement()
        //             .name("받은 투표수")
        //             .type(.line)
        ////             .yAxis(0)
        ////            .dataSorting(AADataSorting()
        ////             .enabled(true).matchByName(true))
        //             .data([numVote[0],numVote[1],numVote[2],numVote[3],numVote[4]]).color(AAGradientColor.mysticMauve)
        //
        //
        //        let aaChartModel = AAChartModel()
        //            .chartType(.bar)
        //            .title("").titleFontColor(AAColor.rgbaColor(86, 98, 112, 1)).titleFontSize(17)
        //            //            .subtitle("gradient color bar")
        //            .yAxisGridLineWidth(0)
        //            .borderRadius(5)
        //            .categories(categories)
        //            .xAxisReversed(true)
        //
        //
        //
        //            .series([
        //                AASeriesElement().name(SERIES_TITLE)
        //                    .dataSorting(AADataSorting()
        //                .enabled(true).matchByName(true))
        ////                    .data([data[0],data[1],data[2],data[3],data[4]])
        //                      .data(randomDataArray())
        //                    .color(gradientColorDic),
        //
        ////             element3
        //
        //            ])
        //
        let colorArr = [
           gradientColorDic1,
            gradientColorDic1,
            gradientColorDic1,
            gradientColorDic1,
            gradientColorDic1
         ]
        let aaOptions = AAOptions()
            .colors(colorArr)
            .chart(AAChart().marginBottom(20)
                .type(AAChartType.bar)
        )
        .title(AATitle()
                    .text(""))
            .xAxis(AAXAxis()
                .visible(true)
                .reversed(true)
                .type("category")
        )
            .yAxis(AAYAxis()
                .visible(true)
                .gridLineWidth(0)
                .title((AATitle()
                    .text("")))
        )
            .legend(AALegend()
                .enabled(true)
                .align(.center)
                .layout(.vertical)
                .verticalAlign(.top)
                .y(2)
        )
            .tooltip(AATooltip()
                .enabled(true)
        )
                    
            .plotOptions(AAPlotOptions()
                .series(AASeries()
                    .dataLabels(AADataLabels()
                        .enabled(true)
                        .inside(true)//DataLabels是否在条形图的长条内部
                        .style(AAStyle()
                            .color(AAColor.white)
                            .fontWeight(.bold)
                            .fontSize(11)
                            .textOutline("none")//文字轮廓描边
                    ))
            ))
            .series([
                AASeriesElement()   .name(SERIES_TITLE)
                    .colorByPoint(true)
                    .dataSorting(AADataSorting()
                        .enabled(true)
                        .matchByName(true))
                    .data(randomDataArray())
            ])
        
        if (aaOptions.chart?.type == AAChartType.column.rawValue) {
            aaOptions.plotOptions?
                .column(AAColumn()
                    .pointPadding(0)
                    .groupPadding(0.1))
                .series?
                .dataLabels?.verticalAlign(.bottom)
        } else if (aaOptions.chart?.type == AAChartType.bar.rawValue) {
            aaOptions.plotOptions?
                .bar(AABar().borderRadius(5)
                    .pointPadding(0)
                    .groupPadding(0.2))
                .series?
                .dataLabels?
                .align(.left)//DataLabels水平对齐位置
        } else if (aaOptions.chart?.type == AAChartType.scatter.rawValue) {
            aaOptions.plotOptions?.series?
                .marker(AAMarker()
                    .radius(15))
                .dataLabels?.verticalAlign(.middle)
        }
//        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        aaOptions.touchEventEnabled = true
                      aaChartView.aa_drawChartWithChartOptions(aaOptions)
        
        return aaChartView
    }
    
    private func randomDataArray() -> [Any] {
 
        
        let dataArr = NSMutableArray()
        for  (index, element) in categories.enumerated() {
            let dataElementDic = NSMutableDictionary()
            dataElementDic["name"] = element
            dataElementDic["y"] = (data[index])
            dataArr.add(dataElementDic)
        }
        
        return dataArr as! [Any]
    }
    
    
}

