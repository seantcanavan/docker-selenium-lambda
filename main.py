import os
import sys
from os import environ
from tempfile import mkdtemp

from selenium import webdriver
from selenium.webdriver.common.by import By

options = webdriver.ChromeOptions()
service = webdriver.ChromeService("/opt/chromedriver")

options.binary_location = '/opt/chrome/chrome'
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


# lambda handler entry point
def handler(event=None, context=None):
    print("Python version")
    print(sys.version)
    print("Version info.")
    print(sys.version_info)

    for key, value in os.environ.items():
        print(f"{key}: {value}")

    chrome.get("https://example.com/")

    return environ.get("TEST_ENV") + "HITHERE" + chrome.find_element(by=By.XPATH, value="//html").text


def local_handler(event=None, context=None):
    print("hi local python")
