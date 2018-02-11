//
//  DriftAPIManager.swift
//  Drift
//
//  Copyright © 2016 Drift. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class DriftAPIManager: Alamofire.SessionManager {
    
    static let sharedManager: DriftAPIManager = {
        let configuration = URLSessionConfiguration.default
        let manager = DriftAPIManager(configuration: configuration)
        return manager
    }()
    
    class func getAuth(_ email: String, userId: String, redirectURL: String, orgId: Int, clientId: String, completion: @escaping (Result<Auth>) -> ()) {
        sharedManager.request(DriftCustomerRouter.getAuth(email: email, userId: userId, redirectURL: redirectURL, orgId: orgId, clientId: clientId)).responseJSON(completionHandler: { (response) -> Void in
            completion(mapResponse(response))
        })
    }
    
    class func getSocketAuth(accessToken: String, completion: @escaping (Result<SocketAuth>) -> ()) {
        sharedManager.request(DriftRouter.getSocketData(accessToken: accessToken)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }

    class func getEmbeds(_ embedId: String, refreshRate: Int?, completion: @escaping (Result<Embed>) -> ()){
        sharedManager.request(DriftRouter.getEmbed(embedId: embedId, refreshRate: refreshRate)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func getUser(_ userId: Int, orgId: Int, authToken:String, completion: @escaping (Result<[CampaignOrganizer]>) -> ()) {
        sharedManager.request(DriftCustomerRouter.getUser(orgId: orgId, userId: userId)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func getEndUser(_ endUserId: Int, authToken:String, completion: @escaping (Result<User>) -> ()){
        sharedManager.request(DriftCustomerRouter.getEndUser(endUserId: endUserId)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func postIdentify(_ orgId: Int, userId: String, email: String, attributes: [String: Any]?, completion: @escaping (Result<User>) -> ()) {
        var params: [String: Any] = [
            "orgId": orgId,
            "userId": userId,
            "attributes": ["email": email]
        ]
        
        if var attributes = attributes {
            attributes["email"] = email
            params["attributes"] = attributes
        }
        
        sharedManager.request(DriftRouter.postIdentify(params: params)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    
    class func recordAnnouncement(_ conversationId: Int, authToken: String, response: AnnouncementResponse) {
        let json: [String: Any] = [
            "type": "CONVERSATION_EVENT",
            "conversationEvent": ["type": response.rawValue]
        ]
    
        sharedManager.request(DriftConversationRouter.recordAnnouncement(conversationId: conversationId, json: json)).responseJSON(completionHandler: { (result) -> Void in
            switch result.result {
            case .success(let json):
                LoggerManager.log("Record Annouincment Success: \(json)")
            case .failure(let error):
                LoggerManager.log("Record Announcement Failure: \(error)")
            }
        })
    }
    
    class func recordNPS(_ conversationId: Int, authToken: String, response: NPSResponse){
        var attributes: [String: Any] = [:]
        
        switch response{
        case .dismissed:
            attributes = ["dismissed":true]
        case .numeric(let numeric):
            attributes = ["numericResponse":numeric]
        case .textAndNumeric(let numeric, let text):
            attributes = ["numericResponse":numeric, "textResponse": text]
        }
        
        let json: [String: Any] = [
            "type": "NPS_RESPONSE",
            "attributes": attributes
        ]
        
        sharedManager.request(DriftConversationRouter.recordNPS(conversationId: conversationId, json: json)).responseJSON(completionHandler: { (result) -> Void in
            
            switch result.result {
            case .success(let json):
                LoggerManager.log("Record NPS Success: \(json)")
            case .failure(let error):
                LoggerManager.log("Record NPS Failure: \(error)")
            }
        })
    }
    
    class func markMessageAsRead(messageId: Int, completion: @escaping (_ result: Result<Bool>) -> ()){
        sharedManager.request(DriftConversation2Router.markMessageAsRead(messageId: messageId)).responseString { (result) in
            switch result.result{
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    class func markConversationAsRead(messageId: Int, completion: @escaping (_ result: Result<Bool>) -> ()){
        sharedManager.request(DriftConversation2Router.markConversationAsRead(messageId: messageId)).responseString { (result) in
            switch result.result{
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    class func getCampaigns(_ endUserId: Int, completion: @escaping (_ result: Result<[CampaignWrapper]>) -> ()){
        sharedManager.request(DriftConversationRouter.getCampaignsForEndUser(endUserId: endUserId)).responseJSON { (result) in
            completion(mapResponse(result))
        }
    }
    
    class func getEnrichedConversations(_ endUserId: Int, completion: @escaping (_ result: Result<[EnrichedConversation]>) -> ()){
        sharedManager.request(DriftConversationRouter.getEnrichedConversationsForEndUser(endUserId: endUserId)).responseJSON { (result) in
            completion(mapResponse(result))
        }
    }
    
    class func getConversations(_ endUserId: Int, completion: @escaping (_ result: Result<[Conversation]>) -> ()){
        sharedManager.request(DriftConversationRouter.getConversationsForEndUser(endUserId: endUserId)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func getMessages(_ conversationId: Int, authToken: String, completion: @escaping (_ result: Result<[Message]>) -> ()){
        sharedManager.request(DriftConversationRouter.getMessagesForConversation(conversationId: conversationId)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func postMessage(_ conversationId: Int, message: Message, authToken: String, completion: @escaping (_ result: Result<Message>) -> ()){
        let json = message.toJSON()
        
        sharedManager.request(DriftConversationRouter.postMessageToConversation(conversationId: conversationId, data: json)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func createConversation(_ body: String, authorId:Int?, authToken: String, completion: @escaping (_ result: Result<Message>) -> ()){
        sharedManager.request(DriftConversationRouter.createConversation(body: body)).responseJSON(completionHandler: { (result) -> Void in
            completion(mapResponse(result))
        })
    }
    
    class func downloadAttachmentFile(_ attachment: Attachment, authToken: String, completion: @escaping (_ result: Result<URL>) -> ()){
        guard let url = URLStore.downloadAttachmentURL(attachment.id, authToken: authToken) else {
            LoggerManager.log("Failed in Download Attachment URL Creation")
            return
        }
        
        sharedManager.session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                LoggerManager.log("API Complete: \(response.statusCode) \(response.url?.path ?? "")")
            }
            
            if let data = data, let directoryURL = DriftManager.sharedInstance.directoryURL {
                let fileURL = directoryURL.appendingPathComponent("\(attachment.id)_\(attachment.fileName)")
                do {
                    try data.write(to: fileURL, options: .atomicWrite)
                    completion(.success(fileURL))
                } catch {
                    completion(.failure(DriftError.dataCreationFailure))
                }
            }else{
                completion(.failure(DriftError.apiFailure))
            }
        }) .resume()
    }
    
    class func getAttachmentsMetaData(_ attachmentIds: [Int], authToken: String, completion: @escaping (_ result: Result<[Attachment]>) -> ()){
        
        guard let url = URLStore.getAttachmentsURL(attachmentIds, authToken: authToken) else {
            LoggerManager.log("Failed in Get Attachment Metadata URL Creation")
            return
        }
        
        sharedManager.request(URLRequest(url: url)).responseJSON(completionHandler: { (result) in
            completion(mapResponse(result))
        })
    }
    
    class func postAttachment(_ attachment: Attachment, authToken: String, completion: @escaping (_ result: Result<Attachment>) ->()){

        let boundary = "Boundary-\(UUID().uuidString)"
        let requestURL = URLStore.postAttachmentURL(authToken)
        
        let request = NSMutableURLRequest(url: requestURL!)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let multipartBody = NSMutableData()
        multipartBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        multipartBody.append("Content-Disposition: form-data; name=\"conversationId\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        multipartBody.append("\(attachment.conversationId)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        multipartBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        multipartBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        multipartBody.append("Content-Type: \(attachment.mimeType)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        multipartBody.append(attachment.data as Data)
        multipartBody.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        multipartBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        request.httpBody = multipartBody as Data
        sharedManager.session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                LoggerManager.log("API Complete: \(response.statusCode) \(response.url?.path ?? "")")
            }
            
            let accepted = [200, 201]
            
            if let response = response as? HTTPURLResponse, let data = data , accepted.contains(response.statusCode){
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                        if let attachment: Attachment = Mapper<Attachment>().map(JSON: json){
                            DispatchQueue.main.async(execute: {
                                completion(.success(attachment))
                            })
                            return
                        }
                    }
                } catch {
                    print(response.statusCode)
                    DispatchQueue.main.async(execute: {
                        completion(.failure(DriftError.apiFailure))
                    })
                }
            }else if let error = error {
                DispatchQueue.main.async(execute: {
                    completion(.failure(error))
                })
            }else{
                DispatchQueue.main.async(execute: {
                    completion(.failure(DriftError.apiFailure))
                })
            }
            
        }) .resume()
    }
    
    //Maps response to result T using ObjectMapper JSON parsing
    fileprivate class func mapResponse<T: Mappable>(_ result: DataResponse<Any>) -> Result<T> {
        
        switch result.result {
        case .success(let res):
            if let json = res as? [String : Any] {
                let response = Mapper<T>().map(JSON: json)     ///If initialisation is done in if let this can result in getting an object back when nil is returned - This is a bug in swift
                if let response = response {
                    return .success(response)
                }
            }
            fallthrough
        default:
            return .failure(DriftError.apiFailure)
        }
    }
    
    //Maps response to result [T] using ObjectMapper JSON parsing
    fileprivate class func mapResponse<T: Mappable>(_ result: DataResponse<Any>) -> Result<[T]> {
        
        switch result.result {
        case .success(let res):
            if let json = res as? [[String: Any]] {
                let response: [T] = Mapper<T>().mapArray(JSONArray: json)
                return .success(response)
            }
            fallthrough
        default:
            return .failure(DriftError.apiFailure)
        }
    }
    
}

class URLStore{
    
    class func postAttachmentURL(_ authToken: String) -> URL? {
        return URL(string: "https://conversation.api.drift.com/attachments?access_token=\(authToken)")
    }
    
    class func downloadAttachmentURL(_ attachmentId: Int, authToken: String) -> URL? {
        return URL(string: "https://conversation.api.drift.com/attachments/\(attachmentId)/data?access_token=\(authToken)")
    }
    
    class func getAttachmentsURL(_ attachmentIds: [Int], authToken: String) -> URL? {
        var params = ""
        for id in attachmentIds{
            params += "&id=\(id)"
        }
        params += "&img_auto=compress"

        return URL(string: "https://conversation.api.drift.com/attachments?access_token=\(authToken)\(params)")
    }
    
}

///Result object for either Success with sucessfully parsed T
enum Result<T> {
    case success(T)
    case failure(Error)
}
