
docker stop owncloud mysql-owncloud ; docker rm -v owncloud mysql-owncloud

docker run --name mysql-owncloud -v $(readlink -f $(dirname $0))/mysql/data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=<YOUR_PW_HERE> \
    -d mysql

docker run --name owncloud -p 80 -v $(readlink -f $(dirname $0))/oc/data:/var/lib/owncloud/data \
    -v $(readlink -f $(dirname $0))/oc/docroot:/app \
    --link mysql-owncloud:mysql -d local/owncloud
