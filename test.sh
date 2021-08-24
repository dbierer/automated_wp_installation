#!/bin/bash
export WP_HIDE_LOGIN="XXX"
if [[ "$WP_HIDE_LOGIN" != "" ]]; then
    echo "Installing and enabling wps-hide-login ..."
fi
