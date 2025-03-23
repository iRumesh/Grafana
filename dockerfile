FROM ${GRAFANA_IMAGE:-grafana/grafana}

USER root

## copying grafana configurations
COPY defaults.ini /etc/grafana/grafana.ini

## copying grafana modified email notifications
COPY emails/ /usr/share/grafana/public/emails/
# COPY IIoT.json /var/lib/grafana/dashboards
# COPY IIoT.json /etc/grafana/provisioning/dashboards/IIoT.json
# ## Copy Provisioning
# COPY --chown=grafana:root provisioning $GF_PATHS_PROVISIONING

########### COPY DASHBOARDS ####################

# ADD ./provisioning /etc/grafana/provisioning
# COPY ./provisioning /etc/grafana/provisioning
# COPY ./dashboards /var/lib/grafana/dashboards

###########                 ####################

## Set Home Dashboard
# ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/IIoT.json

##################################################################
## Update Favicon, Logos, Light theme, dark theme backgrounds
##################################################################

## Replace Favicon and Apple Touch
COPY img/fav32.png /usr/share/grafana/public/img/fav32.png
COPY img/apple-touch-icon.png /usr/share/grafana/public/img/apple-touch-icon.png

## Replace Logo
COPY img/grafana_icon.svg /usr/share/grafana/public/img/grafana_icon.svg

## Update Background
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
COPY img/background1.svg /usr/share/grafana/public/img/g8_login_light.svg


## Canvas Backgrounds, Logos (SVGs)
COPY img/bg/* /usr/share/grafana/public/img/bg
COPY img/icons/* /usr/share/grafana/public/img/icons/unicons

##################################################################
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
# RUN sed -i 's|\[navigation.app_sections\]|\[navigation.app_sections\]\nRumesh=root|g' /usr/share/grafana/conf/defaults.ini

##################################################################
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
    -exec sed -i 's|({target:"_blank",id:"version",text:..versionString,url:D?"https://github.com/grafana/grafana/blob/main/CHANGELOG.md":void 0})|()|g' {} \; \
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