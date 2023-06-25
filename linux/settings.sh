#!/bin/bash

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
xdg-settings set default-web-browser com.brave.Browser.desktop
