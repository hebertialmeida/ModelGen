//
//  User.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2019 ModelGen. All rights reserved.
//

import Unbox

/// Definition of a User
public class User: Equatable {

    // MARK: Instance Variables

    public var avatar: Avatar
    public var companies: [Company]
    public var createdAt: Date
    public var currentCompanyId: Int
    public var email: String
    public var fullName: String
    public var id: Int
    public var timezone: String?

    // MARK: - Initializers

    public init(avatar: Avatar, companies: [Company], createdAt: Date, currentCompanyId: Int, email: String, fullName: String, id: Int, timezone: String?) {
        self.avatar = avatar
        self.companies = companies
        self.createdAt = createdAt
        self.currentCompanyId = currentCompanyId
        self.email = email
        self.fullName = fullName
        self.id = id
        self.timezone = timezone
    }

    public init(unboxer: Unboxer) throws {
        self.avatar = try unboxer.unbox(key: "avatar")
        self.companies = try unboxer.unbox(key: "companies")
        self.createdAt = try unboxer.unbox(key: "created_at", formatter: Date.serverDateFormatter())
        self.currentCompanyId = try unboxer.unbox(key: "current_company_id")
        self.email = try unboxer.unbox(key: "email")
        self.fullName = try unboxer.unbox(key: "full_name")
        self.id = try unboxer.unbox(key: "id")
        self.timezone =  unboxer.unbox(key: "timezone")
    }
}

// MARK: - Equatable

public func == (lhs: User, rhs: User) -> Bool {
    guard lhs.avatar == rhs.avatar else { return false }
    guard lhs.companies == rhs.companies else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.currentCompanyId == rhs.currentCompanyId else { return false }
    guard lhs.email == rhs.email else { return false }
    guard lhs.fullName == rhs.fullName else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.timezone == rhs.timezone else { return false }
    return true
}