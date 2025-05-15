package com.example.whats_contacts;

import java.util.HashMap;

public class ContactsApp {

    String name;
    String phone;

    public ContactsApp(String name, String phone){
        this.name = name;
        this.phone = phone;
    }

    HashMap<String, String> toMap(){
        HashMap<String, String> result = new HashMap<>();
        result.put("name", name);
        result.put("phone", phone);

        return result;
    }
}
