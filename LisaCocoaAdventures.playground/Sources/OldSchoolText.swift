//
//  OldSchoolText.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 29/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

public class OldSchoolText:SKLabelNode{
  
  public convenience init(fontSize: CGFloat!,fontText:String){
    let fontURL = Bundle.main.url(forResource: "PixelFont", withExtension: "TTF")
    CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
    let bitFont = NSFont(name: "8BITWONDERNominal", size: fontSize)
    self.init(fontNamed: bitFont?.fontName)
    self.fontSize = fontSize
    self.numberOfLines = 0
    self.preferredMaxLayoutWidth = 550
    self.text = fontText
  }
}

