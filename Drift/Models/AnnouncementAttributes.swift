//
//  AnnouncementAttributes.swift
//  Driftt
//
//  Created by Eoin O'Connell on 22/01/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import ObjectMapper

class AnnouncementAttributes: Mappable {
    
    var cta: CTA?
    var title: String?
    var campaignId: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cta         <- map["cta"]
        title       <- map["title"]
        campaignId  <- map["campaignId"]
    }
    
}
