FROM python:3.9

# 安裝必要的依賴和 Chrome 驅動
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    chromium=114.0.5735.133-1 \
    chromium-driver=114.0.5735.133-1 \
    # 安裝其他依賴
    && apt-get clean

# 安裝 Python 依賴
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# 複製應用文件
COPY . .

# 設置啟動命令
CMD ["python", "openAIcost.py"]
