//
//  Appearance.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

let fittingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

struct AppearanceFont {
    static let searchLabel      = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
    static let contentLabel     = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
    static let label            = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    static let sublabel         = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
    static let footerLabel      = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
    static let aCounterLabel    = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    static let inaCounterLabel  = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
}

struct AppearanceSize {
    static let avatarSize = CGSize(width: 36, height: 36)
    static let buttonSize = CGSize(width: 36, height: 36)
    static let inset: CGFloat = 8
    static let photoGalleryHeight: CGFloat = 335
    static let internalOffset: CGFloat = 10
    static let externalOffset: CGFloat = 12
    static let footerHeight: CGFloat = 60
    static let sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}

private let gray        = UIColor(hue: 216.0/365.0, saturation: 0.02, brightness: 0.94, alpha: 1)
private let water       = UIColor(hue: 212.0/365.0, saturation: 0.56, brightness: 0.72, alpha: 1)
private let winterGray  = UIColor(hue: 210.0/365.0, saturation: 0.06, brightness: 0.70, alpha: 1)
private let smokeGray   = UIColor(hue: 212.0/365.0, saturation: 0.16, brightness: 0.60, alpha: 1)
private let foggyGray   = UIColor(hue: 213.0/365.0, saturation: 0.06, brightness: 0.60, alpha: 1)
private let darkGray    = UIColor(hue: 210.0/365.0, saturation: 0.04, brightness: 0.18, alpha: 1)
private let hardlyGray  = UIColor(hue: 0, saturation: 0, brightness: 0.91, alpha: 1)
private let hardlyWhite = UIColor(hue: 0, saturation: 0.01, brightness: 0.98, alpha: 1)
private let lightGray   = UIColor.lightGray
private let white       = UIColor.white
private let black       = UIColor.black

struct AppearanceColor {
    static let viewBackground = white
    static let collectionBackground = gray
    
    static let label = darkGray
    static let sublabel = smokeGray
    static let contentLabel = black
    static let foggyLabel = foggyGray
    static let activeCounter = smokeGray
    static let inactiveCounter = winterGray
    static let pageControlNormal = lightGray
    static let pageControlHighlighted = water
    static let newsBackground = [hardlyWhite.cgColor, gray.cgColor]
    static let searchBackground = hardlyGray
}

struct Appearance {
    static func applyFor(newsFeedView view: UIView) {
        let gradient = CAGradientLayer(layer: view.layer)
        gradient.colors = AppearanceColor.newsBackground
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    static func applyFor(nameLabel label: UILabel) {
        label.font = AppearanceFont.label
        label.textColor = AppearanceColor.label
        label.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(dateLabel label: UILabel) {
        label.font = AppearanceFont.sublabel
        label.textColor = AppearanceColor.sublabel
        label.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(contentLabel label: UITextView) {
        label.font = AppearanceFont.contentLabel
        label.textColor = AppearanceColor.contentLabel
        label.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(footerLabel label: UILabel) {
        label.font = AppearanceFont.footerLabel
        label.textColor = AppearanceColor.foggyLabel
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
    }
    
    static func applyFor(cell: UICollectionViewCell) {
        cell.contentView.backgroundColor = AppearanceColor.viewBackground
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }
    
    static func applyFor(activeCounterButton button: UIButton) {
        button.tintColor = AppearanceColor.activeCounter
        button.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(activeCounterLabel label: UILabel) {
        label.font = AppearanceFont.aCounterLabel
        label.textColor = AppearanceColor.activeCounter
        label.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(inactiveCounterLabel label: UILabel) {
        label.font = AppearanceFont.inaCounterLabel
        label.textColor = AppearanceColor.inactiveCounter        
        label.backgroundColor = AppearanceColor.viewBackground
    }
    
    static func applyFor(searchTextField textField: UITextField) {
        textField.font = AppearanceFont.searchLabel
        textField.textColor = AppearanceColor.foggyLabel
        textField.backgroundColor = AppearanceColor.searchBackground
    }
    
    static func applyFor(searchView view: UIView) {
        view.backgroundColor = AppearanceColor.searchBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    
    static func configurePageControl() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = AppearanceColor.pageControlNormal
        pageControl.currentPageIndicatorTintColor = AppearanceColor.pageControlHighlighted
        pageControl.backgroundColor = AppearanceColor.viewBackground
    }
}
