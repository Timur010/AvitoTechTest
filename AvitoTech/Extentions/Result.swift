//
//  Result.swift
//  AvitoTech
//
//  Created by timur on 21.10.2022.
//

import Foundation

enum ObtainResult {
    
    case success(employee: [Employee])
    case failure(error: Error)
    
}
