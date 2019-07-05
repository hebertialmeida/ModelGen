package com.github.hebertialmeida.modelgen.models;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.net.Uri;

/// Definition of a Company
public final class Company {

    final int id;
    final @Nullable Uri logo;
    final @NonNull String name;
    final @NonNull String subdomain;

    public Company(
            int id,
            @Nullable Uri logo,
            @NonNull String name,
            @NonNull String subdomain
            ) {

        this.id = id;
        this.logo = logo;
        this.name = name;
        this.subdomain = subdomain;
    }

    public int getId() {
        return id;
    }

    @Nullable
    public Uri getLogo() {
        return logo;
    }

    @NonNull
    public String getName() {
        return name;
    }

    @NonNull
    public String getSubdomain() {
        return subdomain;
    }

}
