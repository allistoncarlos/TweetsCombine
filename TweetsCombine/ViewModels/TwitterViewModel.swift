//
//  TwitterViewModel.swift
//  TweetsCombine
//
//  Created by Alliston Aleixo on 14/10/21.
//

import Foundation
import Combine

class TwitterViewModel {
   let tweets = CurrentValueSubject<[Tweet], Never>([Tweet]())
   let searchText = CurrentValueSubject<String, Never>("")
           
   let twitterAPI = TwitterAPI()
   var subscriptions = Set<AnyCancellable>()

   let isTwitterConnected = CurrentValueSubject<Bool, Never>(false)
   let errorMessage = CurrentValueSubject<String?, Never>(nil)

   init() {
      twitterAPI.verifyCredentials()
         .sink { [unowned self] (completion) in
             switch completion {
             case .failure(let error):
                 self.errorMessage.send(error.localizedDescription)
             case .finished: return
             }
         } receiveValue: { [unowned self] (username, id) in
             print("success")
             self.isTwitterConnected.send(true)
             self.setupSearch()
         }.store(in: &subscriptions)
   }

   func setupSearch() {
      searchText
         .removeDuplicates()
         .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
         .map { [unowned self] (searchText) -> AnyPublisher<[Tweet], Never> in
             self.twitterAPI.getSearchTweets(with: searchText)
                 .catch { (error) in
                     Just([Tweet]())
                 }
                 .eraseToAnyPublisher()
         }
         .switchToLatest()
         .sink { [unowned self] (tweets) in
             self.tweets.send(tweets)
         }.store(in: &subscriptions)
   }
}
