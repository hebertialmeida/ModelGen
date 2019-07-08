package com.github.hebertialmeida.modelgen

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import android.net.Uri

@Parcelize
data class Avatar(
    val original: Uri?,
    val photo: ByteArray?,
    val small: Uri?
): Parcelable
