package com.yugioh.android.base;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.Window;
import android.widget.RelativeLayout;
import com.yugioh.android.R;
import com.yugioh.android.utils.DrawableUtils;
import com.yugioh.android.utils.UIUtils;

public abstract class InnerActivity extends Activity implements
        OnGlobalLayoutListener {

    protected ActionBar bar;
    protected RelativeLayout layoutReplacement;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        if (customTheme() != 0) {
            setTheme(customTheme());
        }
        requestWindowFeature(Window.FEATURE_ACTION_BAR);
        super.onCreate(savedInstanceState);

        if (getCondition()) {
            finish();
            return;
        }

        setContentView(getBaseLayout());

        layoutReplacement = (RelativeLayout) findViewById(R.id.layoutReplacement);
        layoutReplacement.getViewTreeObserver().addOnGlobalLayoutListener(this);
        layoutReplacement.setBackgroundDrawable(UIUtils.isFollowSystemBackground() ? DrawableUtils.getSystemAttrDrawable(this, DrawableUtils.DETAILS_ELEMENT_BACKGROUND) : null);

        bar = getActionBar();
        if (bar != null) {
            bar.setIcon(getIcon());
            bar.setDisplayOptions(0, ActionBar.DISPLAY_HOME_AS_UP);
            bar.setDisplayHomeAsUpEnabled(true);
        }

        replace();
    }

    public void replace() {
        Fragment bf = replaceFragment();
        getFragmentManager().beginTransaction().replace(getReplaceId(), bf).commit();
    }

    public abstract int getIcon();

    public abstract boolean getCondition();

    public abstract int getBaseLayout();

    public abstract int getReplaceId();

    public abstract Fragment replaceFragment();

    public abstract int customTheme();

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onGlobalLayout() {
        onLayoutReady();
    }

    protected void onLayoutReady() {

    }

}
