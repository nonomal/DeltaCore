//
//  DeltaCoreProtocol.swift
//  DeltaCore
//
//  Created by Riley Testut on 6/29/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import AVFoundation

public protocol DeltaCoreProtocol: CustomStringConvertible
{
    /* General */
    var name: String { get }
    var identifier: String { get }
    var version: String? { get }
    
    var gameType: GameType { get }
    var gameSaveFileExtension: String { get }
    
    // Should be associated type, but Swift type system makes this difficult, so ¯\_(ツ)_/¯
    var gameInputType: Input.Type { get }
    
    /* Rendering */
    var audioFormat: AVAudioFormat { get }
    var videoFormat: VideoFormat { get }
    
    /* Cheats */
    var supportedCheatFormats: Set<CheatFormat> { get }
    
    /* Emulation */
    var emulatorBridge: EmulatorBridging { get }
    
    var resourceBundle: Bundle { get }
}

public extension DeltaCoreProtocol
{
    var version: String? {
        return nil
    }
    
    var resourceBundle: Bundle {
        #if FRAMEWORK
        let bundle = Bundle(for: type(of: self.emulatorBridge))
        #elseif STATIC_LIBRARY || SWIFT_PACKAGE
        let bundle: Bundle
        if let bundleURL = Bundle.main.url(forResource: self.name, withExtension: "bundle")
        {
            bundle = Bundle(url: bundleURL)!
        }
        else
        {
            bundle = Bundle(for: type(of: self.emulatorBridge))
        }
        #else
        let bundle = Bundle.main
        #endif
        
        return bundle
    }
    
    var directoryURL: URL {
        let directoryURL = Delta.coresDirectoryURL.appendingPathComponent(self.name, isDirectory: true)
        
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        
        return directoryURL
    }
}

public extension DeltaCoreProtocol
{
    var description: String {
        let description = "\(self.name) (\(self.identifier))"
        return description
    }
}

public func ==(lhs: DeltaCoreProtocol?, rhs: DeltaCoreProtocol?) -> Bool
{
    return lhs?.identifier == rhs?.identifier
}

public func !=(lhs: DeltaCoreProtocol?, rhs: DeltaCoreProtocol?) -> Bool
{
    return !(lhs == rhs)
}

public func ~=(lhs: DeltaCoreProtocol?, rhs: DeltaCoreProtocol?) -> Bool
{
    return lhs == rhs
}
