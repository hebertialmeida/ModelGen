package com.github.hebertialmeida.modelgen

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class Avatar(
    val original: android.net.Uri?,
    val small: android.net.Uri?
): Parcelable
