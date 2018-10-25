//
//  Utils.swift
//  merlinApp
//
//  Created by Devp.ios on 23/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//
import ObjectMapper

class IntTransform : TransformType {
    public typealias Object = Int
    public typealias JSON = Any?
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Int? {
        
        var result: Int?
        guard let json = value else {
            return result
        }
        if json is Int {
            result = (json as! Int)
        }
        if json is String {
            result = Int(json as! String)
        }
        return result
    }
    
    public func transformToJSON(_ value: Int?) -> Any?? {
        guard let object = value else {
            return nil
        }
        return String(object)
    }
}
