package com.github.hebertialmeida.modelgen;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.net.Uri;

public final class Avatar {

    final @Nullable Uri original;
    final @Nullable byte[] photo;
    final @Nullable Uri small;

    public Avatar(
            @Nullable Uri original,
            @Nullable byte[] photo,
            @Nullable Uri small
            ) {

        this.original = original;
        this.photo = photo;
        this.small = small;
    }

    @Nullable
    public Uri getOriginal() {
        return original;
    }

    @Nullable
    public byte[] getPhoto() {
        return photo;
    }

    @Nullable
    public Uri getSmall() {
        return small;
    }

}
