FROM mcr.microsoft.com/azure-functions/dotnet:4-appservice 
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# Update new packages
RUN apt update

#install rScript
#RUN apt install -y r-base && \
#    R -e "install.packages('httpuv', repos='http://cran.rstudio.com/')"

COPY . /home/site/wwwroot