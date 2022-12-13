package com.hexagon.medicinebeauty;

import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;

/**
 * @data on 2020/9/7 5:59 PM
 * @auther   ArmStrong
 * @describe  //解决项目 类+方法数>65536 的bug问题
 */
public class WanAdroidApplication extends MultiDexApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        MultiDex.install(this); //必须
    }
}
