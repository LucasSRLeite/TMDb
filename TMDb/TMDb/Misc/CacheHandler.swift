//
//  CacheHandler.swift
//  TMDb
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Cache

/// Handles image cache storage with library Cache
struct ImageCacheHandler {
    static let shared = ImageCacheHandler()
    
    let storage: Storage<Data>?
    
    private init() {
        let diskConfig = DiskConfig(name: "ImageCache")
        let memoryConfig = MemoryConfig(expiry: .never)
        
        storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: Data.self))
    }
}
