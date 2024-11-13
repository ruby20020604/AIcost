# 使用 Python 3.9 作為基礎映像
FROM python:3.9

# 安裝必要的系統依賴（不包括 Chrome 和 ChromeDriver）
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && apt-get clean

# 設定工作目錄
WORKDIR /app

# 複製 requirements.txt 並安裝 Python 依賴
COPY requirements.txt .
RUN pip install -r requirements.txt

# 複製應用程式的所有文件
COPY . .

# 設定容器啟動後執行的命令
CMD ["python", "openAIcost.py"]
