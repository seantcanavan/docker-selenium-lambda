import os
from tempfile import mkdtemp

from selenium import webdriver
from selenium.webdriver.common.by import By

chrome_driver_location = os.environ.get("CHROME_DRIVER_LOCATION", "/usr/bin/chromedriver")
chrome_binary_location = os.environ.get("CHROME_BINARY_LOCATION", "/opt/chrome-linux64/chrome")

# Define selenium driver globally so that shared lambda contexts re-use it
# This drastically reduces startup times
options = webdriver.ChromeOptions()
# service = webdriver.ChromeService("/opt/chromedriver")
service = webdriver.ChromeService(chrome_driver_location)

# options.binary_location = '/opt/chrome/chrome'
options.binary_location = chrome_binary_location
options.add_argument("--headless=new")
options.add_argument('--no-sandbox')
options.add_argument("--disable-gpu")
options.add_argument("--window-size=1280x1696")
options.add_argument("--single-process")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-dev-tools")
options.add_argument("--no-zygote")
options.add_argument(f"--user-data-dir={mkdtemp()}")
options.add_argument(f"--data-path={mkdtemp()}")
options.add_argument(f"--disk-cache-dir={mkdtemp()}")
options.add_argument("--remote-debugging-port=9222")
chrome = webdriver.Chrome(options=options, service=service)


# lambda handler entry point - configured via Dockerfile / Serverless.yml
def handler(event=None, context=None):
    print(event)
    print(context)

    chrome.get("https://example.com/")
    return chrome.find_element(by=By.XPATH, value="//html").text


def local_handler(event=None, context=None):
    chrome.get("https://example.com/")
    print(chrome.find_element(by=By.XPATH, value="//html").text)


# When running locally, we need a new entry-point
if __name__ == "__main__":
    local_handler()
