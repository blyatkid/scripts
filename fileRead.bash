#!/bin/bash
#add user -> grant kubectl permission for user
if [ "$(id -u)" -eq 0 ]; then
        echo "Add users for sni-k8s role"
        #read -p "Username : " uname
        #read -p "Password to be set : " password

                username=$(cat /home/userList | tr 'A-Z' 'a-z')
        echo ${password:=}
        echo "Set password $password"

        for uname in $username
        do
                egrep -w "$uname" /etc/passwd >/dev/null

                #echo "$? /etc/passwd"

                if [ $? -eq 0 ]; then
                echo "$uname exists!"
                continue

                else
                egrep -w sni-k8s /etc/group >/dev/null && echo "Group sni-k8s exists!" || groupadd sni-k8s
                useradd "$uname"
                echo "Adding $password for $uname"
                echo $password | passwd --stdin "$uname"
                egrep "\<$uname\>" /etc/passwd >/dev/null

                [ $? -eq 0 ] && echo "**User $uname added to system!" || echo "Failed to add a user $uname !"

                #add to group expire pass
                usermod -g "sni-k8s" "$uname"

                #create folder for kubeconfig
                #echo "Getting homedir"
                #homedir=$( getent passwd "$uname" | cut -d: -f6 )
                #mkdir -p "$homedir"/.kube
                #echo "Copying to "$uname" homedir"
                #cp -i /etc/kubernetes/admin.conf "$homedir"/.kube/config
                #chown -R $(id -u $uname):$(id -g $uname) $homedir/.kube/
                fi
        done
else
        echo "permission denied"
        exit 2
fi