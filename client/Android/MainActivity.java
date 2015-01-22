package com.cnoam.ad;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.cnoam.ad.R;

public class MainActivity extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sample_main);

        Handler handler = new Handler(){
            public void handleMessage(Message msg) {
                String result = (String) msg.obj;
                Log.v("got result", result);
            };
        };

        new TrackingSenderTask(handler).execute("http://t.cnoam.com/tracking");
    }

}
