#!/bin/bash
#add user -> grant kubectl permission for user
if [ $(id -u) -eq 0 ]; then
        read -p "Username : " uname
        read -p "Password to be set : " password
        #userList = /home/rukonuzzaman/userList
        echo ${password:=}
        echo "Set password $password"

        egrep -w "$uname" /etc/passwd >/dev/null

        #echo "$? /etc/passwd"

        if [ $? -eq 0 ]; then
        echo "$uname exists!"
        exit 1

        else
        useradd "$uname"
        echo "Adding $password for $uname"
        echo $password | passwd --stdin $uname
        egrep "\<$uname\>" /etc/passwd >/dev/null

        [ $? -eq 0 ] && echo "**User $uname added to system!" || echo "Failed to add a user $uname!"


        #create folder for kubeconfig
        echo "Getting homedir"
        homedir=$( getent passwd "$uname" | cut -d: -f6 )
        mkdir -p $homedir/.kube
        echo "Copying to $uname homedir"
        cp -i /etc/kubernetes/admin.conf $homedir/.kube/config
        chown -R $(id -u $uname):$(id -g $uname) $homedir/.kube/

        fi
else
        echo "permission denied"
        exit 2
fi
