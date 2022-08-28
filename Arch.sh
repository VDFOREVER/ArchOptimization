read -r -p "1.install video drivers 2.install software -> " xz

case $xz in
    1)
    read -p "'NVIDIA' or 'AMD', 'INTEL'? -> " answer
    case $answer in
        NVIDIA) sudo pacman -S linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl ;
        sudo mkinitcpio -P; sudo nvidia-xconfig ; sudo nvidia-settings;;
        AMD) sudo pacman -S linux-headers mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader;;
        INTEL) sudo pacman -S linux-headers mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader;;
    esac;;
    2) read -r -p "1.nvidia tweaks 2.Microcode 3.software -> " soft
    case $soft in
        1) git clone https://aur.archlinux.org/nvidia-tweaks.git ; cd nvidia-tweaks ; makepkg -sric ; cd .. ; sudo rm -R nvidia-tweaks;
        printf "sudo nano /etc/mkinitcpio.conf\nMODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)\nMODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm crc32c libcrc32c zlib_deflate btrfs) #btfs\n" ;;
        2) read -r -p "1.Intel 2.AMD -> " iucode
        case $iucode in
            1) sudo pacman -S intel-ucode iucode-tool ; sudo mkinitcpio -P ; sudo grub-mkconfig -o /boot/grub/grub.cfg ;;
            2) sudo pacman -S amd-ucode iucode-tool ; sudo mkinitcpio -P ; sudo grub-mkconfig -o /boot/grub/grub.cfg ;;
        esac;;
        3) read -r -p "Do you care about loading time? (I recommend [n]) [y/n] -> " st
        case $st in
            y) sudo pacman -S rng-tools ; sudo systemctl enable --now rngd; sudo pacman -S dbus-broker ; sudo systemctl enable --now dbus-broker.service ; sudo systemctl enable fstrim.timer ; sudo fstrim -v /;;
            n) git clone https://aur.archlinux.org/ananicy.git ; cd ananicy ; makepkg -sric ; sudo systemctl enable --now ananicy ; cd .. ; sudo rm -R ananicy
            sudo pacman -S haveged ; sudo systemctl enable haveged ; sudo pacman -S dbus-broker ; sudo systemctl enable --now dbus-broker.service ; sudo systemctl enable fstrim.timer ; sudo fstrim -v /;;
        esac;;
    esac;;
esac

