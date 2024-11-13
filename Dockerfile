# 使用 Python 3.9 作為基礎映像
FROM python:3.9-slim

# 安裝必要的系統依賴
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    unzip \
    && apt-get clean

# 安裝特定版本的 Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable=131.0.6228.0-1 \
    && apt-get clean

# 下載對應版本的 ChromeDriver
RUN CHROMEDRIVER_VERSION=131.0.6228.0 \
    && wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip \
    && rm chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver

# 設定環境變數
ENV DISPLAY=:99
ENV CHROME_BIN=/usr/bin/google-chrome-stable

# 設定工作目錄
WORKDIR /app

# 複製 requirements.txt 並安裝 Python 依賴
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 複製應用程式的所有文件
COPY . .

# 暴露端口
EXPOSE 8080

# 設定容器啟動後執行的命令
CMD ["python", "openAIcost.py"]
