FROM centos:7

# Create anana directory
RUN mkdir -p /usr/anana
WORKDIR /usr/anana

# Copy files
COPY . /usr/anana

# Add microsoft repo
# Install the odbc driver https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15
# Rename the driver - https://docs.genesys.com/Documentation/FR/latest/DBConn/MSSQL
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo && \
	ACCEPT_EULA=Y yum -y install msodbcsql17 && \
	sed -i 's/\[ODBC Driver 17 for SQL Server\]/[SQL Server]/g' /etc/odbcinst.ini

# Deploy Config Server
# tar -czvf cfgsvr-8510160b1.tar.gz /usr/genesys/cfgsvr-01
# To copy the tar.gz from the server - docker cp 03350a8c3aba:/usr/genesys/cfgsvr-8510160b1.tar.gz .
RUN mkdir -p /usr/genesys/cfgsvr-01 && \
	tar -xf cfgsvr-8510160b1.tar.gz --directory /
	
EXPOSE 2020

WORKDIR /usr/genesys/cfgsvr-01
CMD ./run.sh