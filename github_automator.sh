#!/bin/bash
location="./"
dir='~/'
initRepo(){
            local username="$1"
            read -p "Enter your repo name (with ending with .sukh):-" repoName
            while ! [[ "$repoName" =~ .sukh$ ]]
            do
                echo "invalid format"
                read -p "Enter your repo name (with ending with .sukh):-" repoName
            done
            read -p "enter description file name: " description

            PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN
            if [ -z "$PERSONAL_ACCESS_TOKEN" ]; then
            echo "Please enter your Personal access token from Git-Hub"
            read  -s PERSONAL_ACCESS_TOKEN 
            export GITHUB_TOKEN=$PERSONAL_ACCESS_TOKEN
            fi 
           
            echo "Using Your Personal Access Token "  
            echo "Enter the location where you want to create Directory ( Press Enter To Create In Current Directory ) "
            read -p " Enter absolute path :- cd ~/" location
            if [  "$location" != ""  ]
            then
                cd ~/
                cd $location
                pwd
            fi
            
            mkdir $repoName
            cd $repoName
            git init 
            touch readme.md
            echo "# You Are Using GitHub_Automator  Credit :- sukhman-sukh " >> readme.md
            # curl -L -X POST -H "Authorization: Bearer $PERSONAL_ACCESS_TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$repo_name\",\"description\":\"$description\"}" > /dev/null
            
            response=$( curl -L -X POST -H "Authorization: Bearer $PERSONAL_ACCESS_TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$repoName\",\"description\":\"$description\"}" )

            if [[ "$response" =~ ^.*message\":\ \"name\ already\ exists\ on\ this\ account.*$ ]]
            then
            echo "Repository already exists :("
            initRepo
            
            else
                git add .
                git remote add origin "git@github.com:$username/$repoName.git"

                git commit . -m "1st commit"
                git branch -m master main

                git push origin main

           fi
}
pushRepo(){
   
    echo "Enter the location of Directory You Want to commit ( Press Enter To commit Current Directory ) "
     
        read -p " Enter absolute path :- cd ~/" location
    if [  "$location" != ""  ]
    then
        cd ~/
        cd $location
        pwd
    fi
        read -p "Commit Message :- " message
        git add .

        git commit . -m "$message"
        git branch -m master main
        git push origin main
    

}

main(){
    echo "Hey There ! "
    echo "This Is A Git-Hub Repo Automator App"
    

    username=$GIT_USERNAME
    if [ -z "$GIT_USERNAME" ]; then
    read -p "enter username: " username
    export GIT_USERNAME=$username
    fi 
    
    
    echo ''
    echo "Press 1 to create A repo "
    echo "Press 2 if your work is complete and you want to push it"
    read input
     
    if [ $input == 1 ];
    then
        initRepo "$username"

    elif [ $input == 2 ];
    then
        pushRepo

    else
        echo "Wrong entry ! Try Again"
    fi

}
main