package com.github.hebertialmeida.modelgen.models

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import android.net.Uri

/// Definition of a Company
@Parcelize
data class Company(
    val id: Int,
    val logo: Uri?,
    val name: String,
    val subdomain: String
): Parcelable
