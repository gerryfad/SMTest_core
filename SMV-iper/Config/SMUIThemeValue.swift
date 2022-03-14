//
//  SMUIThemeValue.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/07/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import Foundation

// Sesuaikan Tema yang akan dipakai
// Ubah kode warna dan tema button sesuai requirement
// Jika dibutuhkan, tambahkan komponen color atau view sesuai requirement

// MARK: COLOR
struct SMColorString {
    let primary = "#DC143C" //
    let secondary = "#B22222" //
    let accent = "#F08080"
    let custom = "#FA8072"
}

struct SMColor {
    let primary = UIColor(hexString: SMUITheme.colorString.primary, alpha: 1.0) ?? .black
    let secondary = UIColor(hexString: SMUITheme.colorString.secondary, alpha: 1.0) ?? .black
    let accent = UIColor(hexString: SMUITheme.colorString.accent, alpha: 1.0) ?? .black
    let custom = UIColor(hexString: SMUITheme.colorString.custom, alpha: 1.0) ?? .black
}

// MARK: BUTTON
//

struct SMUIButton {
    let primary = SMButtonTheme(titleColor: .white, backgroundColor: SMUITheme.color.primary, font: .systemFont(ofSize: 12), cornerRadius: 7.0)
    let secondary = SMButtonTheme(titleColor: SMUITheme.color.primary, backgroundColor: .white, font: .systemFont(ofSize: 12), cornerRadius: 7.0)
    let accent = SMButtonTheme(titleColor: .white, backgroundColor: SMUITheme.color.accent, font: .systemFont(ofSize: 12), cornerRadius: 7.0)
    let custom = SMButtonTheme(titleColor: .white, backgroundColor: SMUITheme.color.custom, font: .boldSystemFont(ofSize: 10), cornerRadius: 15.0)
}

// MARK: LABEL
//

struct SMUILabel {
    
    let heading = SMLabelTheme(
        font: .systemFont(ofSize: 15, weight: .medium),
        textColor: SMUITheme.color.primary)
    
    let normal = SMLabelTheme(
        font: .systemFont(ofSize: 13),
        textColor: SMUITheme.color.primary)
    
    let strong = SMLabelTheme(
        font: .systemFont(ofSize: 13, weight: .medium),
        textColor: UIColor(hex: 0x333333))
    
    let sub = SMLabelTheme(
        font: .italicSystemFont(ofSize: 12),
        textColor: UIColor(hex: 0x8b8b8b))
}

// MARK: NAVBAR
//

struct SMNavTheme {
    let backgroundColor = SMUITheme.color.primary
    let tintColor = UIColor.white
}

// MARK: TABBAR
//

struct SMTabBarTheme {
    var barTintColor: UIColor = .white
    var tintColor: UIColor = SMUITheme.color.primary
    var unselectedItemTintColor: UIColor = .lightGray
}
