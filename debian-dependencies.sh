sudo apt install -y nala

sudo nala install -y tar wget meson wget build-essential ninja-build cmake-extras cmake gettext gettext-base fontconfig libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd libxcb-dri3-dev libvulkan-dev libvulkan-volk-dev  vulkan-validationlayers-dev libvkfft-dev libgulkan-dev libegl-dev libgles2 libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev libpango1.0-dev xdg-desktop-portal-wlr hwdata check libgtk-3-dev libsystemd-dev xwayland kitty 

mkdir ~/hypr-debian
cd ~/hypr-debian

wget https://github.com/hyprwm/Hyprland/releases/download/v0.36.0/source-v0.36.0.tar.gz
tar -xvf source-v0.36.0.tar.gz

wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.33/downloads/wayland-protocols-1.33.tar.xz
tar -xvJf wayland-protocols-1.33.tar.xz

wget https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz
tar -xzvJf wayland-1.22.0.tar.xz

wget https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/0.1.1/downloads/libdisplay-info-0.1.1.tar.xz
tar -xvJf libdisplay-info-0.1.1.tar.xz

## make sure
sudo nala install -y git

git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
git clone https://gitlab.freedesktop.org/libinput/libinput.git
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git

## buildy time

# wayland
cd wayland-1.22.0
mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Ddocumentation=false &&
ninja
sudo ninja install

cd ../..

# wayland protocol
cd wayland-protocols-1.33

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&
ninja

sudo ninja install

cd ../..

# we need it
sudo nala install -y edid-decode

# lib display info
cd libdisplay-info-0.1.1/

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&
ninja

sudo ninja install

cd ../..

# lib lift off
cd libliftoff/
meson setup build/
cd build/
sudo ninja install

cd ../../

# lib input
cd libinput/
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h

meson setup --prefix=/usr build/

ninja -C build/
sudo ninja -C build/ install

cd ../

clear

## OMG TIME TO COMPILE HYPRLAND FINALLY

cd hyprland-source/
sudo nala -y libgbm-dev

sudo make install

# hooray, just a few more things!

sudo mkdir /usr/share/wayland-sessions
cd ~/hypr-debian/hyprland-source/example

sudo cp -r hyprland.desktop /usr/share/wayland-sessions/

## FINISH SCRIPT

echo "Script is finished. Now you can reboot your system, just make sure you have a LOGIN MANAGER..."
