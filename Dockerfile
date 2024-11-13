FROM python:3.9

# Install Chrome and required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    chromium \
    chromium-driver

# Install Python dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application files
COPY . .

# Command to run the application
CMD ["python", "openAIcost.py"]