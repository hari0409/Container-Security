Package_Check(){
    which "$1" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        return 0
    else
        return 1
    fi
}

Dockle_Scan(){
    Package_Check dockle
    if (( $? == 0 )); then # if dockle not installed
        echo "Dockle not installed.Installing dockle"
        VERSION=$(
        curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
        grep '"tag_name":' | \
        sed -E 's/.*"v([^"]+)".*/\1/' \
        ) && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb
        sudo dpkg -i dockle.deb && rm dockle.deb
        echo "Enter image name"
        read -r image_name
        echo "Scanning the image $image_name"
        mkdir /home/hari/Desktop/"$image_name"
        sudo dockle --no-color "$image_name" >&1 | tee ~/Desktop/"$image_name"/dockle_log.txt
    else 
        echo "Dockle present"
        echo "Enter image name"
        read -r image_name
        echo "Scanning the image $image_name"
        mkdir /home/hari/Desktop/"$image_name"
        sudo dockle --no-color "$image_name" >&1 | tee ~/Desktop/"$image_name"/dockle_log.txt
    fi
    echo 'Press 9 to go back'
    read -r option
    if [ "$option" -eq 9 ]; then
        Welcome
    fi
}

Trivy_Scan(){
    Package_Check trivy
    if (( $? == 0 )); then
        echo "Trivy not installed.Installing trivy"
        wget https://github.com/aquasecurity/trivy/releases/download/v0.20.1/trivy_0.20.1_Linux-64bit.deb
        sudo dpkg -i trivy_0.20.1_Linux-64bit.deb
        trivy fs --exit-code 1 .
        echo "Enter image name"
        read -r image_name
        echo "Scanning the image"
        mkdir /home/hari/Desktop/"$image_name"
        sudo trivy image "$image_name" >&1 | tee /home/hari/Desktop/"$image_name"/trivy_log.txt
    else 
        echo "Trivy present"
        echo "Enter image name"
        read -r image_name
        echo "Scanning the image $image_name"
        mkdir /home/hari/Desktop/"$image_name"
        sudo trivy image "$image_name" >&1 | tee /home/hari/Desktop/"$image_name"/trivy_log.txt
    fi
    echo 'Press 9 to go back'
    read -r option
    if [ "$option" -eq 9 ]; then
        Welcome
    fi
}

Hadolint_Scan(){
    if [ -f "/bin/hadolint" ]; then ## CHeck if hadolint is installed
        echo 'Enter the path for the Docker file'
        read -r file
        echo "Enter image name"
        read -r image_name
        if [ -f "$file" ]; then
            mkdir /home/hari/Desktop/"$image_name"
            sudo hadolint "$file" >&1 | tee /home/hari/Desktop/"$image_name"/hadolint_log.txt
        else
            echo "File doesnt exists"
        fi
    else 
        sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64
        sudo chmod +x /bin/hadolint
        echo 'Enter the path for the Docker file'
        read -r file
        echo "Enter image name"
        read -r image_name
        if [ -f "$file" ]; then
            mkdir /home/hari/Desktop/"$image_name"
            sudo hadolint "$file" >&1 | tee /home/hari/Desktop/"$image_name"/hadolint_log.txt
        else
            echo "File doesnt exists"
        fi
    fi  
    echo 'Press 9 to go back'
    read -r option
    if [ "$option" -eq 9 ]; then
        Welcome
    fi
}

Anchore_Scan(){
    if [[ "$(docker images -q anchore/grype:latest 2> /dev/null)" == "" ]]; then
        printf "Anchore already exists.\nNOTE: This can be used to scan only images in docker hub that you have access to.\n"
        echo 'Enter image name'
        read -r image_name
        mkdir /home/hari/Desktop/"$image_name"
        echo "Scanning it"
        sudo docker run --rm anchore/grype:latest -o json "$image_name" >&1 | tee /home/hari/Desktop/"$image_name"/anchore_log.json
    else
        printf "Anchore not available.\nNOTE: This can be used to scan only images in docker hub that you have access to.\n"
        docker pull anchore/grype:latest
        echo 'Enter image name'
        read -r image_name
        mkdir /home/hari/Desktop/"$image_name"
        echo "Scanning it"
        sudo docker run --rm anchore/grype:latest -o json "$image_name" >&1 | tee /home/hari/Desktop/"$image_name"/anchore_log.json
    fi
    echo 'Press 9 to go back'
    read -r option
    if [ "$option" -eq 9 ]; then
        Welcome
    fi
}

Complete_Container_Scan(){
    if [ -d "./docker-bench-security" ]; then
        echo "Docker Bench Security exists"
        cd docker-bench-security || exit
        sudo sh docker-bench-security.sh -b >&1 | tee /home/hari/Desktop/complete_scan.txt
    else   
        echo "Docker Bench Security doesnt exists"
        git clone https://github.com/docker/docker-bench-security.git
        cd docker-bench-security || exit
        sudo sh docker-bench-security.sh -b >&1 | tee /home/hari/Desktop/complete_scan.txt
    fi
    echo 'Press 9 to go back'
    read -r option
    if [ "$option" -eq 9 ]; then
        Welcome
    fi
}

Welcome(){
    figlet "DockSecure"
    echo 'What do you want to do'
    printf "1. Docker Image Scan using Dockle\n2. Vulnerability Scan with Trivy\n3. Scan Dockerfile with Hadolint\n4. Scan Hub images with Anchore\n5. Comeplete Scan\n"
    read -r option
    case "${option}" in
        1)
            Dockle_Scan
        ;;
        2)
            Trivy_Scan
        ;;
        3)
            Hadolint_Scan
        ;;
        4)
            Anchore_Scan
        ;;
        5)
            Complete_Container_Scan
        ;;
        *)
            echo "Invalid Option"
        ;;
    esac
}
Welcome