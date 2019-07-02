package com.github.hebertialmeida.modelgen

/// Definition of a User
data class User(
    val avatar: Avatar,
    val companies: Array<Company>,
    val createdAt: Date,
    val currentCompanyId: Int,
    val email: String,
    val fullName: String,
    val id: Int,
    val timezone: String?
)
