# 使用 Python 3.9 作為基礎映像
FROM python:3.9-slim

# 安裝必要的系統依賴
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    chromium \
    chromium-driver \
    && apt-get clean

# 設定環境變數，告訴 Selenium 和 undetected-chromedriver 使用的 Chrome 路徑
ENV DISPLAY=:99
ENV CHROME_BIN=/usr/bin/chromium

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
