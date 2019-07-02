package com.github.hebertialmeida.modelgen.models

/// Definition of a Company
data class Company(
    val id: Int,
    val logo: Uri?,
    val name: String,
    val subdomain: String
)
