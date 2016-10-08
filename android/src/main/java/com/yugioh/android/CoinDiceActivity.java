package com.yugioh.android;

import android.app.Fragment;

import com.yugioh.android.base.BaseActivity;
import com.yugioh.android.fragments.CoinDiceFragment;

public class CoinDiceActivity extends BaseActivity {

	@Override
	public int getIcon() {
		return R.drawable.icon;
	}

	@Override
	public Fragment replaceFragment() {
		return new CoinDiceFragment();
	}

    @Override
    public int customTheme() {
        return 0;
    }

}
