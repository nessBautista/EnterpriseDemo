//
//  Constants.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import SwiftCharts
enum StoryboardsIds: String {
    case main = "Main"
    
}

struct Constants {
    static let kFinanceApi = "https://www.alphavantage.co/query"
    static let kTheGuardianApi = "https://content.guardianapis.com/search"
    
    static let  guardian = "https://content.guardianapis.com/search?api-key=4134ccef-13e1-45df-b406-7423ad88cd12&show-fields=thumbnail"
    
    struct ApiKey {
        static let kAlphavantage = "1730BP20UVXJEPF0"
        static let kTheGuardian = "4134ccef-13e1-45df-b406-7423ad88cd12"
    }
    
    struct services {
        static let timeSeriesByMonth = "TIME_SERIES_MONTHLY"
        static let foreignExchange = ""
    }
}



class Env {
    
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
struct ExamplesDefaults {
    
    static var chartSettings: ChartSettings {
        if Env.iPad {
            return iPadChartSettings
        } else {
            return iPhoneChartSettings
        }
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
        if Env.iPad {
            return iPadChartSettingsWithPanZoom
        } else {
            return iPhoneChartSettingsWithPanZoom
        }
    }
    
    fileprivate static var iPadChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPadChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: ExamplesDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 11)
    }
    
    static var labelFontSmall: UIFont {
        return ExamplesDefaults.fontWithSize(Env.iPad ? 12 : 10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return Env.iPad ? 0.5 : 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return Env.iPad ? 10 : 5
    }
}