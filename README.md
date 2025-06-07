# whats_contacts
 
 Aplicación Flutter para tomar los contactos que utilicen whatsapp, lo cuales han sido guardados en el sistema operativo móvil android.

- Que utiliza esta app:

1. Platform channel para la comunicacion entre Dart y el codigo nátivo utilizanodo Java para:

-Verificar si el usuario ha otorgado el permiso de "READ_CONTACTS". 

-Hacer la solicitud del permiso mostrando un showDialog.

-En el caso de que el permiso ha sido completado denegado, llevar al usuario a la configuracion del sistema para otorgar el permiso manualmente.

-Hacer la query para acceder a los contactos que tengan la etiqueta whatsapp que estan guardados en el dispositivo.

3. Bloc como manejador de estado: 
-Para mostrar los contactos en la UI del app y darle la posibilidad al usuario de seleccionar los contactos.

4. Widgets:

-WidgetsBindingObserver para escuchar los cambios en la aplicación, por ejemplo, cuando el usuario sale del app para otorgar el permiso manualmente en la setting del sistema y luego al regresar a la aplicacion debemos escuchar el cambio de estado del permiso otorgado.

-Search Delegate para que el usuario pueda realizar busqueda de contactos dentro de la misma aplicación.


# CONSIDERACIONES
 
- En el android manifest se debe especificar que permiso que va a solicitar al usuario. " <uses-permission android:name="android.permission.READ_CONTACTS"/> "

# UI APP
home_page

![home_page](https://github.com/user-attachments/assets/bffbf955-f420-4af7-a8be-0eff9639180c)

show_dialog_request_permission
![show_dialog_permission](https://github.com/user-attachments/assets/8d18d574-3f97-4307-8336-6c3d86702af6)

device_setting_permissions
![device_setting_permissions](https://github.com/user-attachments/assets/a2063d2e-f933-41da-8938-81052243f231)

device_setting_granted_permissions
 ![device_setting_granted_permissions](https://github.com/user-attachments/assets/dde50c15-7011-4c48-be74-35f841de735f)

search_contact
![search](https://github.com/user-attachments/assets/d70781ff-0fc9-44f7-940f-7da29f8efe6b)

home_page_contact_selected
![home_page_contact_selected](https://github.com/user-attachments/assets/2a63c135-49d8-455f-8967-86e3b7c3ee35)
