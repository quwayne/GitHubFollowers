
//
//  ErrorMessage.swift
//  GitHubFollowerProject
//
//  Created by Q B on 7/23/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import Foundation

enum GHFError: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToSave = "Sorry persistence failed. Please try again."
}

let buttonLabel = "OK"

