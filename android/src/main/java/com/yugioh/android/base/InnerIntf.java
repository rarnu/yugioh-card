package com.yugioh.android.base;

import android.os.Bundle;
import android.view.Menu;

public interface InnerIntf {

    int getBarTitle();

    int getBarTitleWithPath();

    String getCustomTitle();

    void initComponents();

    void initEvents();

    void initLogic();

    int getFragmentLayoutResId();

    String getMainActivityName();

    void initMenu(Menu menu);

    void onGetNewArguments(Bundle bn);

    Bundle getFragmentState();
}
