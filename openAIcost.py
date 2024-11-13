import subprocess
import asyncio
from telegram import Bot

# Telegram Bot 配置
token = '8011582671:AAFS55JRsSEcBEh7xmys_mQYCoB-MocNDGs'
chat_id = '-4576563147'

async def send_to_telegram(message):
    """非同步地發送訊息到 Telegram"""
    bot = Bot(token=token)
    await bot.send_message(chat_id=chat_id, text=message)

def main():
    # 在 Render 環境中啟動 Chrome
    chrome_command = [
        "chromium",
        "--no-sandbox",
        "--headless",
        "--remote-debugging-port=9222",
        "--disable-gpu",
        "--disable-dev-shm-usage"
    ]
    subprocess.Popen(chrome_command)

    # 啟動主要腳本
    python_command = ["python", "openAIcost_run.py"]
    process = subprocess.Popen(python_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    buffer = []

    try:
        while True:
            output = process.stdout.readline()
            if output == "" and process.poll() is not None:
                break

            if output.strip():
                buffer.append(output.strip())
            else:
                if buffer:
                    message = "\n".join(buffer)
                    print(message)
                    loop.run_until_complete(send_to_telegram(message))
                    buffer.clear()

        if buffer:
            message = "\n".join(buffer)
            print(message)
            loop.run_until_complete(send_to_telegram(message))

        stderr = process.stderr.read()
        if stderr:
            print("Error:", stderr)
            loop.run_until_complete(send_to_telegram(f"Error: {stderr.strip()}"))

    except Exception as e:
        error_message = f"執行過程中發生錯誤: {str(e)}"
        print(error_message)
        loop.run_until_complete(send_to_telegram(error_message))

    finally:
        loop.close()
        try:
            subprocess.run(["pkill", "chromium"])
        except:
            pass

if __name__ == "__main__":
    main()
