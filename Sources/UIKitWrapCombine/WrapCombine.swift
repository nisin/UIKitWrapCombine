//
//  WrapCombine.swift
//  UIKitWrapCombine
//
//  Created by 疋田 将一 on 2020/07/16.
//  Copyright © 2020 充実工房. All rights reserved.
//

import Foundation

public protocol WrapCombineCompatible {
    associatedtype WrapType
    
    var wrap: WrapType { get }
}
public enum WrapCombine {
    public final class Wrapper<Base> {
        let base: Base
        
        init(_ base: Base) { self.base = base }
    }
}

extension WrapCombineCompatible {
    public var wrap: WrapCombine.Wrapper<Self> { WrapCombine.Wrapper(self) }
}
