rgName="learn-functions-docker-group"
appserviceplanName="learn-functions-docker-group"
containerRegistryName="learnfunctionsdockerregistry"
storageName="learnfunctiondockerstore"
functionAppName="learn-function-docker-function"
skuStorage="Standard_LRS"
functionsVersion="4"
zipfileName="functions-test-docker-function.zip"
location="westeurope"
functionAppPlan="learndockerfunctionplan"
containerImage="learndockerfunctionapp"

echo "building project"
cargo build --release

echo "(re)creating resource group"
rgExist=`az group exists -n $rgName`
if $rgExist
then
    az group delete -n $rgName -y
fi
az group create -l $location -n $rgName

echo "creating container registry"
az acr create -n $containerRegistryName -g $rgName --sku Basic --admin-enabled true

echo "fetch credentials for container registry"
acrUsr=`az acr credential show --name $containerRegistryName --query username`
acrPwd=`az acr credential show --name $containerRegistryName --query passwords[0].value`
acrPwd=${acrPwd:1:-1}
acrUsr=${acrUsr:1:-1}

echo "creating new storage account"
az storage account create --name $storageName --location $location --resource-group $rgName --sku $skuStorage

echo "creating function app plan"
az functionapp plan create --resource-group $rgName --name $functionAppPlan\
    --location $location --number-of-workers 1 --sku EP1 --is-linux


echo "building docker image"
docker build --no-cache -t $containerImage .
echo "logging in to Azure Container Registry"
docker login $containerRegistryName.azurecr.io -u $acrUsr -p $acrPwd
echo "tagging image"
docker tag $containerImage $containerRegistryName.azurecr.io/$containerImage
echo "pushing image to container registry"
docker push $containerRegistryName.azurecr.io/$containerImage


echo "creating functionapp"
az functionapp create --name $functionAppName --storage-account $storageName \
    --resource-group $rgName --plan $functionAppPlan \
    --deployment-container-image-name $containerRegistryName.azurecr.io/$containerImage \
    --functions-version $functionsVersion

func azure functionapp publish $functionAppName
