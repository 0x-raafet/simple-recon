#!/bin/bash

export GO111MODULE=auto
go env -w GO111MODULE=auto

go get -u github.com/tomnomnom/assetfinder 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install assetfinder [ DONE ]" ;
else echo -e "Install assetfinder [ FAILED ]" ; fi

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install assetfinder [ DONE ]" ;
else echo -e "Install assetfinder [ FAILED ]" ; fi

go install -v github.com/OWASP/Amass/v3/...@master 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install amass [ DONE ]" ;
else echo -e "Install amass [ FAILED ]" ; fi

go install -v github.com/lukasikic/subzy@latest 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install subzy [ DONE ]" ;
else echo -e "Install subzy [ FAILED ]" ; fi

go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install nuclei [ DONE ]" ;
else echo -e "Install nuclie [ FAILED ]" ; fi

go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install httpx [ DONE ]" ;
else echo -e "Install httpx [ FAILED ]" ; fi

go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install crlfuzz [ DONE ]" ;
else echo -e "Install crlfuzz [ FAILED ]" ; fi

go get -u golang.org/x/net/html 1>/dev/null
go get -u github.com/dellalibera/titlextractor/ 1>/dev/null
if [ $? -eq 0 ] ; then echo -e "Install titlextractor [ DONE ]" ;
else echo -e "Install titlextractor [ FAILED ]" ; fi

PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done
echo -e " DONE"
