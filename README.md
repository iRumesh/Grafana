# Customized Grafana Dashboard

- Landing page modifications

        - [x] Custom logo
        - [x] welcome message
        - [x] fevicon icon
        - [x] Background
        - [x] HTML Title
        - [x] Default Theme - Dark
        - [x] smtp setup, mail will be sent for alert, password reset
        - [x] Removed news, help from default dashboard (changed conf in .ini file)
        - [x] Default Home page can be set
        - [x] Remove Footer texts, Changelog 
        - [x] Custom HTML (HTML graphics Plugin)
        - [ ] looking into forget your password at login page for viewer
        - [ ] Customizing emails sent to user by own logos, messages
        - [ ] Viewing PDFs inside grafana (Adding user manuals)
        - [ ] Adding side bar tab with custom menu
        - [ ] Sending Alert Email with screenshot of graph



Plugins Added (installed via docker file, ENV)
marcusolsson-dynamictext-panel
MQTT, marcusolsson-dynamictext-panel


 - Removing all unnecessary plugins menus
 - Configuring custom datasource
 - Loading custom dashboard
 - RBAC (Admin, Viewer)
 - 

### Folder Structure
    .  
    ├── dashboards 
    ├── emails         # Directory contains email templates from grafana   
    ├── grafana_data   # docker volume                    
    ├── img             
    │   ├── .svg         
    │   ├── .png                 
    ├── Provisioning                
    │   ├── dashboards    
    │   ├── datasources     
    │   └── plugins           
    ├── .env    
    ├── defaults.ini                  
    ├── docker-compose.yaml  
    ├── dockerfile                    
    ├── grafana.ini 
    └── README.md

For testing MQTT
- MQTT Explorer
- https://testclient-cloud.mqtt.cool/



## References
https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/
https://www.youtube.com/watch?v=ZIjUOr_HYFQ