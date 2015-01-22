package com.cnoam.ad;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.params.ConnManagerParams;
import org.apache.http.conn.params.ConnPerRouteBean;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

public class TrackingSenderTask extends AsyncTask<String, Void, String> {

    private Handler _handler;

    public TrackingSenderTask(Handler handler) {//
        this._handler = handler;
    }


    @Override
    protected String doInBackground(String... params) {
        int statusCode = 0;
        try {
            DefaultHttpClient hClient = createHttpClient();

            HttpGet request = new HttpGet(params[0]);
            HttpResponse res = hClient.execute(request);

            statusCode = res.getStatusLine().getStatusCode();
            Log.v("Tracking", "Status Code: " + statusCode);
            if(statusCode==200 || statusCode==302){
                return "成功";
            }
        } catch (Exception e) {
            Log.v("Tracking", "Exception: "+e.getMessage());
            return "失败";
        }
        return "服务器有报错："+statusCode;
    }

    private DefaultHttpClient createHttpClient() {
        SchemeRegistry schemeRegistry = new SchemeRegistry();
        schemeRegistry.register(new Scheme("http", PlainSocketFactory
                .getSocketFactory(), 80));

        HttpParams connManagerParams = new BasicHttpParams();
        ConnManagerParams.setMaxTotalConnections(connManagerParams, 5);
        ConnManagerParams.setMaxConnectionsPerRoute(connManagerParams,
                new ConnPerRouteBean(5));
        ConnManagerParams.setTimeout(connManagerParams, 20 * 1000);

        ThreadSafeClientConnManager cm = new ThreadSafeClientConnManager(
                connManagerParams, schemeRegistry);

        HttpParams clientParams = new BasicHttpParams();
        HttpConnectionParams.setConnectionTimeout(clientParams, 20 * 1000);
        HttpConnectionParams.setSoTimeout(clientParams, 20 * 1000);
        DefaultHttpClient httpClient = new DefaultHttpClient(cm, clientParams);
        return httpClient;
    }

    @Override
    protected void onPostExecute(String result) {
        Message message = new Message();
        message.obj = result;
        _handler.sendMessage(message);
    }



}
