//
//  PostManagerParser.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift
import JavaScriptCore

enum PostManagerParserError: Error {
    case authorModelIsNotFound
    case parseError
}

protocol PostManagerParser {
    func makePostModel(_ content: NodeContentModel, _ accounts: [NodeAccountModel]) -> Observable<PostModel>
}

final class PostManagerParserImp: PostManagerParser {
    
    let jsContext: JSContext
    
    init() {
        jsContext = JSContext()
        configureJSContext()
    }
    
    func configureJSContext() {
        guard let filePath = Bundle.main.path(forResource: Constants.fileName, ofType: Constants.fileExt) else {
            assertionFailure("Bundle.js is not found!")
            return
        }
        
        do {
            let jsSourceContents = try String(contentsOfFile: filePath)
            jsContext.evaluateScript(jsSourceContents)
        } catch {
            Log.handleError(error)
        }
        
        jsContext.exceptionHandler = { context, exception in
            guard let exc = exception else { return }
            Log.error("JS Exception: %@", exc.toString())
        }
    }
    
    func pasreBodyPost(body: String) -> BodyPostModel? {
        guard let jsObject = jsContext.objectForKeyedSubscript("main") else { return nil }
        
        if let bodyString = jsObject.invokeMethod("default", withArguments: [body])?.toString(),
            let bodyData = bodyString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(BodyPostModel.self, from: bodyData)
            } catch {
                Log.handleError(error)
            }
        }
        return nil
    }
    
    func makePostModel(_ content: NodeContentModel, _ accounts: [NodeAccountModel]) -> Observable<PostModel> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self = self,
                let authorNodeModel = accounts.first(where: { $0.name == content.author }) else {
                observer.onError(PostManagerParserError.authorModelIsNotFound)
                return Disposables.create()
            }
            let authorMeta = authorNodeModel.getMeta()?.profile
            let postMeta = content.getMeta()
            
            let author = AccountModel(name: authorNodeModel.name,
                                      profileImage: authorMeta?.profileImage,
                                      coverImage: authorMeta?.coverImage,
                                      about: authorMeta?.about,
                                      github: authorMeta?.github,
                                      website: authorMeta?.website)
            
            guard let bodyModel = self.pasreBodyPost(body: content.body) else {
                observer.onError(PostManagerParserError.parseError)
                return Disposables.create()
            }
            let tags = bodyModel.hashtags + bodyModel.usertags + (postMeta?.tags ?? [])
            
            let location: String?
            if let postLocation = postMeta?.location {
                location = postLocation.properties.name.isEmpty ?
                    postLocation.properties.desc :
                    postLocation.properties.name
            } else {
                location = nil
            }
            let bodyHTML = self.normalizeHTML(bodyModel.html)
            let postModel = PostModel(id: content.id,
                                      url: content.url,
                                      category: content.category,
                                      permlink: content.permlink,
                                      created: content.created,
                                      lastUpdate: content.lastUpdate,
                                      title: content.title,
                                      description: bodyModel.html.removeTags(),
                                      location: location,
                                      bodyHTML: bodyHTML,
                                      images: bodyModel.images,
                                      tags: tags,
                                      author: author,
                                      votes: content.activeVotes.map { $0.voter })
            observer.onNext(postModel)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func normalizeHTML(_ html: String) -> String {
        guard let pathsCSS =  Bundle.main.path(forResource: "style", ofType: "css"),
            let rawCSS = try? String(contentsOfFile: pathsCSS, encoding: .utf8) else {
            return html
        }
        let rawHtml = html.replacingOccurrences(of: "<[^>][html, body]+>",
                                                with: "",
                                                options: .regularExpression,
                                                range: nil)
        let startPage = """
        <html><head>
        <meta charset="utf-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1">
        <style>\(rawCSS)</style>
        </head><body ontouchstart="">
        """
        let closePage = "</body></html>"
        return startPage + rawHtml + closePage
    }
}

private extension PostManagerParserImp {
    private enum Constants {
        static let fileName = "bundle"
        static let fileExt = "js"
    }
}
