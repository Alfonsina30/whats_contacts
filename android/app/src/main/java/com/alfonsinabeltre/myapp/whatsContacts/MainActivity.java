package com.alfonsinabeltre.myapp.whatsContacts;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.database.Cursor;
import android.os.Build;
import android.provider.ContactsContract;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity{
    @SuppressLint("Range")
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger binaryMessenger =
                flutterEngine.getDartExecutor().getBinaryMessenger();

        MethodChannel methodChannel = new MethodChannel(binaryMessenger, "app/whatscontacts");

        ContentResolver contentResolver = getContentResolver();

        methodChannel.setMethodCallHandler((call, result)->{

         ArrayList contactsapp = new ArrayList<HashMap<String, String>>();

       if(call.method.equals("getContacts")){

           Cursor db = null;
           if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
               String[] projection = new  String[]{
                       ContactsContract.Data.CONTACT_ID,
                       ContactsContract.Data.DISPLAY_NAME_PRIMARY,
                       ContactsContract.CommonDataKinds.Phone.NUMBER,
                       ContactsContract.RawContacts.DISPLAY_NAME_PRIMARY,
                       ContactsContract.Profile.DISPLAY_NAME,
                       ContactsContract.RawContacts.ACCOUNT_NAME,
               };
               String selection = ContactsContract.Data.MIMETYPE + "='" + ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE + "' AND " + ContactsContract.RawContacts.ACCOUNT_TYPE + "= ?" ;

               db = contentResolver.query(
                       //  ContactsContract.RawContacts.CONTENT_URI,
                       ContactsContract.Data.CONTENT_URI,
                       projection,
                       selection,
                       new String[]{
                               "com.whatsapp",
                       }, null);


               while (db!= null && db.moveToNext()){
                   String name = db.getString(db.getColumnIndex(ContactsContract.Data.DISPLAY_NAME_PRIMARY));
                   String numberUser = db.getString(db.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

                   ContactsApp appContact = new ContactsApp(name, numberUser);

                   contactsapp.add(appContact.toMap());
               }
               result.success(contactsapp);
           }
       }else{
           result.notImplemented();
       }
     });
    }
}
