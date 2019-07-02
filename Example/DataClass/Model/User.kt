package com.github.hebertialmeida.modelgen

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

/// Definition of a User
@Parcelize
data class User(
    val avatar: com.github.hebertialmeida.modelgen.Avatar,
    val companies: ArrayList<com.github.hebertialmeida.modelgen.models.Company>,
    val createdAt: java.util.Date,
    val currentCompanyId: Int,
    val email: String,
    val fullName: String,
    val id: Int,
    val timezone: String?
): Parcelable
