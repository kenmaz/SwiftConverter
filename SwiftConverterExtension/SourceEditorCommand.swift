//
//  SourceEditorCommand.swift
//  SwiftConverterExtension
//
//  Created by Kentaro Matsumae on 2016/07/20.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        print(#function)
        
        guard let selection =  invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "SwiftConverter", code: -1, userInfo: [NSLocalizedDescriptionKey: "None selection"]))
            return
        }
        
        let lines = NSMutableString()
        
        lines.append("@interface Dummy")
        lines.append("@end")
        lines.append("@implementation Dummy")
        
        for i in selection.start.line ... selection.end.line {
            guard let line = invocation.buffer.lines[i] as? String else {
                continue
            }
            lines.append(line)
        }
        
        lines.append("@end")

        let objcFilePath = "Dummy.m"
        
        let contents = lines.data(using: String.Encoding.utf8.rawValue)
        let res = FileManager.default().createFile(atPath: objcFilePath, contents: contents, attributes: nil)
        print(res)
        
        let jar2Path = Bundle.main().pathForResource("objc2swift-1.0", ofType: "jar")!
        let task = Task()
        task.launchPath = "/usr/bin/java"
        task.arguments = ["-jar", jar2Path, objcFilePath]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let res2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!

        var outlines = res2.components(separatedBy: "\n")
        outlines.removeSubrange(0...7)
        outlines.removeLast()
        outlines.removeLast()
        let swiftCode = outlines.joined(separator: "\n")
        
        let set = selection.start.line ... selection.end.line
        let indexSet = IndexSet(set)
        invocation.buffer.lines.removeObjects(at: indexSet)
        
        invocation.buffer.lines.insert(swiftCode, at: selection.start.line)
        
        completionHandler(nil)
    }
    
}
