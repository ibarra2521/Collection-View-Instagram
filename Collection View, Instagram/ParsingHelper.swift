//
//  ParsingHelper.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import Foundation
import UIKit

// Step 1
protocol ParsingHelperDelegate {
    func parsingHelperHelper(itemsSection: Section)
}

class ParsingHelper: NSObject {
    // Step 2
    var delegate: ParsingHelperDelegate?
    
    // Step 4.1
    func parseData(sectionName: String, data: NSData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves)
            let shortDictonary = json.valueForKey("data") as! NSArray
            var imagesUrlArray = [String]()
            var imagesDataArray = [UIImage]()
            for dic in shortDictonary {
                let urlImage = (dic.valueForKey("images")?.valueForKey("standard_resolution")?.valueForKey("url") as? String!)!
                imagesUrlArray.append(urlImage)
                let imageData = UIImage(data: (NSData(contentsOfURL: NSURL(string: urlImage)!))!)
                imagesDataArray.append(imageData!)
            }
                
            dispatch_async(dispatch_get_main_queue(),{
                let section = Section(nombre: sectionName, imagesUrl: imagesUrlArray)
                section.images = imagesDataArray
                self.delegate!.parsingHelperHelper(section)
            })

            } catch {
                // Handle exception
            }
        });
    }

}