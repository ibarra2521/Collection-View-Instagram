//
//  WebserviceHelper.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import Foundation

protocol WebserviceHelperDelegate {
    func webserviceHelper (itemsSection: Section)
}
// Step 3.1
class WebserviceHelper: ParsingHelperDelegate {
    
    var delegate: WebserviceHelperDelegate?
    let urlWebService = "https://api.instagram.com/v1/tags/selfie/media/recent?client_id=88f7623494e84396a6f1f426bb7933ff"
    // Step 3.3.1
    var parsingHelper = ParsingHelper()
    
    init() {
        // Step 3.3.2
        parsingHelper.delegate = self
    }
    
    func loadDataFromWebService(sectionName: String) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlWebService)
        
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                // Step 4.2
                self.parsingHelper.parseData(sectionName, data: data!);
            }
        }
        task.resume()
    }
    
    // Step 3.2
    func parsingHelperHelper(itemsSection: Section) {
        self.delegate?.webserviceHelper(itemsSection)
    }

}