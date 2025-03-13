FROM ${GRAFANA_IMAGE:-grafana/grafana}

USER root
# # Disable Login form or not
# ENV GF_AUTH_DISABLE_LOGIN_FORM "true"
# # Allow anonymous authentication or not
# ENV GF_AUTH_ANONYMOUS_ENABLED "true"
# # Role of anonymous user
# ENV GF_AUTH_ANONYMOUS_ORG_ROLE "Admin"
# # Install plugins here our in your own config file
# # ENV GF_INSTALL_PLUGINS="<list of plugins seperated by ,"


##################################################################
## Customization depends on the Grafana version
## May work or not work for the version different from the current
## Check GitHub file history for the previous Grafana versions
##################################################################
ENV GF_PANELS_DISABLE_SANITIZE_HTML=true

## Paths
ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"
ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"

## Copy Provisioning
COPY --chown=grafana:root provisioning $GF_PATHS_PROVISIONING

## Set Home Dashboard
# ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/business.json

##################################################################
## VISUAL
## Update Image files
##################################################################

## Replace Favicon and Apple Touch
COPY img/fav32.png /usr/share/grafana/public/img/fav32.png
COPY img/apple-touch-icon.png /usr/share/grafana/public/img/apple-touch-icon.png

## Replace Logo
COPY img/grafana_icon.svg /usr/share/grafana/public/img/grafana_icon.svg

## Update Background
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
COPY img/background1.svg /usr/share/grafana/public/img/g8_login_light.svg

##################################################################
## HANDS-ON
## Update HTML, INI files
##################################################################

# Update Title
RUN sed -i 's|<title>\[\[.AppTitle\]\]</title>|<title>Rumesh</title>|g' /usr/share/grafana/public/views/index.html
RUN sed -i 's|Loading Grafana|Loading Grafana by Rumesh|g' /usr/share/grafana/public/views/index.html

## Update Mega and Help menu
# RUN sed -i "s|\[\[.NavTree\]\],|nav,|g; \
#     s|window.grafanaBootData = {| \
#     let nav = [[.NavTree]]; \
#     const dashboards = nav.find((element) => element.id === 'dashboards/browse'); \
#     if (dashboards) { dashboards['children'] = [];} \
#     const connections = nav.find((element) => element.id === 'connections'); \
#     if (connections) { connections['url'] = '/datasources'; connections['children'].shift(); } \
#     const help = nav.find((element) => element.id === 'help'); \
#     if (help) { help['subTitle'] = 'Business App 4.4.0'; help['children'] = [];} \
#     window.grafanaBootData = {|g" \
#     /usr/share/grafana/public/views/index.html

# # Move Business App to navigation root section
# RUN sed -i 's|\[navigation.app_sections\]|\[navigation.app_sections\]\nbusiness-app=root|g' /usr/share/grafana/conf/defaults.ini

##################################################################
## HANDS-ON
## Update JavaScript files
##################################################################

RUN find /usr/share/grafana/public/build/ -name *.js \
## Update Title
    -exec sed -i 's|AppTitle="Grafana"|AppTitle="Rumesh"|g' {} \; \
## Update Login Title
    -exec sed -i 's|LoginTitle="Welcome to Grafana"|LoginTitle="IIoT Solutions by Rumesh"|g' {} \; \
## Remove Documentation, Support, Community in the Footer
    -exec sed -i 's|\[{target:"_blank",id:"documentation".*grafana_footer"}\]|\[\]|g' {} \; \
## Remove Edition in the Footer
    -exec sed -i 's|({target:"_blank",id:"license",.*licenseUrl})|()|g' {} \; \
## Remove Version in the Footer
    -exec sed -i 's|({target:"_blank",id:"version",text:f.versionString,url:D?"https://github.com/grafana/grafana/blob/main/CHANGELOG.md":void 0})|()|g' {} \; \
## Remove News icon
    -exec sed -i 's|..createElement(....,{className:.,onClick:.,iconOnly:!0,icon:"rss","aria-label":"News"})|null|g' {} \; \
## Remove Open Source icon
    -exec sed -i 's|.push({target:"_blank",id:"version",text:`${..edition}${.}`,url:..licenseUrl,icon:"external-link-alt"})||g' {} \;


# # Add provisioning
# ADD ./provisioning.yml /etc/grafana/provisioning
# # Add configuration file
# ADD ./grafana.ini /etc/grafana/grafana.ini
# # Add dashboard json files
# ADD ./dashboard.yml /etc/grafana/dashboards