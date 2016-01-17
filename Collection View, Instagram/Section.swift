//
//  Section.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import Foundation
import UIKit

class Section {
    var nombre:String
    var images: [UIImage]?
    var imagesUrl: [String]
    
    init(nombre: String, imagesUrl: [String]) {
        self.nombre = nombre
        self.imagesUrl = imagesUrl
    }
}
