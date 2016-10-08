package com.yugioh.android;

import android.app.Fragment;
import com.yugioh.android.base.BaseActivity;
import com.yugioh.android.fragments.DeckCardFragment;

public class DeckCardActivity extends BaseActivity {
    @Override
    public int getIcon() {
        return R.drawable.icon;
    }

    @Override
    public Fragment replaceFragment() {
        DeckCardFragment dcf = new DeckCardFragment();
        dcf.setArguments(getIntent().getExtras());
        return dcf;
    }

    @Override
    public int customTheme() {
        return 0;
    }
}
