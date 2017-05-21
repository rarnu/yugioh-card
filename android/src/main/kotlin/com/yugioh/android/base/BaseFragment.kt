package com.yugioh.android.base


/**
 * Created by rarnu on 3/23/16.
 */
abstract class BaseFragment: InnerFragment {

    constructor(): super()

    constructor(tabTitle: String): super(tabTitle)

}