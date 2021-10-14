//
//  TwitterAPI.swift
//  TweetsCombine
//
//  Created by Alliston Aleixo on 14/10/21.
//

import Foundation
import STTwitter
import Combine

struct TwitterAPI {
   var api: STTwitterAPI? = nil
   
   init() {
       guard let key = Bundle.main.infoDictionary?["TWITTER_KEY"] as? String,
             let secret = Bundle.main.infoDictionary?["TWITTER_SECRET"] as? String
       else { return }
       
       print(key)
       print(secret)
       
       api = STTwitterAPI(appOnlyWithConsumerKey: key, consumerSecret: secret)
   }

   func verifyCredentials() -> Future<(String?, String?), Error> {
       Future { promise in
           api?.verifyCredentials(userSuccessBlock: { (username, userId) in
               promise(.success((username, userId)))
           }, errorBlock: { (err) in
               promise(Result.failure(err!))
          })
      }
   }

   func getSearchTweets(with query: String) -> AnyPublisher<[Tweet], Error> {
      Future { promise in
         api?.getSearchTweets(withQuery: query, successBlock: { (data, res) in
               promise(.success(res))
         }, errorBlock: { (err) in
               promise(.failure(err!))
         })
       }
       .compactMap({ $0 })
       .tryMap { try JSONSerialization.data(withJSONObject: $0,  options: .prettyPrinted)  }
       .decode(type: [Tweet].self, decoder: jsonDecoder)
       .eraseToAnyPublisher()
  }
       
   var jsonDecoder: JSONDecoder {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return decoder
   }
}
