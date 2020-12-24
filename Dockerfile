                                                                                                                
                                                                                                                FROM ubuntu:16.04
                                                                                                                
                                                                                                                MAINTAINER Samuel "akvsdk@gmail.com"
                                                                                                                
                                                                                                                ENV DEBIAN_FRONTEND noninteractive
                                                                                                                
                                                                                                                WORKDIR /root
                                                                                                                
                                                                                                                RUN apt-get update && \
                                                                                                                    apt-get install -y qemu-kvm qemu-utils bridge-utils dnsmasq uml-utilities iptables wget net-tools && \
                                                                                                                    apt-get install -y build-essential git vim make zip unzip curl wget bzip2 ssh openssh-server socat && \
                                                                                                                    apt-get install -y openjdk-8-jdk && \
                                                                                                                    apt-get install -y software-properties-common && \
                                                                                                                    apt-get install -y net-tools iputils-ping dnsutils && \
                                                                                                                    apt-get install -y python-dev python-pip  && \
                                                                                                                    apt-get install -y apt-utils usbutils locales udev && \
                                                                                                                    apt-get autoremove -y && \
                                                                                                                    apt-get clean
                                                                                                                
                                                                                                                # Install packages needed for android sdk tools
                                                                                                                RUN dpkg --add-architecture i386 && \
                                                                                                                    apt-get update && \
                                                                                                                    apt-get -y install libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386
                                                                                                                
                                                                                                                # Java Environment Path
                                                                                                                ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
                                                                                                                ENV JRE_HOME=${JAVA_HOME}/jre
                                                                                                                ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
                                                                                                                ENV PATH=${JAVA_HOME}/bin:$PATH
                                                                                                                
                                                                                                                # Install Android SDK
                                                                                                                ENV ANDROID_HOME=/opt/android-sdk-linux
                                                                                                                ENV ANDROID_NDK_HOME=$ANDROID_HOME/android-ndk-r14b
                                                                                                                ENV PATH=$PATH:$ANDROID_HOME/tools/:$ANDROID_HOME/platform-tools:$ANDROID_NDK_HOME
                                                                                                                
                                                                                                                RUN curl -o android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar -C /opt -zxvf android-sdk.tgz > /dev/null
                                                                                                                RUN curl -o ndk-bundle.zip https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip && unzip ndk-bundle.zip -d $ANDROID_HOME
                                                                                                                    > /dev/null
                                                                                                                    
                                                                                                                    RUN mkdir "$ANDROID_HOME/licenses" || true
                                                                                                                    RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
                                                                                                                    RUN echo -e "\d56f5187479451eabf01fb78af6dfcb131a6481e" >> "$ANDROID_HOME/licenses/android-sdk-license"
                                                                                                                    RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"
                                                                                                                    
                                                                                                                    # Install Android Build Tools and the required version of Android SDK
                                                                                                                    # You can create several versions of the Dockerfile if you need to test several versions
                                                                                                                    RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui --force -a --filter \
                                                                                                                        platform-tool,android-25,android-26,build-tools-25.0.3,build-tools-26.0.1,extra-android-support,extra-android-m2repository,extra-google-m2repository
                                                                                                                        && \
                                                                                                                        echo "y" | android update adb
                                                                                                                    
                                                                                                                    # Gradle 6.1.1
                                                                                                                    ENV GRADLE_HOME=/usr/local/gradle-6.1.1
                                                                                                                    ENV PATH=$GRADLE_HOME/bin:$PATH
                                                                                                                    
                                                                                                                    RUN curl -o gradle-6.1.1-all.zip -L https://services.gradle.org/distributions/gradle-6.1.1-all.zip && unzip gradle-6.1.1-all.zip
                                                                                                                        -d /usr/local > /dev/null
                                                                                                                    
                                                                                                                    RUN echo "y" | android update sdk -a --no-ui --filter sys-img-x86_64-android-21,Android-21
                                                                                                                    
                                                                                                                    VOLUME /data
                                                                                                                    
                                                                                                                    