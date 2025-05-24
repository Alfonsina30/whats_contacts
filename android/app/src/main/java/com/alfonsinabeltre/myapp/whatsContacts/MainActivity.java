package com.alfonsinabeltre.myapp.whatsContacts;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.provider.Settings;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterFragmentActivity {

    @SuppressLint("Range")
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannel methodChannel = new MethodChannel(binaryMessenger, "app/whatscontacts");

        // inicializacion del canal entre flutter y android
        methodChannel.setMethodCallHandler((call, result) -> {
            String permission = Manifest.permission.READ_CONTACTS;

            if (call.method.equals("getContacts")) {

                // ---- **************** PERMISSION IS GRANTED
                if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
                    //--**** take contacts
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
                        ArrayList contactsapp = new ArrayList<HashMap<String, String>>();
                        ContentResolver contentResolver = getContentResolver();
                        Cursor db = null;

                        String[] projection = new String[] {
                                ContactsContract.Data.CONTACT_ID,
                                ContactsContract.Data.DISPLAY_NAME_PRIMARY,
                                ContactsContract.CommonDataKinds.Phone.NUMBER,
                                ContactsContract.RawContacts.DISPLAY_NAME_PRIMARY,
                                ContactsContract.Profile.DISPLAY_NAME,
                                ContactsContract.RawContacts.ACCOUNT_NAME,
                        };
                        String selection = ContactsContract.Data.MIMETYPE + "='"
                                + ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE + "' AND "
                                + ContactsContract.RawContacts.ACCOUNT_TYPE + "= ?";

                        db = contentResolver.query(
                                // ContactsContract.RawContacts.CONTENT_URI,
                                ContactsContract.Data.CONTENT_URI,
                                projection,
                                selection,
                                new String[] {
                                        "com.whatsapp",
                                }, null);

                        while (db != null && db.moveToNext()) {
                            String name = db.getString(db.getColumnIndex(ContactsContract.Data.DISPLAY_NAME_PRIMARY));
                            String numberUser = db
                                    .getString(db.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

                            ContactsApp appContact = new ContactsApp(name, numberUser);

                            contactsapp.add(appContact.toMap());
                        }
                        result.success(contactsapp);
                    }
                }

                // -- **************** PERMISSION IS DENIED PERMANENTLY
                else {
                    Boolean showDialogPermission = ActivityCompat.shouldShowRequestPermissionRationale(this,
                            permission);

                    if (!showDialogPermission) {
                        // --- permission is denied permanently and user mark don't ask again
                        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                        Uri uri = Uri.fromParts("package", getPackageName(), null);
                        intent.setData(uri);

                        // --- es necesario cuando llamo startActivity y es para decirle al sistema
                        // quiero lanzar esta nueva pantalla(actividad) como
                        // nueva tarea en el stack
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);

                    }
                    // -- **************** PERMISSION IS DENIED
                    else {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            requestPermissions(new String[] { permission }, 0);
                        }
                    }
                }
            }
            // ***** ---------------------------------- METHOD CHECK PERMISSION
            else if (call.method.equals("checkPermission")) {
                if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
                    result.success(true);
                } else {
                    result.success(false);
                }
            }
            // ******
            else {
                result.notImplemented();
            }
        });
    }
}

