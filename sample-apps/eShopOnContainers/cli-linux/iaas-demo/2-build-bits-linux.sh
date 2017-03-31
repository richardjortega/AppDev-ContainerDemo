
projectList=(
    "../../src/Services/Catalog/Catalog.API"
    "../../src/Services/Basket/Basket.API"
    "../../src/Services/Ordering/Ordering.API"
    "../../src/Services/Identity/Identity.API"
    "../../src/Web/WebMVC"
    # "../src/Web/WebSPA"
)

# Build SPA app
#pushd $(pwd)/src/Web/WebSPA
#npm rebuild node-sass
#npm run build:prod

for project in "${projectList[@]}"
do
    echo -e "\e[33mWorking on $(pwd)/$project"
    echo -e "\e[33m\tRemoving old publish output"
    pushd $(pwd)/$project
    sudo rm -rf obj/Docker/publish
    echo -e "\e[33m\tRestoring project"
    /usr/local/bin/dotnet restore
    echo -e "\e[33m\tBuilding and publishing projects"
    /usr/local/bin/dotnet publish -o obj/Docker/publish
    popd
done

# remove old docker images:
echo ""
echo "Remove any existing eShop docker images on the build box...."
images=$(sudo docker images --filter=reference="eshop/*" -q)
if [ -n "$images" ]; then
    docker rm $(sudo docker ps -a -q) -f
    echo "Deleting eShop images in local Docker repo"
    echo $images
    docker rmi $(sudo docker images --filter=reference="eshop/*" -q) -f
fi

# No need to build the images, docker build or docker compose will
# do that using the images and containers defined in the docker-compose.yml file.