package com.github.hebertialmeida.modelgen

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import com.github.hebertialmeida.modelgen.Avatar
import com.github.hebertialmeida.modelgen.models.Company
import java.util.Date

/// Definition of a User
@Parcelize
data class User(
    val avatar: Avatar,
    val companies: ArrayList<Company>,
    val createdAt: Date,
    val currentCompanyId: Int,
    val email: String,
    val fullName: String,
    val id: Int,
    val timezone: String?
): Parcelable
