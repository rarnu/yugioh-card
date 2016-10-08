package com.yugioh.android.base;

public abstract class BaseFragment extends InnerFragment {

    public BaseFragment() {
        super();
    }

    public BaseFragment(String tabTitle) {
        super(tabTitle);
    }

    public BaseFragment(String tagText, String tabTitle) {
        super(tabTitle);
    }

}
