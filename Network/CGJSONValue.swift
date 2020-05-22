//
//  CGJSONValue.swift
//  CGLibrary
//
//  Created by Chang gyun Park on 2020/05/23.
//

import Foundation

@dynamicMemberLookup
public enum CGJSONValue: Codable {
    
    case string(String)
    case int(Int)
    case double(Double)
    case float(Float)
    case bool(Bool)
    case dictionary([String: CGJSONValue])
    case array([CGJSONValue])
    case data(Data)
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string): try container.encode(string)
        case .int(let int): try container.encode(int)
        case .double(let double): try container.encode(double)
        case .float(let float): try container.encode(float)
        case .bool(let bool): try container.encode(bool)
        case .dictionary(let dictionary): try container.encode(dictionary)
        case .array(let array): try container.encode(array)
        case .data(let data): try container.encode(data)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try ((try? container.decode(String.self)).map(CGJSONValue.string))
            .or((try? container.decode(Int.self)).map(CGJSONValue.int))
            .or((try? container.decode(Double.self)).map(CGJSONValue.double))
            .or((try? container.decode(Float.self)).map(CGJSONValue.float))
            .or((try? container.decode(Bool.self)).map(CGJSONValue.bool))
            .or((try? container.decode([String: CGJSONValue].self)).map(CGJSONValue.dictionary))
            .or((try? container.decode([CGJSONValue].self)).map(CGJSONValue.array))
            .or((try? container.decode(Data.self)).map(CGJSONValue.data))
            .resolve(with: DecodingError.typeMismatch(CGJSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "데이터 형식이 올바르지 않습니다.")))
    }
    
}


// MARK: - 타입 체크
extension CGJSONValue {
    public var stringValue: String? {
        get {
            if case .string(let str) = self {
                return str
            }
            return nil
        }
        set {
            self = CGJSONValue.string(newValue ?? "")
        }
    }
    
    public var intValue: Int? {
        if case .int(let int) = self {
            return int
        }
        return nil
    }
    
    public var doubleValue: Double? {
        if case .double(let double) = self {
            return double
        }
        return nil
    }
    
    public var floatValue: Float? {
        if case .float(let float) = self {
            return float
        }
        return nil
    }
    
    public var boolValue: Bool? {
        if case .bool(let bool) = self {
            return bool
        }
        return nil
    }
    
    public var arrayObject: Array<CGJSONValue>? {
        get {
            if case .array(let arr) = self {
                return arr
            }
            return nil
        }
        set {
            self = CGJSONValue.array(newValue ?? [])
        }
    }
    
    public var dicObject: Dictionary<String, CGJSONValue>? {
        get {
            if case .dictionary(let dic) = self {
                return dic
            }
            return nil
        }
        set {
            self = CGJSONValue.dictionary(newValue ?? [:])
        }
        
    }
    
    public var dataObject: Data? {
        get {
            if case .data(let data) = self {
                return data
            }
            return nil
        }
        set {
            self = CGJSONValue.data(newValue ?? Data.init())
        }
    }
    
    subscript(dynamicMember member: String) -> CGJSONValue? {
        if case .dictionary(let dict) = self {
            return dict[member]
        }
        return nil
    }
    
    subscript(index: Int) -> CGJSONValue? {
        if case .array(let arr) = self {
            return index < arr.count ? arr[index] : nil
        }
        return nil
    }
}

// MARK: - 옵셔널 체크
extension Optional {
    func or(_ other: Optional) -> Optional {
        switch self {
        case .none: return other
        case .some: return self
        }
    }
    
    func resolve(with error: @autoclosure () -> DecodingError) throws -> Wrapped {
        switch self {
        case .none: throw error()
        case .some(let wrapped): return wrapped
        }
    }
}
