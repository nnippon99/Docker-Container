# Originally from: https://android-review.googlesource.com/c/platform/build/+/1161367
FROM ubuntu:20.04
#ARG userid=1000
#ARG groupid=1000
#ARG username=build
# ARG http_proxy

# Using separate RUNs here allows Docker to cache each update


RUN DEBIAN_FRONTEND="noninteractive" apt-get update

# Make sure the base image is up to date

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y apt-utils


RUN DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y

# Install apt-utils to make apt run more smoothly

# Install the packages needed for the build
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y openssh-server screen python git openjdk-8-jdk android-tools-adb bc bison \
build-essential curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses-dev \
lib32readline-dev lib32z1-dev  liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev \
libtinfo5 libncurses5 mosh tmux xattr nano wget locales ncdu zsh unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller device-tree-compiler liblzma-dev brotli liblz4-tool axel gawk aria2 detox cpio rename build-essential simg2img default-jre bc curl libstdc++6 git wget gcc clang libssl-dev rsync flex bison ccache openjdk-17-jdk expect neofetch tmux tmate libncurses5 lib32readline-dev libwxgtk3.0-gtk3-dev protobuf-compiler adb autoconf automake cmake expat fastboot g++ g++-multilib gcc-multilib gnupg gperf htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils '^lzma.*' lzop maven ncftp ncurses-dev patch patchelf pkg-config pngcrush pngquant python2 python2.7 python3 python-all-dev re2c schedtool squashfs-tools subversion texinfo w3m xsltproc zlib1g-dev lzip libxml-simple-perl libswitch-perl apt-utils lz4 python3-pip

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Disable some gpg options which can cause problems in IPv4 only environments
# RUN mkdir ~/.gnupg && chmod 600 ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# Download and verify repo
#RUN gpg --keyserver keys.openpgp.org --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo
# RUN curl https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# Create the home directory for the build user
# RUN groupadd -g $groupid $username \
# && useradd -m -s /bin/bash -u $userid -g $groupid $username

# RUN groupadd sshgroup && usermod -a -G sshgroup $username

#COPY gitconfig /home/$username/.gitconfig
#RUN chown $userid:$groupid /home/$username/.gitconfig

# Create a directory which we will be use as straoge
#RUN mkdir /home/$username/container-ssd && chown $userid:$groupid /home/$username/container-ssd && chmod ug+s /home/$username/container-ssd
RUN mkdir /root/aosp && mkdir /root/aosp/nippon 
RUN echo 'echo "ccache, packages, files, configurations and other things outside of /root/aosp.* will be deleted while changing containers. please save everything project related on /root/aosp."'  > /etc/profile.d/welcome.sh
CMD ["/usr/sbin/sshd", "-D"]
