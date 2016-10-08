package com.yugioh.android.loader;

import android.content.Context;
import com.yugioh.android.base.BaseLoader;
import com.yugioh.android.classes.DeckItem;
import com.yugioh.android.utils.YGOAPI;

import java.util.List;

public class DeckLoader extends BaseLoader<DeckItem> {
    public DeckLoader(Context context) {
        super(context);
    }

    @Override
    public List<DeckItem> loadInBackground() {
        return YGOAPI.getDeckList();
    }
}
