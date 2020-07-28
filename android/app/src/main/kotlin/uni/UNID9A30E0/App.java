package uni.UNID9A30E0;

import android.app.Application;

import com.jarvanmo.rammus.RammusPlugin;

import io.flutter.app.FlutterApplication;

/**
 * Author: yyg
 * Date: 2020/7/28 17:30
 * Description:
 */
public class App extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        RammusPlugin.initPushService(this);
    }
}
