//
//  SourceEditorExtension.swift
//  SwiftConverterExtension
//
//  Created by Kentaro Matsumae on 2016/07/20.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        print(#function)
    }
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: AnyObject]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}
