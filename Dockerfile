FROM python:3.11

# Set the working directory
WORKDIR /app

# Install nodejs
RUN apt update && \
    apt install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI using the official Docker installation script
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh


# Add Adoptium repository for OpenJDK
RUN mkdir -p /etc/apt/keyrings && \
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    temurin-17-jdk=17.0.13.0.0+11 \
    maven=3.8.7-1 && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the application code
# Do this last to take advantage of the docker layer mechanism
COPY . /app

# Install Python dependencies
RUN pip install -e '.'

# Install react dependencies ahead of time
RUN cd sweagent/frontend && npm install
 