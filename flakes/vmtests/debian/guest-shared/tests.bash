#!/bin/bash

package=hello

function check_command {
    cmd=$1
    pat=$2

    cmd_output.txt = $( $cmd ) &&
    cat cmd_output.txt &&
    if [ grep -v "$pat" cmd_output.txt ]]; then
        echo "Expected output found for distro $DISTRO"
        return 0
    else 
        echo "Expected output missing for distro $DISTRO"
        return 1
    fi
}

function install_packages {
    # Run commands based on the detected distro
    case $DISTRO in
        ubuntu|debian)
            echo "Running commands for Debian-based systems (Ubuntu, Debian)..."
            apt update &&
            apt install -y $package
            # Add your Debian-based commands here
            apt-get -yq install /mnt/host-shared/hello.deb
            ;;
        fedora|centos|rhel)
            echo "Running commands for Red Hat-based systems (Fedora, CentOS, RHEL)..."
            dnf update -y
            dnf install -y $package
            # Add your Red Hat-based commands here
            ;;
        arch|manjaro)
            echo "Running commands for Arch-based systems (Arch, Manjaro)..."
            pacman -Syu
            pacman -S --noconfirm $package
            # Add your Arch-based commands here
            ;;
        nixos )
            echo "Running commands for NixOS-based systems ..."
            nix-shell -p hello

            # Add your NixOS-based commands here
            ;;
        *)
            echo "Unsupported Linux distribution: $DISTRO"
            exit 1
            ;;
    esac
}

function run_tests {
    check_command hello "Hello World!"
}

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    export DISTRO=$ID
    echo "Running tests on $DISTRO"
else
    echo "Unsupported Linux distribution"
    exit 1
fi
