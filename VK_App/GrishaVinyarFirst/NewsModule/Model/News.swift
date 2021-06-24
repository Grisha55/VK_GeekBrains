//
//  News.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.06.2021.
//

import Foundation

// MARK: - NewsList
struct NewsList: Codable {
    let response: NewsResponse?
}

// MARK: - NewsResponse
struct NewsResponse: Codable {
    let items: [News]?
    let groups: [GroupList]?
    let profiles: [Profile]?
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, groups, profiles
        case nextFrom = "next_from"
    }
}

// MARK: - News
struct News: Codable {
    let comments: Comments?
    let likes: PhotoLikes?
    let reposts: Reposts?
    let type: String?
    let postType: String?
    let date: Double?
    let sourceID: Int?
    let text: String?
    let attachments: [Attachment]?
    let postID: Int?
    var sourceName: String?
    var sourcePhoto: String?

    enum CodingKeys: String, CodingKey {
        case comments, type, likes, reposts
        case postType = "post_type"
        case date
        case sourceID = "source_id"
        case text
        case attachments
        case postID = "post_id"
        case sourceName, sourcePhoto
    }
}

// MARK: - Comments
struct Comments: Codable {
    let count, canPost: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String?
    let photo: PhotoNews?
}

// MARK: - Photo
struct PhotoNews: Codable {
    let id: Int?
    let photo2560, photo807, photo1280: String?
    let width: Int?
    let accessKey: String?
    let photo604, photo130: String?
    let userID: Int?
    let date, ownerID: Int?
    let height: Int?
    let text: String?
    let hasTags: Bool?
    let albumID: Int?
    let photo75: String?
    let sizes: [PhotoSizes]?

    enum CodingKeys: String, CodingKey {
        case id
        case photo2560 = "photo_2560"
        case photo807 = "photo_807"
        case photo1280 = "photo_1280"
        case width
        case accessKey = "access_key"
        case photo604 = "photo_604"
        case photo130 = "photo_130"
        case userID = "user_id"
        case date
        case ownerID = "owner_id"
        case height, text
        case hasTags = "has_tags"
        case albumID = "album_id"
        case photo75 = "photo_75"
        case sizes
    }
}

struct PhotoSizes: Codable {
    let url: String?
}

// MARK: - Reposts
struct Reposts: Codable {
    let count, userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Profile
struct Profile: Codable {
    let online, id: Int?
    let photo: String?
    let lastName: String?
    let sex: Int?
    let screenName, firstName: String?
    var name: String? {
        if firstName == "" && lastName == "" {
            return "No name"
        } else {
            return (firstName ?? "") + " " + (lastName ?? "")
        }
    }

    enum CodingKeys: String, CodingKey {
        case online, id
        case photo = "photo_100"
        case lastName = "last_name"
        case sex
        case screenName = "screen_name"
        case firstName = "first_name"
    }
}
