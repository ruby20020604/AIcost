# 使用官方的 Python 3.9 基礎映像
FROM python:3.9-slim

# 更新 apt-get 並安裝 wget、gnupg、curl 等工具
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    unzip \
    chromium=131.0.6789.116-1 \
    chromium-driver=131.0.6789.116-1 \
    && apt-get clean

# 設定 Google Chrome 和 Chromium 驅動程式的安裝目錄
ENV CHROMIUM_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_BIN=/usr/local/bin/chromedriver

# 安裝 Python 依賴
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 複製你的程式碼到容器中
COPY . /app

# 設定工作目錄
WORKDIR /app

# 執行程式
CMD ["python", "openAIcost_run.py"]
