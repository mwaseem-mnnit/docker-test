#!/bin/bash

##    ecs-mongo.rivigo.com IP is 10.8.103.72


set -x
set -e
filepath="/home/ec2-user/slowqueries/ECS_TASKS/job_details/"${JOB_NAME}
sudo touch $filepath

echo "######### $JIRA_ID  #########"
#
## Check for new or exesting services

if [ "$DESTINATION_BRANCH" = "" ]
then
    DESTINATION_BRANCH="${BRANCH}"
fi

BUILD_BRANCH="$DESTINATION_BRANCH"

if [ "$DESTINATION_BRANCH" = 'develop' ]
then
    JIRA_ID="develop"
fi

if [ "$JIRA_ID" = '' ]
then
    JIRA_ID=$(echo $DESTINATION_BRANCH | grep -Po '\d+' | head -n1)
fi


build_check() {

    if sudo grep -Fxq "${appName}_$JIRA_ID" $filepath
    then
        Update_MicroService='true'
        Create_New_MicroService='false'
    else
        Create_New_MicroService='true'
    fi

}


if [ "$REPO_NAME" == "rivigo-finance-ui" ]
then
    appName="financeui"
    APP_NAME="financeui"
    App_Container_Port=8080
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif [ "$REPO_NAME" == "cms-backend" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="cms"
    APP_NAME="cms"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "collections-backend" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="collection"
    APP_NAME="collection"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "vendor-management-system" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="vms"
    APP_NAME="vms"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "invoicing-backend" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="invoicing"
    APP_NAME="invoicing"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check


elif  [ "$REPO_NAME" == "meta-store" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="meta-store"
    APP_NAME="meta-store"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check


elif  [ "$REPO_NAME" == "prime-billing-backend" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="prime-billing"
    APP_NAME="prime-billing"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check
elif  [ "$REPO_NAME" == "zoom-billing-backend" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="zoom-billing"
    APP_NAME="zoom-billing"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "expense-payment" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="expense-payment"
    APP_NAME="expense-payment"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "vendor-contract-management-system" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="vcms"
    APP_NAME="vcms"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "expense-billing" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="expense-billing"
    APP_NAME="expense-billing"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "expense-invoicing" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="expense-invoicing"
    APP_NAME="expense-invoicing"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

elif  [ "$REPO_NAME" == "compass-communication" -o "$x_event_key" = "pullrequest:updated" ]
then

    appName="compass-communication"
    APP_NAME="compass-communication"
    App_Container_Port=5000
    Docker_Image_App="906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    build_check

else
    echo " $REPO_NAME name does't exist "
    exit 0
fi









###### Set appName ####

echo "appName=${appName}" > ${WORKSPACE}/buildprops
echo "JIRA_ID=${JIRA_ID}" >> ${WORKSPACE}/buildprops



if [ $Create_New_MicroService = 'true' ]
then
    echo "Creating new microservice"
    rm -rf ./tmp
    mkdir tmp
    cd tmp
    git clone git@bitbucket.org:rivigotech/${REPO_NAME}.git
    cd $REPO_NAME


    git checkout develop
    git checkout $BUILD_BRANCH
    git pull origin $BUILD_BRANCH || echo "Branch not found"

    #cp docker/task_definition.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json
    #-- git merge origin/master
    git commit -a -m "[pt-01] master merge" || echo 'nothing to commit'

    ## Disable for time being

    git merge --no-edit origin/$BRANCH

    if [ "$JIRA_ID" != "develop" ]
    then
        git push origin $BUILD_BRANCH  || echo 'nothing to push'
        echo "HI"
    fi

    if [ "$REPO_NAME" != "rivigo-finance-ui" ]
    then
        if [[ $Connect_To_Preprod == 'false' ]]
        then
            sh builder.sh ${ENV} ${JIRA_ID}
        fi
        if [[ $Connect_To_Preprod == 'true' ]]
        then
            sh builder.sh ${ENV} ${JIRA_ID}
        fi
    fi



    cd ../
    git clone git@bitbucket.org:rivigotech/ecs-builds.git
    sudo \cp ecs-builds/task_definitions/${APP_NAME}.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json
    sudo \cp /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s/Container_name/${APP_NAME}__$JIRA_ID/g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s#JIRA_ID#$JIRA_ID#g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s/Container_Port/$App_Container_Port/g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s#APP_NAME#$APP_NAME#g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json

    cp -r $REPO_NAME ${REPO_NAME}_${JIRA_ID}
    zip -r ${REPO_NAME}_dev_${BUILD_ID}.zip ${REPO_NAME}_${JIRA_ID}
    scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no ${REPO_NAME}_dev_${BUILD_ID}.zip centos@10.8.48.108:/home/centos/
    cd ../

    #aws ecr describe-repositories --query 'repositories[*].[repositoryName]'|grep -w ${APP_NAME}_${JIRA_ID}
    ecr_repo=`aws ecr describe-repositories | grep repositoryName | grep -w ${APP_NAME} | awk '{print $2}' | cut -d '"' -f 2`

    if [ -z "$ecr_repo" ]
    then
        aws ecr create-repository --repository-name ${APP_NAME}
    fi



    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo unzip -o ${REPO_NAME}_dev_${BUILD_ID}.zip"
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo docker build -t 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}:${JIRA_ID} /home/centos/${REPO_NAME}_${JIRA_ID}/ --build-arg jiraId=${JIRA_ID}"
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo docker push 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo rm -rf /home/centos/${REPO_NAME}_${JIRA_ID} /home/centos/${REPO_NAME}_dev_${BUILD_ID}.zip"
    echo "Creating Database ${APP_NAME}_${JIRA_ID}"



    
    aws ecs register-task-definition --cli-input-json file:///home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    rm /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json


    if [ "$REPO_NAME" == "meta-store" ]
    then
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/meta-store_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_meta_store_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_meta_store_query.sql

        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_meta_store_query.sql
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-meta-store.sh ${JIRA_ID}_meta_store
        cp /home/ec2-user/slowqueries/MongoCreateCluster/meta_store.js /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_meta_store.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_meta_store.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_meta_store.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${BUILD_ID}\_meta_store.js"
        mongodump --host 10.0.1.26 -d meta_store --port 27017 --username meta-prod --password 'wr1t3#meta#finance' --out /home/ec2-user/slowqueries/MongoCreateCluster/mongodump-${JIRA_ID}-${BUILD_ID}
        mongorestore --host ecs-mongo.rivigo.com -d ${JIRA_ID}_meta_store --port 27017 --username ms_123 --password 'ms@123' /home/ec2-user/slowqueries/MongoCreateCluster/mongodump-${JIRA_ID}-${BUILD_ID}/meta_store
        #mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com -e "grant all on `${JIRA_ID}_rivigo_invoicing`.* to 'invoicing_service@'10.0.%' identified by 'Invoicing#Service';";


        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-audit_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        #== ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data meta-store_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data invoicing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data cms_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data prime-billing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-reporting_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_meta-store --desired-count 1
        #sleep 200
        #sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-meta-store.sh ${JIRA_ID}_meta_store
    fi


    if [ "$REPO_NAME" == "prime-billing-backend" ]
    then
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/prime_billing_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_prime_billing_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_prime_billing_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_prime_billing_query.sql
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-prime-billing.sh ${JIRA_ID}_prime_billing

        cp /home/ec2-user/slowqueries/MongoCreateCluster/prime_billing.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_prime_billing.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_prime_billing.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_prime_billing.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_prime_billing.js"


        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data meta-store_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data invoicing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data cms_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-audit_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-reporting_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_prime-billing --desired-count 1
    fi

    if [ "$REPO_NAME" == "zoom-billing-backend" ]
    then
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/zoom_billing_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_zoom_billing_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_zoom_billing_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_zoom_billing_query.sql
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-zoom-billing.sh ${JIRA_ID}_zoom_billing

        cp /home/ec2-user/slowqueries/MongoCreateCluster/zoom_billing.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_zoom_billing.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_zoom_billing.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_zoom_billing.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_zoom_billing.js"


        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-meta-store.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-audit_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-reporting_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_zoom-billing --desired-count 1
    fi


    if [ "$REPO_NAME" == "cms-backend" ]
    then
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/cms_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_cms_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_cms_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_cms_query.sql

        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-cms.sh ${JIRA_ID}_contract_management_system

        cp /home/ec2-user/slowqueries/MongoCreateCluster/cms_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_cms_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_cms_js.js

        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_cms_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_cms_js.js"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $APP_NAME\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.meta.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data invoicing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data auditing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data prime-billing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-reporting_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1
    fi

    if [ "$REPO_NAME" == "collections-backend" ]
    then

        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/collection_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_collection_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_collection_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_collection_query.sql
        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-collection.sh ${JIRA_ID}_rivigo_collections
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/collection_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_collection_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_collection_js.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_collection_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_collection_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.meta.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1

    fi

    if [ "$REPO_NAME" == "vendor-management-system" ]
    then
        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/vms_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vms_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vms_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vms_query.sql
        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/vms.sh ${JIRA_ID}_vendor_management_system
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/vms_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_vms_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_vms_js.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_vms_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_vms_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.meta.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}.invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1

    fi

    if [ "$REPO_NAME" == "expense-payment" ]
    then
        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/expense_payment_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense_payment_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense_payment_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense_payment_query.sql
        #Copy Database
        #-- sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/vms.sh ${JIRA_ID}_vendor_management_system
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/expense_payment_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_expense_payment_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-meta-store.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1

    fi

    if [ "$REPO_NAME" == "vendor-contract-management-system" ]
    then
        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/vcms_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vcms_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vcms_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_vcms_query.sql
        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/vcms.sh ${JIRA_ID}_vendor_contract
        #Prepare Mongo (Mongo not used here)
        #cp /home/ec2-user/slowqueries/MongoCreateCluster/expense_payment_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js
        #sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js
        #scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_payment_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_expense_payment_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-meta-store.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1
    fi

    if [ "$REPO_NAME" == "expense-invoicing" ]
    then
        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/expense-invoicing_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-invoicing_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-invoicing_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-invoicing_query.sql
        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/expense-invoicing.sh ${JIRA_ID}_expense_invoicing
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/expense_invoicing_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_invoicing_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_invoicing_js.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_invoicing_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_expense_invoicing_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-meta-store.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1

    fi


    if [ "$REPO_NAME" == "expense-billing" ]
    then
        #Prepare DB
        cp /home/ec2-user/slowqueries/MysqlCreateCluster/expense-billing_query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-billing_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-billing_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${JIRA_ID}\_expense-billing_query.sql
        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/expense-billing.sh ${JIRA_ID}_expense_billing
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/expense_billing_js.js /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_billing_js.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_billing_js.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${JIRA_ID}\_expense_billing_js.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${JIRA_ID}\_expense_billing_js.js"

        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-meta-store.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-cms.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-invoicing.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1

    fi


    if [ "$REPO_NAME" == "invoicing-backend" ]
    then

        cp /home/ec2-user/slowqueries/MysqlCreateCluster/query.sql /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_query.sql
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_query.sql
        sudo mysql -u'root' -p'SqlDev!rivigo' -hforcluster-rivigo-dev-public-new.c90oafloutlv.ap-southeast-1.rds.amazonaws.com < /home/ec2-user/slowqueries/MysqlCreateCluster/${BUILD_ID}\_query.sql

        #Copy Database
        sudo sh /home/ec2-user/slowqueries/MysqlDumpScripts/belfort-invoicing.sh ${JIRA_ID}_rivigo_invoicing
        #Prepare Mongo
        cp /home/ec2-user/slowqueries/MongoCreateCluster/samplejs.js /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_query.js
        sed -i -e "s/JIRA_ID/${JIRA_ID}/g" /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_query.js
        scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no  /home/ec2-user/slowqueries/MongoCreateCluster/${BUILD_ID}\_query.js ec2-user@ecs-mongo.rivigo.com:/home/ec2-user/
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ec2-user@ecs-mongo.rivigo.com "sudo mongo localhost/admin --username admin --password 'CMSDev!R!^I7O' < /home/ec2-user/${BUILD_ID}\_query.js"
        
        mongodump --host ecs-mongo.rivigo.com -d develop_rivigo_invoicing --port 27017 --username invoicing_123 --password 'invoicing@123' --out /home/ec2-user/slowqueries/MongoCreateCluster/mongodump-${JIRA_ID}-${BUILD_ID}
        mongorestore --host ecs-mongo.rivigo.com -d ${JIRA_ID}_rivigo_invoicing --port 27017 --username invoicing_123 --password 'invoicing@123' /home/ec2-user/slowqueries/MongoCreateCluster/mongodump-${JIRA_ID}-${BUILD_ID}/develop_rivigo_invoicing


        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $appName\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data meta-store_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-audit_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data cms_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data prime-billing_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data finance-reporting_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition ${JIRA_ID}_invoicing --desired-count 1

    fi

    if [ "$REPO_NAME" == "compass-communication" ]
    then
        # DNS Entries
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data ${JIRA_ID}-$appName.stg.rivigo.com  3600 IN A 10.8.2.181"
        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $appName\_$JIRA_ID  --task-definition ${JIRA_ID}_compass-communication --desired-count 1

    fi

    if [ "$REPO_NAME" == "rivigo-finance-ui" ]
    then
        #ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.56.97 "sudo unbound-control local_data $APP_NAME\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"
        ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no ubuntu@10.8.56.97 "sudo unbound-control local_data $APP_NAME\_${JIRA_ID}-dev.stg.rivigo.com  3600 IN A 10.8.2.181"

        aws ecs create-service --cluster Belfort-dev1-Cluster --service-name $APP_NAME\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1
        rm -rf ./tmp
        echo "URL : "
        echo "${APP_NAME}_${JIRA_ID}-dev.services.stg.rivigo.com"
    fi

fi


if [ $Update_MicroService = 'true' ]
then
    echo "Updating Microservice"
    set +e
    rm -rf ./tmp
    mkdir tmp
    cd tmp
    git clone git@bitbucket.org:rivigotech/${REPO_NAME}.git
    cd $REPO_NAME
    git checkout $BUILD_BRANCH
    git rev-parse HEAD
    git pull origin $BUILD_BRANCH
    git rev-parse HEAD

    #-- git merge origin/master
    git commit -a -m "[pt-01] master merge" || echo 'nothing to commit'
    echo "---------------------"

    ## Disable for time being

    git merge --no-edit origin/$BRANCH

    if [ "$JIRA_ID" != "develop" ]
    then
        git push origin $BUILD_BRANCH
        echo "HI"

    fi

    if [[ $Connect_To_Preprod == 'false' ]]
    then
        sh builder.sh ${ENV} ${JIRA_ID}
    fi
    if [[ $Connect_To_Preprod == 'true' ]]
    then
        sh builder.sh ${ENV} ${JIRA_ID}
    fi


    cd ../
    git clone git@bitbucket.org:rivigotech/ecs-builds.git
    sudo \cp ecs-builds/task_definitions/${APP_NAME}.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json
    sudo \cp /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s/Container_name/${APP_NAME}__$JIRA_ID/g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s#JIRA_ID#$JIRA_ID#g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s/Container_Port/$App_Container_Port/g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json
    sed -i -e "s#APP_NAME#$APP_NAME#g" /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json

    
    cp -r $REPO_NAME ${REPO_NAME}_${JIRA_ID}
    zip -r ${REPO_NAME}_dev_${BUILD_ID}.zip ${REPO_NAME}_${JIRA_ID}
    scp -i /home/ec2-user/slowqueries/riv_devops.pem  -o StrictHostKeyChecking=no ${REPO_NAME}_dev_${BUILD_ID}.zip centos@10.8.48.108:/home/centos/
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo unzip -o ${REPO_NAME}_dev_${BUILD_ID}.zip"
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo docker build -t 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}:${JIRA_ID} /home/centos/${REPO_NAME}_${JIRA_ID} --build-arg jiraId=${JIRA_ID}"
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo docker push 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/${APP_NAME}"
    
    #Remove the zip
    ssh -i /home/ec2-user/slowqueries/riv_devops.pem -o StrictHostKeyChecking=no centos@10.8.48.108 "sudo rm -rf /home/centos/${REPO_NAME}_${JIRA_ID} /home/centos/${REPO_NAME}_dev_${BUILD_ID}.zip"
    
    aws ecs register-task-definition --cli-input-json file:///home/ec2-user/slowqueries/ECS_TASKS/$appName\_${JIRA_ID}.json
    aws ecs update-service --force-new-deployment --cluster Belfort-dev1-Cluster --service $appName\_$JIRA_ID  --task-definition $JIRA_ID\_$APP_NAME --desired-count 1
    rm /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}\_${JIRA_ID}.json /home/ec2-user/slowqueries/ECS_TASKS/${APP_NAME}_sampletask.json


fi


if [ $Create_New_MicroService = 'true' ]
then
    echo "${appName}_${JIRA_ID}" | sudo tee -a $filepath
fi



# Write to ENV file
# --------------------
env_appName=${appName}
env_JIRA_ID=${JIRA_ID}
env_BRANCH=${BRANCH}
env_DESTINATION_BRANCH=${DESTINATION_BRANCH}

cd /var/lib/jenkins/workspace/New-vip-ECS2_Docker_belfort-ui--Dev_Build
touch environmentVariables.properties
echo "APP_NAME=$env_appName" > environmentVariables.properties
echo "JIRA_ID=$env_JIRA_ID" >> environmentVariables.properties
echo "BRANCH=$env_BRANCH" >> environmentVariables.properties
echo "DESTINATION_BRANCH=$env_DESTINATION_BRANCH" >> environmentVariables.properties
echo "PR_URL=$PR_URL" >> environmentVariables.properties
echo "DESCRIPTION=$DESCRIPTION" >> environmentVariables.properties
