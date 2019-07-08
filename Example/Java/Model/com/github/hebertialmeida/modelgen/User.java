package com.github.hebertialmeida.modelgen;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.github.hebertialmeida.modelgen.Avatar;
import com.github.hebertialmeida.modelgen.models.Company;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;

/// Definition of a User
public final class User {

    final @NonNull Avatar avatar;
    final @NonNull ArrayList<Company> companies;
    final @NonNull Date createdAt;
    final int currentCompanyId;
    final @NonNull String email;
    final @Nullable HashSet<Company> favoriteCompanies;
    final @NonNull String fullName;
    final int id;
    final @Nullable String timezone;

    public User(
            @NonNull Avatar avatar,
            @NonNull ArrayList<Company> companies,
            @NonNull Date createdAt,
            int currentCompanyId,
            @NonNull String email,
            @Nullable HashSet<Company> favoriteCompanies,
            @NonNull String fullName,
            int id,
            @Nullable String timezone
            ) {

        this.avatar = avatar;
        this.companies = companies;
        this.createdAt = createdAt;
        this.currentCompanyId = currentCompanyId;
        this.email = email;
        this.favoriteCompanies = favoriteCompanies;
        this.fullName = fullName;
        this.id = id;
        this.timezone = timezone;
    }

    @NonNull
    public Avatar getAvatar() {
        return avatar;
    }

    @NonNull
    public ArrayList<Company> getCompanies() {
        return companies;
    }

    @NonNull
    public Date getCreatedat() {
        return createdAt;
    }

    public int getCurrentcompanyid() {
        return currentCompanyId;
    }

    @NonNull
    public String getEmail() {
        return email;
    }

    @Nullable
    public HashSet<Company> getFavoritecompanies() {
        return favoriteCompanies;
    }

    @NonNull
    public String getFullname() {
        return fullName;
    }

    public int getId() {
        return id;
    }

    @Nullable
    public String getTimezone() {
        return timezone;
    }

}
