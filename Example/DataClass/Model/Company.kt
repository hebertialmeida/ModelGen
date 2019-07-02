package com.github.hebertialmeida.modelgen.models

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

/// Definition of a Company
@Parcelize
data class Company(
    val id: Int,
    val logo: android.net.Uri?,
    val name: String,
    val subdomain: String
): Parcelable
