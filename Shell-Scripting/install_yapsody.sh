#!/bin/sh

BUILD_URL="https://s3.amazonaws.com/ft-builds/build.tar.gz";
BASE_PATH="/home/ec2-user/site/releases/initial_build";
DOCUMENT_ROOT="/home/ec2-user/site/www";
BASE_USER="ec2-user";
REPO_URL="https://yapsody.svn.beanstalkapp.com/yapsody/branches/staging";

if curl --output /dev/null --silent --head --fail "$BUILD_URL"; then
        INSTALL_FROM_SVN="no";
else
        INSTALL_FROM_SVN="yes";
fi

rm -rf $BASE_PATH;

if [ "$INSTALL_FROM_SVN" == "yes" ]; then
        REVISION=`svn info https://yapsody.svn.beanstalkapp.com/yapsody/branches/staging --username deepak --password deepak1783 --no-auth-cache  -rHEAD |grep Revision: |cut -c11-`;
        svn export -q --username deepak --password deepak1783 --no-auth-cache  -r$REVISION $REPO_URL $BASE_PATH;
        echo $REVISION > $BASE_PATH/REVISION;
else
        curl --output $BASE_PATH/build.tar.gz "$BUILD_URL";
        mkdir $BASE_PATH;
        cd $BASE_PATH && tar -xvf $BASE_PATH/build.tar.gz
        rm -rf $BASE_PATH/build.tar.gz
fi

sh $BASE_PATH/refresh.sh;
chmod -R g+w $BASE_PATH;
chown -R $BASE_USER:$BASE_USER $BASE_PATH;

rm -rf $DOCUMENT_ROOT && ln -s $BASE_PATH $DOCUMENT_ROOT;

#cp /home/ec2-user/httpd.conf /etc/httpd/conf/httpd.conf
#hack if this script doesnt run on each boot
#rm -rf /var/lib/cloud/sem/user-scripts.*

