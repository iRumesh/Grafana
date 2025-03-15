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
        - [ ] Remove Footer texts, Changelog 
        - [ ] looking into forget your password at login page for viewer
        - [ ] Customizing emails sent to user by own logos, messages


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
    ├── emails #Directory contains email templates from grafana   
    ├── grafana_data # docker volume                    
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
    ├── env.grafana  
    ├── grafana.ini 
    └── README.md
